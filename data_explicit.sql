-- =============================================
-- DONNEES COMPLeTES POUR TESTS REALISTES
-- =============================================

-- MODES DE PAIEMENT
INSERT INTO modepaiement (libelle) VALUES 
   ('Especes'),
   ('Carte bancaire'),
   ('Virement'),
   ('Mobile Money');

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
('Sir Seewoosagur Ramgoolam Airport', 'Plaisance', 'MRU'),
('Charles de Gaulle Airport', 'Paris', 'CDG');

-- ASSOCIATION PAYS / AEROPORT
INSERT INTO pays_aeroport VALUES
(1,1),(2,1),(3,1),
(4,3),
(5,2);

-- AVIONS
INSERT INTO avion (modele, capacite, code) VALUES 
('Boeing 737-800', 120, 'B738'),
('Airbus A320', 120, 'A320');

-- PLACES – AVION 1 (Boeing 737-800)
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'premiere_classe', 1 FROM generate_series(1,30) s;
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'premium', 1 FROM generate_series(31,70) s;
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'economique', 1 FROM generate_series(71,120) s;

-- PLACES – AVION 2 (Airbus A320)
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'premiere_classe', 2 FROM generate_series(1,30) s;
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'premium', 2 FROM generate_series(31,70) s;
INSERT INTO place (numeroplace, type_place, idavion)
SELECT s, 'economique', 2 FROM generate_series(71,120) s;

-- TRAJETS
INSERT INTO trajet (idaeroportdepart, idaeroportarrive) VALUES
(1,2),(1,3),(1,4),(1,5),(2,1);

-- VOLS
INSERT INTO vol (numerovol, datedepart, datearrive, heuredepart, heurearrivee, idtrajet, idavion) VALUES
('MD101','2026-02-10','2026-02-10','07:30','08:45',1,1),
('MD102','2026-02-11','2026-02-11','09:00','10:00',2,1),
('MD201','2026-02-12','2026-02-12','13:00','16:30',3,2),
('MD301','2026-02-13','2026-02-13','22:00','06:00',4,2),
('MD401','2026-02-14','2026-02-14','15:30','16:45',5,1);

-- PAIEMENTS
INSERT INTO paiement (montant, idmodepaiement) VALUES
(1000000,2),
(1200000,3),
(800000,4),
(1000000,2),
(800000,1);

-- RESERVATIONS
INSERT INTO reservation (idvol, idplace) VALUES
(1,1),
(1,45),
(2,80),
(3,10),
(4,50),
(2,5),
(3,60),
(1,70),
(4,2),
(5,100);

-- PASSAGERS
INSERT INTO passager
(nom, prenom, datenaissance, numeropasseport, nationalite, telephone, email, idreservation)
VALUES
('Rakoto','Hery','1994-05-12','MG784512','Malagasy','0341234567','hery.rakoto@gmail.com',1),
('Rasoanaivo','Clara','1988-08-20','MG895623','Malagasy','0334567890','clara.raso@yahoo.fr',2),
('Dupont','Jean','1975-02-10','FR123987','Française','+33612345678','jean.dupont@gmail.com',3),
('Smith','Anna','1990-11-03','UK998877','Britannique','+447700900123','anna.smith@mail.com',4),
('Raveloson','Tiana','2000-01-19','MG667788','Malagasy','0321122334','tiana.r@gmail.com',5),
('Andrianasolo','Kevin','1995-12-15','MG556677','Malagasy','0339988776','kevin.a@gmail.com',6),
('Rakotomalala','Sarah','1992-07-08','MG112233','Malagasy','0344455667','sarah.rakotomalala@gmail.com',7),
('Rasoa','Mamy','1980-03-22','MG445566','Malagasy','0321122455','mamy.rasoa@mail.com',8),
('Jean','Luc','1985-10-11','FR998877','Française','+33677889900','luc.jean@gmail.com',9),
('Raveloson','Noro','1998-06-05','MG778899','Malagasy','0329988776','noro.raveloson@gmail.com',10);

-- BILLETS
INSERT INTO billet (prix, classe, idreservation, idpaiement) VALUES
(1000000,'Premium',1,1),
(1200000,'Premiere Classe',2,2),
(800000,'Economique',3,3),
(1000000,'Premium',4,4),
(800000,'Economique',5,5),
(1200000,'Premiere Classe',6,2),
(800000,'Economique',7,3),
(1200000,'Premiere Classe',8,4),
(1000000,'Premium',9,1),
(800000,'Economique',10,5);
