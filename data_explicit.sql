-- Données explicites (seed) : CA par Vol - Janvier 2026
-- Date: 2026-01-23
--
-- Jeu de données (selon la photo):
--   - Destination: TNR - Nosy Be
--   - Avion: ATR - 045
--   - Vols:
--     * 20 janvier 2026 - 10h: 40 billets adulte éco, Pub Vaniala 1, Pub Lewis 1
--     * 21 janvier 2026 - 10h: 30 billets adulte éco, Pub socobis 2, Pub Jejoo 1
--     * 21 janvier 2026 - 15h: 50 billets adulte éco, 0 pub
--   - Rappel: Billet adulte économique = 800 000 Ar

BEGIN;

-- Nettoyage (pour pouvoir rejouer le script sans doublons)
TRUNCATE TABLE
    billet,
    passager,
    reservation,
    paiement,
    diffusion_vol,
    achat_diffusion,
    societe,
    tarif_diffusion,
    vol,
    trajet,
    pays_aeroport,
    place,
    modepaiement,
    pays,
    aeroport,
    avion
RESTART IDENTITY CASCADE;

COMMIT;

-- =====================================================
-- Référentiels: catégories + tarifs + modes de paiement
-- =====================================================

INSERT INTO categorie (libelle) VALUES
('adulte'),
('enfant'),
('bebe')
ON CONFLICT (libelle) DO NOTHING;

-- Tarif économique adulte = 800 000 Ar
INSERT INTO tarif_classe (type_place, tarif) VALUES
('premiere_classe', 2000000),
('premium', 1000000),
('economique', 800000)
ON CONFLICT (type_place) DO UPDATE SET tarif = EXCLUDED.tarif;

INSERT INTO modepaiement (libelle) VALUES
('Mobile Money')
ON CONFLICT (libelle) DO NOTHING;

-- =====================================================
-- Données de vol: TNR - Nosy Be avec avion ATR-045
-- =====================================================

INSERT INTO pays (nom) VALUES
('Madagascar');

-- Aéroports
INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport', 'Antananarivo', 'TNR'),
('Fascene Airport', 'Nosy Be', 'NOS')
ON CONFLICT (code) DO UPDATE
    SET nom = EXCLUDED.nom,
        ville = EXCLUDED.ville;

-- Associer les aéroports au pays Madagascar
INSERT INTO pays_aeroport (idaeroport, idpays)
SELECT a.idaeroport, p.idpays
FROM aeroport a
JOIN pays p ON p.nom = 'Madagascar'
WHERE a.code IN ('TNR', 'NOS')
ON CONFLICT DO NOTHING;

-- Trajet TNR -> Nosy Be
INSERT INTO trajet (idaeroportdepart, idaeroportarrive)
SELECT ad.idaeroport, aa.idaeroport
FROM aeroport ad
JOIN aeroport aa ON aa.code = 'NOS'
WHERE ad.code = 'TNR'
ON CONFLICT DO NOTHING;

-- Avion ATR-045 avec capacité 120 places économiques
INSERT INTO avion (modele, capacite, code)
VALUES ('ATR 72-600', 120, 'ATR-045')
ON CONFLICT (code) DO UPDATE
    SET modele = EXCLUDED.modele,
        capacite = EXCLUDED.capacite;

-- 120 places économiques pour ATR-045
WITH a AS (
    SELECT idavion FROM avion WHERE code = 'ATR-045'
)
INSERT INTO place (numeroplace, type_place, idavion)
SELECT
    gs.numeroplace,
    'economique' AS type_place,
    a.idavion
FROM generate_series(1, 120) AS gs(numeroplace)
CROSS JOIN a
ON CONFLICT (numeroplace, idavion) DO UPDATE
    SET type_place = EXCLUDED.type_place;

-- Tarif de diffusion publicitaire: 400 000 Ar par diffusion
INSERT INTO tarif_diffusion (cout_par_diffusion, date_debut)
VALUES (400000, '2026-01-01');

-- =====================================================
-- 3 VOLS DE JANVIER 2026 - TNR vers Nosy Be
-- =====================================================

-- VOL JAN001: 20 janvier 2026 - 10h (40 billets)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'JAN001', '2026-01-20', '2026-01-20', '10:00', '11:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'ATR-045'
WHERE ad.code = 'TNR' AND aa.code = 'NOS'
AND NOT EXISTS (SELECT 1 FROM vol WHERE numerovol = 'JAN001');

-- VOL JAN002: 21 janvier 2026 - 10h (30 billets)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'JAN002', '2026-01-21', '2026-01-21', '10:00', '11:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'ATR-045'
WHERE ad.code = 'TNR' AND aa.code = 'NOS'
AND NOT EXISTS (SELECT 1 FROM vol WHERE numerovol = 'JAN002');

