INSERT INTO pays (nom) VALUES
('Madagascar'),
('France'),
('Maurice')
ON CONFLICT (nom) DO NOTHING;


INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport', 'Antananarivo', 'TNR'),
('Fascene Airport', 'Nosy Be', 'NOS'),
('Toamasina Airport', 'Toamasina', 'TMM')
ON CONFLICT (code) DO NOTHING;


INSERT INTO pays_aeroport (idaeroport, idpays)
SELECT a.idaeroport, p.idpays
FROM aeroport a
JOIN pays p ON p.nom = 'Madagascar'
ON CONFLICT DO NOTHING;


INSERT INTO avion (modele, capacite, code) VALUES
('Boeing 737-800', 120, 'B738'),
('Airbus A320', 120, 'A320')
ON CONFLICT (code) DO NOTHING;


INSERT INTO place (numeroplace, type_place, idavion)
SELECT gs, 'premiere_classe', a.idavion
FROM generate_series(1,30) gs, avion a
ON CONFLICT (numeroplace, idavion)
DO UPDATE SET type_place = EXCLUDED.type_place;

INSERT INTO place (numeroplace, type_place, idavion)
SELECT gs, 'premium', a.idavion
FROM generate_series(31,70) gs, avion a
ON CONFLICT (numeroplace, idavion)
DO UPDATE SET type_place = EXCLUDED.type_place;

INSERT INTO place (numeroplace, type_place, idavion)
SELECT gs, 'economique', a.idavion
FROM generate_series(71,120) gs, avion a
ON CONFLICT (numeroplace, idavion)
DO UPDATE SET type_place = EXCLUDED.type_place;



INSERT INTO trajet (idaeroportdepart, idaeroportarrive)
SELECT ad.idaeroport, aa.idaeroport
FROM aeroport ad, aeroport aa
WHERE ad.code = 'TNR' AND aa.code = 'NOS'
UNION ALL
SELECT ad.idaeroport, aa.idaeroport
FROM aeroport ad, aeroport aa
WHERE ad.code = 'NOS' AND aa.code = 'TNR'
UNION ALL
SELECT ad.idaeroport, aa.idaeroport
FROM aeroport ad, aeroport aa
WHERE ad.code = 'TNR' AND aa.code = 'TMM'
ON CONFLICT DO NOTHING;


INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion)
SELECT
'MD101','2026-02-01','2026-02-01','08:00','09:30',
t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON ad.idaeroport=t.idaeroportdepart AND ad.code='TNR'
JOIN aeroport aa ON aa.idaeroport=t.idaeroportarrive AND aa.code='NOS'
JOIN avion a ON a.code='B738'
ON CONFLICT DO NOTHING;

INSERT INTO vol (...)
SELECT
'MD102','2026-02-01','2026-02-01','10:00','11:30',
t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON ad.code='NOS'
JOIN aeroport aa ON aa.code='TNR'
JOIN avion a ON a.code='B738'
ON CONFLICT DO NOTHING;

INSERT INTO vol (...)
SELECT
'MD201','2026-02-02','2026-02-02','07:00','08:00',
t.idtrajet, a.idavion
FROM trajet t
JOIN aeroport ad ON ad.code='TNR'
JOIN aeroport aa ON aa.code='TMM'
JOIN avion a ON a.code='A320'
ON CONFLICT DO NOTHING;


INSERT INTO reservation (idreservation, datereservation, idvol, idplace)
SELECT
1,'2026-01-20',v.idvol,p.idplace
FROM vol v
JOIN place p ON p.numeroplace=1
WHERE v.numerovol='MD101'
ON CONFLICT DO NOTHING;

INSERT INTO reservation (...)
SELECT
2,'2026-01-20',v.idvol,p.idplace
FROM vol v
JOIN place p ON p.numeroplace=5
WHERE v.numerovol='MD101'
ON CONFLICT DO NOTHING;

-- même principe jusqu’à idreservation = 10

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


INSERT INTO billet (prix, classe, idreservation, idpaiement) VALUES
(1200000, 'Premiere Classe', 1, 1),
(1200000, 'Premiere Classe', 2, 2),
(800000, 'Economique', 3, 3),
(1200000, 'Premiere Classe', 4, 4),
(800000, 'Economique', 5, 5),
(1200000, 'Premiere Classe', 6, 6),
(800000, 'Economique', 7, 7),
(1200000, 'Premiere Classe', 8, 8),
(800000, 'Economique', 9, 9),
(1200000, 'Premiere Classe', 10, 10);




SELECT setval(pg_get_serial_sequence('reservation','idreservation'),
(SELECT MAX(idreservation) FROM reservation), true);

SELECT setval(pg_get_serial_sequence('passager','idpassager'),
(SELECT MAX(idpassager) FROM passager), true);

SELECT setval(pg_get_serial_sequence('billet','idbillet'),
(SELECT MAX(idbillet) FROM billet), true);

