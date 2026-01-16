-- =========================
-- PAYS
-- =========================
INSERT INTO pays (nom) VALUES
('Madagascar'),
('France'),
('Maurice');

-- =========================
-- AEROPORTS
-- =========================
INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport', 'Antananarivo', 'TNR'),
('Fascene Airport', 'Nosy Be', 'NOS'),
('Toamasina Airport', 'Toamasina', 'TMM'),
('Antsiranana / Diego Suarez Airport', 'Antsiranana', 'DIE'),
('Toliara / Tulear Airport', 'Toliara', 'TLE');


-- Liaison pays <-> aeroport (idempotente)
INSERT INTO pays_aeroport (idaeroport, idpays) VALUES
(1,1),(2,1),(3,1),(4,1),(5,1)
ON CONFLICT DO NOTHING;

-- NOTE: la contrainte CHECK sur `place.type_place` est gérée via la table `tarif_classe` et
-- ne doit pas être modifiée via ALTER TABLE dans les scripts de données. Les ALTER TABLE ci-dessus
-- ont été volontairement retirés pour éviter des modifications de schéma dans les scripts de seed.

-- =========================
-- AVIONS
-- =========================
-- Insertion idempotente de tous les avions utilisés
INSERT INTO avion (modele, capacite, code) VALUES
('Boeing 737-800', 120, 'B738'),
('Airbus A320', 120, 'A320'),
('ATR 72', 70, 'ATR72'),
('Dash 8 Q400', 78, 'DASH8')
ON CONFLICT (code) DO NOTHING;

-- =====================================================
-- PLACES AVION 1
-- =====================================================

-- Avion 1 (idavion = 1): Première 1..30, Premium 31..70, Économique 71..120
INSERT INTO place (numeroplace, type_place, idavion) VALUES
(1,'premiere_classe',1),(2,'premiere_classe',1),(3,'premiere_classe',1),(4,'premiere_classe',1),(5,'premiere_classe',1),
(6,'premiere_classe',1),(7,'premiere_classe',1),(8,'premiere_classe',1),(9,'premiere_classe',1),(10,'premiere_classe',1),
(11,'premiere_classe',1),(12,'premiere_classe',1),(13,'premiere_classe',1),(14,'premiere_classe',1),(15,'premiere_classe',1),
(16,'premiere_classe',1),(17,'premiere_classe',1),(18,'premiere_classe',1),(19,'premiere_classe',1),(20,'premiere_classe',1),
(21,'premiere_classe',1),(22,'premiere_classe',1),(23,'premiere_classe',1),(24,'premiere_classe',1),(25,'premiere_classe',1),
(26,'premiere_classe',1),(27,'premiere_classe',1),(28,'premiere_classe',1),(29,'premiere_classe',1),(30,'premiere_classe',1),
(31,'premium',1),(32,'premium',1),(33,'premium',1),(34,'premium',1),(35,'premium',1),(36,'premium',1),(37,'premium',1),(38,'premium',1),(39,'premium',1),(40,'premium',1),
(41,'premium',1),(42,'premium',1),(43,'premium',1),(44,'premium',1),(45,'premium',1),(46,'premium',1),(47,'premium',1),(48,'premium',1),(49,'premium',1),(50,'premium',1),
(51,'premium',1),(52,'premium',1),(53,'premium',1),(54,'premium',1),(55,'premium',1),(56,'premium',1),(57,'premium',1),(58,'premium',1),(59,'premium',1),(60,'premium',1),
(61,'premium',1),(62,'premium',1),(63,'premium',1),(64,'premium',1),(65,'premium',1),(66,'premium',1),(67,'premium',1),(68,'premium',1),(69,'premium',1),(70,'premium',1),
(71,'economique',1),(72,'economique',1),(73,'economique',1),(74,'economique',1),(75,'economique',1),(76,'economique',1),(77,'economique',1),(78,'economique',1),(79,'economique',1),(80,'economique',1),
(81,'economique',1),(82,'economique',1),(83,'economique',1),(84,'economique',1),(85,'economique',1),(86,'economique',1),(87,'economique',1),(88,'economique',1),(89,'economique',1),(90,'economique',1),
(91,'economique',1),(92,'economique',1),(93,'economique',1),(94,'economique',1),(95,'economique',1),(96,'economique',1),(97,'economique',1),(98,'economique',1),(99,'economique',1),(100,'economique',1),
(101,'economique',1),(102,'economique',1),(103,'economique',1),(104,'economique',1),(105,'economique',1),(106,'economique',1),(107,'economique',1),(108,'economique',1),(109,'economique',1),(110,'economique',1),
(111,'economique',1),(112,'economique',1),(113,'economique',1),(114,'economique',1),(115,'economique',1),(116,'economique',1),(117,'economique',1),(118,'economique',1),(119,'economique',1),(120,'economique',1)
ON CONFLICT (numeroplace, idavion) DO UPDATE
  SET type_place = EXCLUDED.type_place;

