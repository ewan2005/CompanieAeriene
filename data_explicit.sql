-- Données explicites (seed) : capacités par classe + réservations + paiements
-- Date: 2026-01-21
--
-- Besoin demandé:
--  - Première classe : 2 bébé, 4 enfant, 10 adulte
--  - Premium        : 4 bébé, 5 enfant, 20 adulte
--  - Economique     : 4 bébé, 10 enfant, 30 adulte
--  - Tarif adulte en économique = 900000 Ar

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

-- Mise à jour / insertion des tarifs (selon commande.txt)
--  - premiere_classe adulte = 2 000 000 Ar
--  - premium         adulte = 1 000 000 Ar
--  - economique      adulte =   900 000 Ar
INSERT INTO tarif_classe (type_place, tarif) VALUES
('premiere_classe', 2000000),
('premium', 1000000),
('economique', 900000)
ON CONFLICT (type_place) DO UPDATE SET tarif = EXCLUDED.tarif;

-- Règles de remise/prix par catégorie (comme dans commande.txt / data.sql)
-- Enfant (prix final souhaité):
--  - premiere_classe: 800000 => remise = 2000000 - 800000 = 1200000
--  - premium        : 700000 => remise = 1000000 - 700000 = 300000
--  - economique     : 600000 => (règle spéciale) montant_remise stocke le PRIX FINAL
INSERT INTO remise_categorie (type_place, idcategorie, montant_remise)
SELECT vals.type_place, c.idcategorie, vals.montant_remise
FROM categorie c
JOIN (
	VALUES
		('premiere_classe', 1200000.00),
		('premium', 300000.00),
		('economique', 600000.00)
) AS vals(type_place, montant_remise) ON c.libelle = 'enfant'
ON CONFLICT (type_place, idcategorie) DO UPDATE
	SET montant_remise = EXCLUDED.montant_remise;

-- Bébé: prix final = 10% du tarif adulte (tarif adulte * 0.10) pour toutes les classes
INSERT INTO remise_categorie (type_place, idcategorie, montant_remise)
SELECT tc.type_place, c.idcategorie, (tc.tarif * 0.10)
FROM tarif_classe tc
JOIN categorie c ON c.libelle = 'bebe'
ON CONFLICT (type_place, idcategorie) DO UPDATE
	SET montant_remise = EXCLUDED.montant_remise;

INSERT INTO modepaiement (libelle) VALUES
('Mobile Money')
ON CONFLICT (libelle) DO NOTHING;

-- =====================================================
-- Données de vol (aéroports, trajet, avion, places, vol)
-- =====================================================

INSERT INTO pays (nom) VALUES
('Madagascar');

INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport (Seed)', 'Antananarivo', 'TNRX'),
('Fascene Airport (Seed)', 'Nosy Be', 'NOSX')
ON CONFLICT (code) DO UPDATE
	SET nom = EXCLUDED.nom,
			ville = EXCLUDED.ville;

INSERT INTO pays_aeroport (idaeroport, idpays)
SELECT a.idaeroport, p.idpays
FROM aeroport a
JOIN pays p ON p.nom = 'Madagascar'
WHERE a.code IN ('TNRX', 'NOSX')
ON CONFLICT DO NOTHING;

INSERT INTO trajet (idaeroportdepart, idaeroportarrive)
SELECT ad.idaeroport, aa.idaeroport
FROM aeroport ad
JOIN aeroport aa ON aa.code = 'NOSX'
WHERE ad.code = 'TNRX'
ON CONFLICT DO NOTHING;

-- Avion de démonstration : 89 places au total (16 première, 29 premium, 44 éco)
INSERT INTO avion (modele, capacite, code)
VALUES ('SeedPlane-89', 89, 'SIMU89')
ON CONFLICT (code) DO UPDATE
	SET modele = EXCLUDED.modele,
			capacite = EXCLUDED.capacite;

-- Générer les 89 places avec répartition:
--  1..16  : premiere_classe
-- 17..45  : premium
-- 46..89  : economique
WITH a AS (
	SELECT idavion FROM avion WHERE code = 'SIMU89'
)
INSERT INTO place (numeroplace, type_place, idavion)
SELECT
	gs.numeroplace,
	CASE
		WHEN gs.numeroplace BETWEEN 1 AND 16 THEN 'premiere_classe'
		WHEN gs.numeroplace BETWEEN 17 AND 45 THEN 'premium'
		ELSE 'economique'
	END AS type_place,
	a.idavion
FROM generate_series(1, 89) AS gs(numeroplace)
CROSS JOIN a
ON CONFLICT (numeroplace, idavion) DO UPDATE
	SET type_place = EXCLUDED.type_place;

