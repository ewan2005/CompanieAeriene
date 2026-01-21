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