-- Avion 2 (idavion = 2): Même répartition
INSERT INTO place (numeroplace, type_place, idavion) VALUES
(1,'premiere_classe',2),(2,'premiere_classe',2),(3,'premiere_classe',2),(4,'premiere_classe',2),(5,'premiere_classe',2),
(6,'premiere_classe',2),(7,'premiere_classe',2),(8,'premiere_classe',2),(9,'premiere_classe',2),(10,'premiere_classe',2),
(11,'premiere_classe',2),(12,'premiere_classe',2),(13,'premiere_classe',2),(14,'premiere_classe',2),(15,'premiere_classe',2),
(16,'premiere_classe',2),(17,'premiere_classe',2),(18,'premiere_classe',2),(19,'premiere_classe',2),(20,'premiere_classe',2),
(21,'premiere_classe',2),(22,'premiere_classe',2),(23,'premiere_classe',2),(24,'premiere_classe',2),(25,'premiere_classe',2),
(26,'premiere_classe',2),(27,'premiere_classe',2),(28,'premiere_classe',2),(29,'premiere_classe',2),(30,'premiere_classe',2),
(31,'premium',2),(32,'premium',2),(33,'premium',2),(34,'premium',2),(35,'premium',2),(36,'premium',2),(37,'premium',2),(38,'premium',2),(39,'premium',2),(40,'premium',2),
(41,'premium',2),(42,'premium',2),(43,'premium',2),(44,'premium',2),(45,'premium',2),(46,'premium',2),(47,'premium',2),(48,'premium',2),(49,'premium',2),(50,'premium',2),
(51,'premium',2),(52,'premium',2),(53,'premium',2),(54,'premium',2),(55,'premium',2),(56,'premium',2),(57,'premium',2),(58,'premium',2),(59,'premium',2),(60,'premium',2),
(61,'premium',2),(62,'premium',2),(63,'premium',2),(64,'premium',2),(65,'premium',2),(66,'premium',2),(67,'premium',2),(68,'premium',2),(69,'premium',2),(70,'premium',2),
(71,'economique',2),(72,'economique',2),(73,'economique',2),(74,'economique',2),(75,'economique',2),(76,'economique',2),(77,'economique',2),(78,'economique',2),(79,'economique',2),(80,'economique',2),
(81,'economique',2),(82,'economique',2),(83,'economique',2),(84,'economique',2),(85,'economique',2),(86,'economique',2),(87,'economique',2),(88,'economique',2),(89,'economique',2),(90,'economique',2),
(91,'economique',2),(92,'economique',2),(93,'economique',2),(94,'economique',2),(95,'economique',2),(96,'economique',2),(97,'economique',2),(98,'economique',2),(99,'economique',2),(100,'economique',2),
(101,'economique',2),(102,'economique',2),(103,'economique',2),(104,'economique',2),(105,'economique',2),(106,'economique',2),(107,'economique',2),(108,'economique',2),(109,'economique',2),(110,'economique',2),
(111,'economique',2),(112,'economique',2),(113,'economique',2),(114,'economique',2),(115,'economique',2),(116,'economique',2),(117,'economique',2),(118,'economique',2),(119,'economique',2),(120,'economique',2)
ON CONFLICT (numeroplace, idavion) DO UPDATE
  SET type_place = EXCLUDED.type_place;