-- Vol de démonstration
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
	'SIMU001',
	'2026-02-10',
	'2026-02-10',
	'08:00',
	'09:30',
	t.idtrajet,
	a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'SIMU89'
WHERE ad.code = 'TNRX' AND aa.code = 'NOSX'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'SIMU001');

-- =====================================================
-- Réservations correspondant exactement aux quantités
-- =====================================================
-- Mapping par numéro de place:
-- Première (1..16):  1..2 bébé, 3..6 enfant, 7..16 adulte
-- Premium  (17..45): 17..20 bébé, 21..25 enfant, 26..45 adulte
-- Eco      (46..89): 46..49 bébé, 50..59 enfant, 60..89 adulte

WITH
v AS (
	SELECT idvol, idavion FROM vol WHERE numerovol = 'SIMU001' LIMIT 1
),
cats AS (
	SELECT libelle, idcategorie FROM categorie WHERE libelle IN ('adulte','enfant','bebe')
),
seats AS (
	SELECT
		p.idplace,
		p.numeroplace,
		p.type_place,
		v.idvol,
		CASE
			WHEN p.type_place = 'premiere_classe' AND p.numeroplace BETWEEN 1 AND 2 THEN 'bebe'
			WHEN p.type_place = 'premiere_classe' AND p.numeroplace BETWEEN 3 AND 6 THEN 'enfant'
			WHEN p.type_place = 'premiere_classe' THEN 'adulte'

			WHEN p.type_place = 'premium' AND p.numeroplace BETWEEN 17 AND 20 THEN 'bebe'
			WHEN p.type_place = 'premium' AND p.numeroplace BETWEEN 21 AND 25 THEN 'enfant'
			WHEN p.type_place = 'premium' THEN 'adulte'

			WHEN p.type_place = 'economique' AND p.numeroplace BETWEEN 46 AND 49 THEN 'bebe'
			WHEN p.type_place = 'economique' AND p.numeroplace BETWEEN 50 AND 59 THEN 'enfant'
			ELSE 'adulte'
		END AS cat_libelle
	FROM v
	JOIN place p ON p.idavion = v.idavion
	WHERE p.numeroplace BETWEEN 1 AND 89
)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT
	s.numeroplace AS idreservation,
	'2026-01-21 10:00:00'::timestamp,
	s.idvol,
	s.idplace,
	c.idcategorie
FROM seats s
JOIN cats c ON c.libelle = s.cat_libelle
ORDER BY s.numeroplace;

-- Passagers (1 par réservation)
INSERT INTO passager (nom, prenom, datenaissance, numeropasseport, nationalite, telephone, email, idreservation)
SELECT
	CASE
		WHEN LOWER(c.libelle) = 'bebe' THEN 'BEBE_' || r.idreservation
		WHEN LOWER(c.libelle) = 'enfant' THEN 'ENFANT_' || r.idreservation
		ELSE 'ADULTE_' || r.idreservation
	END AS nom,
	'Test' AS prenom,
	CASE
		WHEN LOWER(c.libelle) = 'bebe' THEN '2025-06-01'::date
		WHEN LOWER(c.libelle) = 'enfant' THEN '2016-01-01'::date
		ELSE '1990-01-01'::date
	END AS datenaissance,
	'P' || LPAD(r.idreservation::text, 6, '0') AS numeropasseport,
	'MG' AS nationalite,
	'0340000000' AS telephone,
	('test' || r.idreservation || '@example.com') AS email,
	r.idreservation
FROM reservation r
JOIN categorie c ON c.idcategorie = r.idcategorie;

-- =====================================================
-- Paiements + billets (prix cohérents avec les règles Java)
-- =====================================================

WITH
mp AS (SELECT idmodepaiement FROM modepaiement WHERE libelle = 'Mobile Money' LIMIT 1),
priced AS (
	SELECT
		r.idreservation,
		p.type_place,
		COALESCE(c.libelle,'') AS categorie_libelle,
		tc.tarif,
		COALESCE(rc.montant_remise, 0) AS remise,
		CASE
			WHEN LOWER(COALESCE(c.libelle,'')) = 'bebe' THEN (tc.tarif * 0.10)
			WHEN p.type_place = 'economique' AND COALESCE(rc.montant_remise,0) > 0 THEN rc.montant_remise
			ELSE (tc.tarif - COALESCE(rc.montant_remise,0))
		END AS prix_final,
		CASE
			WHEN p.type_place = 'premiere_classe' THEN 'Premiere Classe'
			WHEN p.type_place = 'premium' THEN 'Premium'
			ELSE 'Economique'
		END AS classe_label
	FROM reservation r
	JOIN place p ON p.idplace = r.idplace
	JOIN tarif_classe tc ON tc.type_place = p.type_place
	LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie
	LEFT JOIN categorie c ON c.idcategorie = r.idcategorie
)
INSERT INTO paiement (idpaiement, montant, datepaiement, idmodepaiement)
SELECT
	pr.idreservation AS idpaiement,
	GREATEST(pr.prix_final, 0),
	'2026-01-21 10:05:00'::timestamp,
	mp.idmodepaiement