-- VOL JAN003: 21 janvier 2026 - 15h (50 billets)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'JAN003', '2026-01-21', '2026-01-21', '15:00', '16:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'ATR-045'
WHERE ad.code = 'TNR' AND aa.code = 'NOS'
AND NOT EXISTS (SELECT 1 FROM vol WHERE numerovol = 'JAN003');

-- =====================================================
-- RÉSERVATIONS, PASSAGERS, PAIEMENTS ET BILLETS
-- JAN001: 40 billets, JAN002: 30 billets, JAN003: 50 billets
-- =====================================================

DO $$
DECLARE
    v_idvol INTEGER;
    v_idavion INTEGER;
    v_idcategorie INTEGER;
    v_idmodepaiement INTEGER;
    v_idplace INTEGER;
    v_idreservation INTEGER;
    v_idpaiement INTEGER;
    v_vol RECORD;
    i INTEGER;
    nb_billets INTEGER;
BEGIN
    -- Récupérer l'ID de catégorie adulte et mode de paiement
    SELECT idcategorie INTO v_idcategorie FROM categorie WHERE libelle = 'adulte' LIMIT 1;
    SELECT idmodepaiement INTO v_idmodepaiement FROM modepaiement WHERE libelle = 'Mobile Money' LIMIT 1;
    
    -- Boucle sur les 3 vols de janvier
    FOR v_vol IN (
        SELECT numerovol, idvol, idavion, 
               CASE 
                   WHEN numerovol = 'JAN001' THEN 40
                   WHEN numerovol = 'JAN002' THEN 30
                   WHEN numerovol = 'JAN003' THEN 50
               END AS nb_billets
        FROM vol 
        WHERE numerovol IN ('JAN001', 'JAN002', 'JAN003')
        ORDER BY numerovol
    ) LOOP
        -- Vérifier si ce vol a déjà des billets
        IF NOT EXISTS (
            SELECT 1 FROM reservation r 
            JOIN billet b ON b.idreservation = r.idreservation 
            WHERE r.idvol = v_vol.idvol
        ) THEN
            nb_billets := v_vol.nb_billets;
            
            FOR i IN 1..nb_billets LOOP
                -- Trouver une place libre pour ce vol
                SELECT p.idplace INTO v_idplace
                FROM place p
                WHERE p.idavion = v_vol.idavion
                  AND p.numeroplace = i
                  AND NOT EXISTS (
                      SELECT 1 FROM reservation r2 
                      WHERE r2.idplace = p.idplace AND r2.idvol = v_vol.idvol
                  )
                LIMIT 1;
                
                IF v_idplace IS NOT NULL THEN
                    -- Créer la réservation
                    INSERT INTO reservation (datereservation, idvol, idplace, idcategorie)
                    VALUES ('2026-01-15 10:00:00'::timestamp, v_vol.idvol, v_idplace, v_idcategorie)
                    RETURNING idreservation INTO v_idreservation;
                    
                    -- Créer le passager
                    INSERT INTO passager (nom, prenom, datenaissance, numeropasseport, nationalite, telephone, email, idreservation)
                    VALUES (
                        'PASSAGER_' || v_vol.numerovol || '_' || i,
                        'Test',
                        '1990-01-01'::date,
                        'P' || v_vol.numerovol || LPAD(i::text, 3, '0'),
                        'MG',
                        '0340000000',
                        'test' || v_vol.numerovol || '_' || i || '@example.com',
                        v_idreservation
                    );
                    
                    -- Créer le paiement (800 000 Ar pour adulte éco)
                    INSERT INTO paiement (montant, datepaiement, idmodepaiement)
                    VALUES (800000, '2026-01-15 10:05:00'::timestamp, v_idmodepaiement)
                    RETURNING idpaiement INTO v_idpaiement;
                    
                    -- Créer le billet
                    INSERT INTO billet (prix, classe, idreservation, idpaiement)
                    VALUES (800000, 'Economique', v_idreservation, v_idpaiement);
                END IF;
            END LOOP;
        END IF;
    END LOOP;
END $$;

-- =====================================================
-- SOCIETES PUBLICITAIRES - JANVIER 2026
-- =====================================================

-- 4 sociétés: Vaniala, Lewis, socobis, Jejoo
INSERT INTO societe (nom, adresse, telephone, email) VALUES
('Vaniala', 'Antananarivo, Madagascar', '0341234567', 'contact@vaniala.mg'),
('Lewis', 'Antananarivo, Madagascar', '0349876543', 'contact@lewis.mg'),
('socobis', 'Antananarivo, Madagascar', '0342223344', 'contact@socobis.mg'),
('Jejoo', 'Antananarivo, Madagascar', '0345556677', 'contact@jejoo.mg')
ON CONFLICT DO NOTHING;