-- Avion 3 (ATR72) : 1..10 premiere, 11..20 premium, 21..70 economique
WITH a AS (SELECT idavion FROM avion WHERE code = 'ATR72')
INSERT INTO place (numeroplace, type_place, idavion)
SELECT v.n, v.t, a.idavion
FROM (
  VALUES
  (1,'premiere_classe'),(2,'premiere_classe'),(3,'premiere_classe'),(4,'premiere_classe'),(5,'premiere_classe'),
  (6,'premiere_classe'),(7,'premiere_classe'),(8,'premiere_classe'),(9,'premiere_classe'),(10,'premiere_classe'),
  (11,'premium'),(12,'premium'),(13,'premium'),(14,'premium'),(15,'premium'),(16,'premium'),(17,'premium'),(18,'premium'),(19,'premium'),(20,'premium'),
  (21,'economique'),(22,'economique'),(23,'economique'),(24,'economique'),(25,'economique'),(26,'economique'),(27,'economique'),(28,'economique'),(29,'economique'),(30,'economique'),
  (31,'economique'),(32,'economique'),(33,'economique'),(34,'economique'),(35,'economique'),(36,'economique'),(37,'economique'),(38,'economique'),(39,'economique'),(40,'economique'),
  (41,'economique'),(42,'economique'),(43,'economique'),(44,'economique'),(45,'economique'),(46,'economique'),(47,'economique'),(48,'economique'),(49,'economique'),(50,'economique'),
  (51,'economique'),(52,'economique'),(53,'economique'),(54,'economique'),(55,'economique'),(56,'economique'),(57,'economique'),(58,'economique'),(59,'economique'),(60,'economique'),
  (61,'economique'),(62,'economique'),(63,'economique'),(64,'economique'),(65,'economique'),(66,'economique'),(67,'economique'),(68,'economique'),(69,'economique'),(70,'economique')
) AS v(n,t)
CROSS JOIN a
WHERE a.idavion IS NOT NULL
ON CONFLICT (numeroplace, idavion) DO UPDATE
  SET type_place = EXCLUDED.type_place; 

-- Avion 4 (DASH8) : 1..10 premiere, 11..20 premium, 21..78 economique
WITH a AS (SELECT idavion FROM avion WHERE code = 'DASH8')
INSERT INTO place (numeroplace, type_place, idavion)
SELECT v.n, v.t, a.idavion
FROM (
  VALUES
  (1,'premiere_classe'),(2,'premiere_classe'),(3,'premiere_classe'),(4,'premiere_classe'),(5,'premiere_classe'),
  (6,'premiere_classe'),(7,'premiere_classe'),(8,'premiere_classe'),(9,'premiere_classe'),(10,'premiere_classe'),
  (11,'premium'),(12,'premium'),(13,'premium'),(14,'premium'),(15,'premium'),(16,'premium'),(17,'premium'),(18,'premium'),(19,'premium'),(20,'premium'),
  (21,'economique'),(22,'economique'),(23,'economique'),(24,'economique'),(25,'economique'),(26,'economique'),(27,'economique'),(28,'economique'),(29,'economique'),(30,'economique'),
  (31,'economique'),(32,'economique'),(33,'economique'),(34,'economique'),(35,'economique'),(36,'economique'),(37,'economique'),(38,'economique'),(39,'economique'),(40,'economique'),
  (41,'economique'),(42,'economique'),(43,'economique'),(44,'economique'),(45,'economique'),(46,'economique'),(47,'economique'),(48,'economique'),(49,'economique'),(50,'economique'),
  (51,'economique'),(52,'economique'),(53,'economique'),(54,'economique'),(55,'economique'),(56,'economique'),(57,'economique'),(58,'economique'),(59,'economique'),(60,'economique'),
  (61,'economique'),(62,'economique'),(63,'economique'),(64,'economique'),(65,'economique'),(66,'economique'),(67,'economique'),(68,'economique'),(69,'economique'),(70,'economique'),
  (71,'economique'),(72,'economique'),(73,'economique'),(74,'economique'),(75,'economique'),(76,'economique'),(77,'economique'),(78,'economique')
) AS v(n,t)
CROSS JOIN a
WHERE a.idavion IS NOT NULL
ON CONFLICT (numeroplace, idavion) DO UPDATE
  SET type_place = EXCLUDED.type_place; 

