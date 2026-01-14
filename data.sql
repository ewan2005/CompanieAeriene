-- =============================================
-- DONNEES DE TEST - Nouvelle structure
-- Flux: Trajet -> Vol -> Reservation -> Billet
-- =============================================

-- PAYS
INSERT INTO pays (nom) VALUES
('Madagascar'),
('France'),
('Maurice'),
('Kenya'),
('Afrique du Sud');

-- AEROPORTS
INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport', 'Antananarivo', 'TNR'),
('Fascene Airport', 'Nosy Be', 'NOS'),
('Toamasina Airport', 'Toamasina', 'TMM'),
('Arrachart Airport', 'Antsiranana', 'DIE'),
('Toliara Airport', 'Toliara', 'TLE');

-- PAYS_AEROPORT (liaison)
INSERT INTO pays_aeroport (idaeroport, idpays) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

-- AVIONS
INSERT INTO avion (modele, capacite, code) VALUES
('ATR 72', 70, '5R-ATN'),
('Boeing 737', 160, '5R-BNG'),
('Dash 8 Q400', 78, '5R-DQ4'),
('Airbus A320', 180, '5R-A320');

-- TRAJETS (routes entre aéroports)
INSERT INTO trajet (idaeroportdepart, idaeroportarrive) VALUES
(1, 2),  -- TNR -> NOS
(2, 1),  -- NOS -> TNR
(1, 3),  -- TNR -> TMM
(1, 4),  -- TNR -> DIE
(1, 5);  -- TNR -> TLE

-- VOLS (référencent trajet + avion)
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion) VALUES
('MD101', '2026-02-01', '2026-02-01', '08:00', '09:30', 1, 1),
('MD102', '2026-02-01', '2026-02-01', '10:00', '11:30', 2, 1),
('MD201', '2026-02-02', '2026-02-02', '07:00', '08:00', 3, 3),
('MD301', '2026-02-02', '2026-02-02', '09:00', '10:30', 4, 2),
('MD401', '2026-02-03', '2026-02-03', '14:00', '15:30', 5, 4);

-- MODES DE PAIEMENT (deja inseres dans script.sql, mais au cas ou)
INSERT INTO modepaiement (libelle) VALUES 
('Espèces'),
('Carte bancaire'),
('Virement'),
('Mobile Money')
ON CONFLICT (libelle) DO NOTHING;

-- PLACES (deja inserees dans script.sql via generate_series)
-- Si besoin de reinsérer manuellement:
-- INSERT INTO place (numeroplace) SELECT generate_series(1, 50);

-- RÉSERVATIONS (référencent vol + place)
INSERT INTO reservation (datereservation, idvol, idplace) VALUES
('2026-01-20', 1, 1),   -- Vol MD101, Place 1
('2026-01-21', 2, 5),   -- Vol MD102, Place 5
('2026-01-22', 3, 10),  -- Vol MD201, Place 10
('2026-01-23', 4, 3),   -- Vol MD301, Place 3
('2026-01-24', 5, 7);   -- Vol MD401, Place 7

-- PASSAGERS (liés à leur réservation)
INSERT INTO passager (nom, prenom, datenaissance, numeropasseport, nationalite, telephone, email, idreservation) VALUES
('Rakoto', 'Hery', '1995-05-12', 'MG123456', 'Malagasy', '034 12 345 67', 'hery.rakoto@gmail.com', 1),
('Rasoanaivo', 'Clara', '1988-08-20', 'MG234567', 'Malagasy', '033 23 456 78', 'clara.raso@yahoo.fr', 2),
('Randria', 'Lucas', '2000-01-15', 'MG345678', 'Malagasy', '032 34 567 89', 'lucas.randria@gmail.com', 3),
('Ramanantsoa', 'Julie', '1992-11-03', 'MG456789', 'Malagasy', '034 45 678 90', 'julie.rama@hotmail.com', 4),
('Razafy', 'Michel', '1985-03-27', 'MG567890', 'Malagasy', '033 56 789 01', 'michel.razafy@gmail.com', 5);

-- PAIEMENTS (avec mode de paiement)
INSERT INTO paiement (montant, datepaiement, idmodepaiement) VALUES
(350000, '2026-01-20', 4),  -- Mobile Money
(450000, '2026-01-21', 2),  -- Carte bancaire
(300000, '2026-01-22', 4),  -- Mobile Money
(600000, '2026-01-23', 2),  -- Carte bancaire
(250000, '2026-01-24', 1);  -- Espèces

-- BILLETS (référencent réservation + paiement)
INSERT INTO billet (prix, classe, idreservation, idpaiement) VALUES
(350000, 'Economique', 1, 1),
(450000, 'Business', 2, 2),
(300000, 'Economique', 3, 3),
(600000, 'Business', 4, 4),
(250000, 'Economique', 5, 5);

-- =============================================
-- REQUÊTES DE VÉRIFICATION
-- =============================================

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

-- Voir les réservations avec passagers
SELECT r.idreservation, v.numerovol, pl.numeroplace,
       p.nom || ' ' || p.prenom AS passager, p.telephone
FROM reservation r
JOIN vol v ON r.idvol = v.idvol
JOIN place pl ON r.idplace = pl.idplace
JOIN passager p ON p.idreservation = r.idreservation;

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