FROM priced pr
CROSS JOIN mp;

WITH priced AS (
	SELECT
		r.idreservation,
		p.type_place,
		COALESCE(c.libelle,'') AS categorie_libelle,
		tc.tarif,
		COALESCE(rc.montant_remise, 0) AS remise,
		CASE
			WHEN LOWER(COALESCE(c.libelle,'')) = 'bebe' THEN (tc.tarif * 0.10)
			WHEN p.type_place = 'economique' AND COALESCE(rc.montant_remise,0) > 0 THEN rc.montant_remise
			ELSE (tc.tarif - COALESCE(rc.montant_remise,0))
		END AS prix_final,
		CASE
			WHEN p.type_place = 'premiere_classe' THEN 'Premiere Classe'
			WHEN p.type_place = 'premium' THEN 'Premium'
			ELSE 'Economique'
		END AS classe_label
	FROM reservation r
	JOIN place p ON p.idplace = r.idplace
	JOIN tarif_classe tc ON tc.type_place = p.type_place
	LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie
	LEFT JOIN categorie c ON c.idcategorie = r.idcategorie
)
INSERT INTO billet (prix, classe, idreservation, idpaiement)
SELECT
	GREATEST(pr.prix_final, 0) AS prix,
	pr.classe_label,
	pr.idreservation,
	pr.idreservation AS idpaiement
FROM priced pr;

-- =====================================================
-- Contrôles (résumé)
-- =====================================================

-- Comptage par classe + catégorie (doit matcher la demande)
SELECT
	p.type_place,
	c.libelle AS categorie,
	COUNT(*) AS nb_reservations
FROM reservation r
JOIN place p ON p.idplace = r.idplace
JOIN categorie c ON c.idcategorie = r.idcategorie
GROUP BY p.type_place, c.libelle
ORDER BY p.type_place, c.libelle;

-- Vérif prix éco adulte = 900000
SELECT
	tc.type_place,
	tc.tarif
FROM tarif_classe tc
WHERE tc.type_place = 'economique';

-- =====================================================
-- SOCIETES PUBLICITAIRES ET DIFFUSIONS (Décembre 2025)
-- =====================================================
-- Règle: diffusion de pub sur les écrans de l'avion pendant un vol
-- Coût: 400 000 Ar par diffusion
-- Une société achète X diffusions pour un mois, puis on les affecte aux vols

-- Tarif de diffusion: 400 000 Ar par diffusion
INSERT INTO tarif_diffusion (cout_par_diffusion, date_debut)
VALUES (400000, '2025-01-01');

-- Sociétés publicitaires
INSERT INTO societe (nom, adresse, telephone, email) VALUES
('Vaniala', 'Antananarivo, Madagascar', '0341234567', 'contact@vaniala.mg'),
('Lewis', 'Antananarivo, Madagascar', '0349876543', 'contact@lewis.mg');

-- Créer des vols supplémentaires pour décembre 2025 (pour affecter les diffusions)
-- Vol 1: déjà créé (SIMU001) en février 2026
-- On ajoute des vols en décembre 2025

INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
	'DEC001',
	'2025-12-05',
	'2025-12-05',
	'08:00',
	'09:30',
	t.idtrajet,
	a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'SIMU89'
WHERE ad.code = 'TNRX' AND aa.code = 'NOSX'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'DEC001');

INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
	'DEC002',
	'2025-12-10',
	'2025-12-10',
	'14:00',
	'15:30',
	t.idtrajet,
	a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'SIMU89'
WHERE ad.code = 'TNRX' AND aa.code = 'NOSX'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'DEC002');

INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
	'DEC003',
	'2025-12-15',
	'2025-12-15',
	'10:00',
	'11:30',
	t.idtrajet,
	a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'SIMU89'
WHERE ad.code = 'TNRX' AND aa.code = 'NOSX'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'DEC003');

INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
	'DEC004',
	'2025-12-20',
	'2025-12-20',
	'16:00',
	'17:30',
	t.idtrajet,
	a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'SIMU89'
WHERE ad.code = 'TNRX' AND aa.code = 'NOSX'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'DEC004');

-- Achats de diffusions pour décembre 2025
-- Vaniala: 20 diffusions en décembre 2025
-- Lewis: 10 diffusions en décembre 2025
INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 12, 2025, 20, 400000
FROM societe s WHERE s.nom = 'Vaniala';

INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire)
SELECT s.idsociete, 12, 2025, 10, 400000
FROM societe s WHERE s.nom = 'Lewis';

-- Affectation des diffusions aux vols de décembre 2025
-- Vaniala: 20 diffusions réparties sur les 4 vols (5 par vol)
-- Lewis: 10 diffusions réparties sur les 4 vols

-- Diffusions Vaniala (20 au total)
WITH vaniala_achat AS (
    SELECT a.idachat FROM achat_diffusion a 
    JOIN societe s ON a.idsociete = s.idsociete 
    WHERE s.nom = 'Vaniala' AND a.mois = 12 AND a.annee = 2025
),
vols_dec AS (
    SELECT idvol, numerovol FROM vol WHERE numerovol LIKE 'DEC%' ORDER BY numerovol
)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT va.idachat, vd.idvol
FROM vaniala_achat va
CROSS JOIN (
    -- 5 diffusions sur DEC001
    SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    -- 5 diffusions sur DEC002
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    -- 5 diffusions sur DEC003
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    -- 5 diffusions sur DEC004
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
) vd;

-- Diffusions Lewis (10 au total)
WITH lewis_achat AS (
    SELECT a.idachat FROM achat_diffusion a 
    JOIN societe s ON a.idsociete = s.idsociete 
    WHERE s.nom = 'Lewis' AND a.mois = 12 AND a.annee = 2025
),
vols_dec AS (
    SELECT idvol, numerovol FROM vol WHERE numerovol LIKE 'DEC%' ORDER BY numerovol
)
INSERT INTO diffusion_vol (idachat, idvol)
SELECT la.idachat, vd.idvol
FROM lewis_achat la
CROSS JOIN (
    -- 3 diffusions sur DEC001
    SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC001'
    -- 3 diffusions sur DEC002
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC002'
    -- 2 diffusions sur DEC003
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC003'
    -- 2 diffusions sur DEC004
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
    UNION ALL SELECT idvol FROM vols_dec WHERE numerovol = 'DEC004'
) vd;

-- =====================================================
-- PAIEMENTS DES SOCIETES - Décembre 2025
-- =====================================================

-- Vaniala a payé 1 000 000 Ar le 15 décembre 2025
INSERT INTO paiement_societe (idachat, montant, date_paiement, reference)
SELECT a.idachat, 1000000, '2025-12-15', 'PAIE-VANIALA-DEC2025-001'
FROM achat_diffusion a
JOIN societe s ON a.idsociete = s.idsociete
WHERE s.nom = 'Vaniala' AND a.mois = 12 AND a.annee = 2025;

-- =====================================================
-- CALCUL DU CA PUBLICITAIRE - Décembre 2025
-- =====================================================

-- Vérification: nombre de diffusions par société
SELECT 
    s.nom AS societe,
    a.nombre_diffusions AS diffusions_achetees,
    COUNT(dv.iddiffusion) AS diffusions_affectees,
    a.nombre_diffusions - COUNT(dv.iddiffusion) AS diffusions_restantes
FROM achat_diffusion a
JOIN societe s ON a.idsociete = s.idsociete
LEFT JOIN diffusion_vol dv ON dv.idachat = a.idachat
WHERE a.mois = 12 AND a.annee = 2025
GROUP BY s.nom, a.nombre_diffusions
ORDER BY s.nom;

-- Détail des diffusions par vol
SELECT 
    v.numerovol,
    v.datedepart,
    s.nom AS societe,
    COUNT(dv.iddiffusion) AS nb_diffusions
FROM diffusion_vol dv
JOIN achat_diffusion a ON dv.idachat = a.idachat
JOIN societe s ON a.idsociete = s.idsociete
JOIN vol v ON dv.idvol = v.idvol
WHERE a.mois = 12 AND a.annee = 2025
GROUP BY v.numerovol, v.datedepart, s.nom
ORDER BY v.datedepart, s.nom;

-- CA par société pour décembre 2025
SELECT
    s.nom AS societe,
    a.nombre_diffusions AS total_diffusions,
    a.cout_unitaire,
    (a.nombre_diffusions * a.cout_unitaire) AS chiffre_affaires
FROM achat_diffusion a
JOIN societe s ON a.idsociete = s.idsociete
WHERE a.mois = 12 AND a.annee = 2025
ORDER BY s.nom;

-- CA TOTAL des diffusions publicitaires pour décembre 2025
SELECT
    'Décembre 2025' AS periode,
    SUM(a.nombre_diffusions) AS total_diffusions,
    SUM(a.nombre_diffusions * a.cout_unitaire) AS ca_total_publicite
FROM achat_diffusion a
WHERE a.mois = 12 AND a.annee = 2025;