-- TRAJETS (routes entre aEroports)
INSERT INTO trajet (idaeroportdepart, idaeroportarrive) VALUES
(1, 2),  -- TNR -> NOS
(2, 1),  -- NOS -> TNR
(1, 3),  -- TNR -> TMM
(1, 4),  -- TNR -> DIE
(1, 5)   -- TNR -> TLE
ON CONFLICT DO NOTHING;

-- VOLS (référence trajet + avion). On utilise INSERT ... SELECT pour insérer uniquement lorsque trajet et avion existent
-- MD101 TNR -> NOS (ATR72)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'MD101','2026-02-01','2026-02-01','08:00','09:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'ATR72'
WHERE ad.code = 'TNR' AND aa.code = 'NOS'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'MD101');

-- MD102 NOS -> TNR (ATR72)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'MD102','2026-02-01','2026-02-01','10:00','11:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'ATR72'
WHERE ad.code = 'NOS' AND aa.code = 'TNR'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'MD102');

-- MD201 TNR -> TMM (DASH8)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'MD201','2026-02-02','2026-02-02','07:00','08:00', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'DASH8'
WHERE ad.code = 'TNR' AND aa.code = 'TMM'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'MD201');

-- MD301 TNR -> DIE (B738)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'MD301','2026-02-02','2026-02-02','09:00','10:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'B738'
WHERE ad.code = 'TNR' AND aa.code = 'DIE'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'MD301');

-- MD401 TNR -> TLE (A320)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT 'MD401','2026-02-03','2026-02-03','14:00','15:30', t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON a.code = 'A320'
WHERE ad.code = 'TNR' AND aa.code = 'TLE'
AND NOT EXISTS (SELECT 1 FROM vol v WHERE v.numerovol = 'MD401');

-- MODES DE PAIEMENT (deja inseres dans script.sql, mais au cas ou)
INSERT INTO modepaiement (libelle) VALUES 
('Especes'),
('Carte bancaire'),
('Virement'),
('Mobile Money')
ON CONFLICT (libelle) DO NOTHING;

-- CATEGORIES & REMISES (si script exécuté indépendamment)
INSERT INTO categorie (libelle) VALUES
('adulte'),('enfant')
ON CONFLICT (libelle) DO NOTHING;

INSERT INTO remise_categorie (type_place, idcategorie, montant_remise)
SELECT tc.type_place, c.idcategorie, 500000.00
FROM tarif_classe tc, categorie c
WHERE tc.type_place = 'economique' AND c.libelle = 'enfant'
ON CONFLICT (type_place, idcategorie) DO NOTHING;

-- =============================================
-- RESERVATIONS (référence vol + place + categorie)
-- La place doit appartenir à l'avion du vol!
-- =============================================

-- On recrée les réservations avec des références robustes (INSERT ... SELECT pour éviter les NULL si références manquantes)
DELETE FROM reservation; -- nettoie les anciennes si besoin

-- 1: MD101 place 1 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 1, '2026-01-20', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 1
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD101' AND a.code = 'ATR72'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 2: MD101 place 5 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 2, '2026-01-20', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 5
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD101' AND a.code = 'ATR72'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 3: MD101 place 15 (enfant)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 3, '2026-01-20', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 15
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'enfant'
WHERE v.numerovol = 'MD101' AND a.code = 'ATR72'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 4: MD102 place 2 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 4, '2026-01-21', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 2
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD102' AND a.code = 'ATR72'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 5: MD102 place 25 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 5, '2026-01-21', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 25
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD102' AND a.code = 'ATR72'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 6: MD201 place 1 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 6, '2026-01-22', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 1
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD201' AND a.code = 'DASH8'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 7: MD201 place 15 (enfant)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 7, '2026-01-22', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 15
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'enfant'
WHERE v.numerovol = 'MD201' AND a.code = 'DASH8'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 8: MD301 place 1 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 8, '2026-01-23', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 1
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD301' AND a.code = 'B738'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 9: MD301 place 30 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 9, '2026-01-23', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 30
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD301' AND a.code = 'B738'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- 10: MD401 place 1 (adulte)
INSERT INTO reservation (idreservation, datereservation, idvol, idplace, idcategorie)
SELECT 10, '2026-01-24', v.idvol, p.idplace, c.idcategorie
FROM vol v
JOIN place p ON p.numeroplace = 1
JOIN avion a ON p.idavion = a.idavion
JOIN categorie c ON c.libelle = 'adulte'
WHERE v.numerovol = 'MD401' AND a.code = 'A320'
ON CONFLICT (idreservation) DO UPDATE SET datereservation = EXCLUDED.datereservation, idvol = EXCLUDED.idvol, idplace = EXCLUDED.idplace, idcategorie = EXCLUDED.idcategorie;