-- Achats de diffusions pour janvier 2026
-- Vaniala: 1 diffusion (pour JAN001)
INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 1, 2026, 1, 400000
FROM societe s WHERE s.nom = 'Vaniala';

-- Lewis: 1 diffusion (pour JAN001)
INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 1, 2026, 1, 400000
FROM societe s WHERE s.nom = 'Lewis';

-- socobis: 2 diffusions (pour JAN002)
INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 1, 2026, 2, 400000
FROM societe s WHERE s.nom = 'socobis';

-- Jejoo: 1 diffusion (pour JAN002)
INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 1, 2026, 1, 400000
FROM societe s WHERE s.nom = 'Jejoo';

-- =====================================================
-- AFFECTATION DES DIFFUSIONS AUX VOLS
-- JAN001: Vaniala 1, Lewis 1
-- JAN002: socobis 2, Jejoo 1
-- JAN003: 0 pub
-- =====================================================

-- Diffusion Vaniala sur JAN001 (1 diffusion)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT a.idachat, v.idvol
FROM achat_diffusion a 
JOIN societe s ON a.idsociete = s.idsociete 
JOIN vol v ON v.numerovol = 'JAN001'
WHERE s.nom = 'Vaniala' AND a.mois = 1 AND a.annee = 2026;

-- Diffusion Lewis sur JAN001 (1 diffusion)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT a.idachat, v.idvol
FROM achat_diffusion a 
JOIN societe s ON a.idsociete = s.idsociete 
JOIN vol v ON v.numerovol = 'JAN001'
WHERE s.nom = 'Lewis' AND a.mois = 1 AND a.annee = 2026;

-- Diffusions socobis sur JAN002 (2 diffusions)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT a.idachat, v.idvol
FROM achat_diffusion a 
JOIN societe s ON a.idsociete = s.idsociete 
JOIN vol v ON v.numerovol = 'JAN002'
CROSS JOIN generate_series(1, 2)
WHERE s.nom = 'socobis' AND a.mois = 1 AND a.annee = 2026;

-- Diffusion Jejoo sur JAN002 (1 diffusion)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT a.idachat, v.idvol
FROM achat_diffusion a 
JOIN societe s ON a.idsociete = s.idsociete 
JOIN vol v ON v.numerovol = 'JAN002'
WHERE s.nom = 'Jejoo' AND a.mois = 1 AND a.annee = 2026;

-- JAN003: 0 pub - rien à insérer

-- =====================================================
-- VÉRIFICATION DU CA PAR VOL - JANVIER 2026
-- =====================================================

-- Résumé des vols janvier 2026
SELECT 
    v.numerovol,
    v.datedepart,
    v.heuredepart,
    ad.code AS depart,
    aa.code AS arrivee,
    av.code AS avion,
    COUNT(DISTINCT b.idbillet) AS nb_billets,
    COALESCE(SUM(b.prix), 0) AS ca_billets,
    (SELECT COUNT(*) FROM diffusion_vol dv WHERE dv.idvol = v.idvol) AS nb_diffusions,
    (SELECT COUNT(*) FROM diffusion_vol dv WHERE dv.idvol = v.idvol) * 400000 AS ca_diffusions
FROM vol v
JOIN trajet t ON v.idtrajet = t.idtrajet
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion av ON v.idavion = av.idavion
LEFT JOIN reservation r ON r.idvol = v.idvol
LEFT JOIN billet b ON b.idreservation = r.idreservation
WHERE v.numerovol IN ('JAN001', 'JAN002', 'JAN003')
GROUP BY v.idvol, v.numerovol, v.datedepart, v.heuredepart, ad.code, aa.code, av.code
ORDER BY v.datedepart, v.heuredepart;

-- Détail des diffusions par vol
SELECT 
    v.numerovol,
    v.datedepart,
    v.heuredepart,
    s.nom AS societe,
    COUNT(dv.iddiffusion) AS nb_diffusions
FROM diffusion_vol dv
JOIN achat_diffusion a ON dv.idachat = a.idachat
JOIN societe s ON a.idsociete = s.idsociete
JOIN vol v ON dv.idvol = v.idvol
WHERE v.numerovol IN ('JAN001', 'JAN002', 'JAN003')
GROUP BY v.numerovol, v.datedepart, v.heuredepart, s.nom
ORDER BY v.datedepart, v.heuredepart, s.nom;