-- Mettre à jour la séquence pour éviter des conflits futurs
SELECT setval(pg_get_serial_sequence('reservation','idreservation'), 10, true);

-- PASSAGERS (liés à leur réservation)
INSERT INTO passager (nom, prenom, datenaissance, numeropasseport, nationalite, telephone, email, idreservation) VALUES
('Rakoto', 'Hery', '1995-05-12', 'MG123456', 'Malagasy', '034 12 345 67', 'hery.rakoto@gmail.com', 1),
('Rasoanaivo', 'Clara', '1988-08-20', 'MG234567', 'Malagasy', '033 23 456 78', 'clara.raso@yahoo.fr', 2),
('Andria', 'Tiana', '1990-03-10', 'MG345670', 'Malagasy', '034 11 222 33', 'tiana.andria@gmail.com', 3),
('Rabe', 'Jean', '1982-07-25', 'MG456701', 'Malagasy', '032 44 555 66', 'jean.rabe@yahoo.fr', 4),
('Razafy', 'Nadia', '1998-12-05', 'MG567012', 'Malagasy', '033 77 888 99', 'nadia.razafy@gmail.com', 5),
('Randria', 'Lucas', '2000-01-15', 'MG345678', 'Malagasy', '032 34 567 89', 'lucas.randria@gmail.com', 6),
('Ramanantsoa', 'Julie', '1992-11-03', 'MG456789', 'Malagasy', '034 45 678 90', 'julie.rama@hotmail.com', 7),
('Razafy', 'Michel', '1985-03-27', 'MG567890', 'Malagasy', '033 56 789 01', 'michel.razafy@gmail.com', 8),
('Rakotoarisoa', 'Emma', '1993-06-18', 'MG678901', 'Malagasy', '034 67 890 12', 'emma.rakoto@gmail.com', 9),
('Raharison', 'Patrick', '1987-09-22', 'MG789012', 'Malagasy', '032 78 901 23', 'patrick.raha@yahoo.fr', 10);

-- PAIEMENTS (avec mode de paiement)
INSERT INTO paiement (montant, datepaiement, idmodepaiement) VALUES
(1200000, '2026-01-20', 2),  -- Carte bancaire (premiere classe)
(1200000, '2026-01-20', 4),  -- Mobile Money (premiere classe)
(800000, '2026-01-20', 4),   -- Mobile Money (Economique)
(1200000, '2026-01-21', 2),  -- Carte bancaire (premiere classe)
(800000, '2026-01-21', 1),   -- Especes (Economique)
(1200000, '2026-01-22', 2),  -- Carte bancaire (premiere classe)
(800000, '2026-01-22', 4),   -- Mobile Money (Economique)
(1200000, '2026-01-23', 2),  -- Carte bancaire (premiere classe)
(800000, '2026-01-23', 3),   -- Virement (Economique)
(1200000, '2026-01-24', 2);  -- Carte bancaire (premiere classe)

-- BILLETS (référence reservation + paiement), prix calculés depuis tarif_classe et remise_categorie
-- On n'insère un billet que si la réservation existe et qu'un paiement correspondant est présent (ici on suppose un mapping paiement.idpaiement = reservation.idreservation si applicable)
INSERT INTO billet (prix, classe, idreservation, idpaiement)
SELECT (tc.tarif - COALESCE(rc.montant_remise, 0)) AS prix,
       CASE WHEN tc.type_place = 'premiere_classe' THEN 'Premiere Classe' WHEN tc.type_place = 'premium' THEN 'Premium' ELSE 'Economique' END AS classe,
       r.idreservation,
       p.idpaiement
FROM reservation r
JOIN place pl ON r.idplace = pl.idplace
JOIN tarif_classe tc ON tc.type_place = pl.type_place
LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie
JOIN paiement p ON p.idpaiement = r.idreservation
ON CONFLICT (idreservation) DO UPDATE SET prix = EXCLUDED.prix, classe = EXCLUDED.classe, idpaiement = EXCLUDED.idpaiement;

-- =============================================
-- REQUÊTES DE VERIFICATION
-- =============================================

-- Voir les places par avion avec leur type
SELECT a.code AS avion, a.modele,
       COUNT(*) FILTER (WHERE p.type_place = 'premiere_classe') AS places_premiere_classe,
       COUNT(*) FILTER (WHERE p.type_place = 'premium') AS places_premium,
       COUNT(*) FILTER (WHERE p.type_place = 'economique') AS places_economique,
       COUNT(*) AS total_places
FROM avion a
LEFT JOIN place p ON p.idavion = a.idavion
GROUP BY a.idavion, a.code, a.modele
ORDER BY a.idavion;

-- Valeur maximale par avion (utilise le tarif de la base de donnEes)
SELECT a.code AS avion, a.modele,
       COUNT(*) FILTER (WHERE p.type_place = 'premiere_classe') AS nb_premiere,
       COUNT(*) FILTER (WHERE p.type_place = 'premium') AS nb_premium,
       COUNT(*) FILTER (WHERE p.type_place = 'economique') AS nb_eco,
       SUM(COALESCE(tc.tarif,0)) AS valeur_max_vol
FROM avion a
LEFT JOIN place p ON p.idavion = a.idavion
LEFT JOIN tarif_classe tc ON tc.type_place = p.type_place
GROUP BY a.idavion, a.code, a.modele
ORDER BY valeur_max_vol DESC;

-- Voir les vols avec leurs trajets
SELECT v.numerovol, v.datedepart, v.heuredepart,
       ad.ville || ' (' || ad.code || ')' AS depart,
       aa.ville || ' (' || aa.code || ')' AS arrivee,
       a.code AS avion
FROM vol v
JOIN trajet t ON v.idtrajet = t.idtrajet
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion a ON v.idavion = a.idavion;

-- Voir les rEservations avec passagers et TYPE DE PLACE
SELECT r.idreservation, v.numerovol, 
       pl.numeroplace, pl.type_place,
       p.nom || ' ' || p.prenom AS passager, 
       b.prix, b.classe
FROM reservation r
JOIN vol v ON r.idvol = v.idvol
JOIN place pl ON r.idplace = pl.idplace
JOIN passager p ON p.idreservation = r.idreservation
LEFT JOIN billet b ON b.idreservation = r.idreservation
ORDER BY r.idreservation;

-- Chiffre d'affaires par trajet
SELECT ad.ville || ' -> ' || aa.ville AS trajet,
       COUNT(b.idbillet) AS nb_billets,
       SUM(b.prix) AS chiffre_affaires
FROM trajet t
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
LEFT JOIN vol v ON v.idtrajet = t.idtrajet
LEFT JOIN reservation r ON r.idvol = v.idvol
LEFT JOIN billet b ON b.idreservation = r.idreservation
GROUP BY t.idtrajet, ad.ville, aa.ville
ORDER BY chiffre_affaires DESC NULLS LAST;

-- Chiffre d'affaires par avion
SELECT a.code, a.modele,
       COUNT(b.idbillet) AS nb_billets,
       SUM(b.prix) AS chiffre_affaires
FROM avion a
LEFT JOIN vol v ON v.idavion = a.idavion
LEFT JOIN reservation r ON r.idvol = v.idvol
LEFT JOIN billet b ON b.idreservation = r.idreservation
GROUP BY a.idavion, a.code, a.modele
ORDER BY chiffre_affaires DESC NULLS LAST;


