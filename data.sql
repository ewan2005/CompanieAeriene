INSERT INTO pays (nom) VALUES
('Madagascar'),
('France'),
('Maurice'),
('Kenya'),
('Afrique du Sud');


INSERT INTO aeroport (nom, ville, code) VALUES
('Ivato International Airport', 'Antananarivo', 'TNR'),
('Fascene Airport', 'Nosy Be', 'NOS'),
('Toamasina Airport', 'Toamasina', 'TMM'),
('Arrachart Airport', 'Antsiranana', 'DIE'),
('Toliara Airport', 'Toliara', 'TLE');


INSERT INTO place (numeroPlace) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);


INSERT INTO pays_aeroport (idAeroport, idPays) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);


INSERT INTO Avion (model, capacite, code) VALUES
('ATR 72', '70', '5R-ATN'),
('Boeing 737', '160', '5R-BNG'),
('Dash 8 Q400', '78', '5R-DQ4'),
('Airbus A320', '180', '5R-A320');


INSERT INTO Vol (
   numeroVol, dateDepart, dateArrive, heureDepart, heureArrivee,
   idAvion, idAeroportDepart, idAeroportArrive
) VALUES
(101, '2026-02-01', '2026-02-01', '08:00', '09:30', 1, 1, 2),
(102, '2026-02-01', '2026-02-01', '10:00', '11:30', 1, 2, 1),
(201, '2026-02-02', '2026-02-02', '07:00', '08:00', 3, 1, 3),
(301, '2026-02-02', '2026-02-02', '09:00', '10:30', 2, 1, 4),
(401, '2026-02-03', '2026-02-03', '14:00', '15:30', 4, 1, 5);


INSERT INTO employe (nom, prenom, poste, salaire, dateEmbauche) VALUES
('Rakoto', 'Jean', 'Pilote', 3500000, '2020-01-10'),
('Rabe', 'Marie', 'Hotesse', 1200000, '2021-06-15'),
('Andry', 'Paul', 'Copilote', 2500000, '2019-09-01'),
('Soa', 'Lina', 'Agent sol', 900000, '2022-03-20');


INSERT INTO modePaiement (mode) VALUES
('Carte bancaire'),
('Mobile Money'),
('Espèces');


INSERT INTO paiement (montant, datePaiement) VALUES
(350000, '2026-01-20'),
(450000, '2026-01-21'),
(300000, '2026-01-22'),
(600000, '2026-01-23'),
(250000, '2026-01-24');


INSERT INTO modepaiement_paiement (idpaiement, idmode) VALUES
(1, 2),
(2, 1),
(3, 2),
(4, 1),
(5, 3);



INSERT INTO reservation (dateReservation, status, idPaiement) VALUES
('2026-01-20', true, 1),
('2026-01-21', true, 2),
('2026-01-22', true, 3),
('2026-01-23', false, 4),
('2026-01-24', true, 5);


INSERT INTO billet (prix, classe, idreservation, idvol) VALUES
(350000, 'Economique', 1, 1),
(450000, 'Business', 2, 2),
(300000, 'Economique', 3, 3),
(600000, 'Business', 4, 4),
(250000, 'Economique', 5, 5);



INSERT INTO passager (
   nom, prenom, datenaissance, numeropasseport, nationalite, idreservation
) VALUES
('Rakoto', 'Hery', '1995-05-12', 123456, 'Malagasy', 1),
('Rasoanaivo', 'Clara', '1988-08-20', 234567, 'Malagasy', 2),
('Randria', 'Lucas', '2000-01-15', 345678, 'Malagasy', 3),
('Ramanantsoa', 'Julie', '1992-11-03', 456789, 'Malagasy', 4),
('Razafy', 'Michel', '1985-03-27', 567890, 'Malagasy', 5);



-- Voir les vols avec aéroports
SELECT v.numeroVol, a1.ville AS depart, a2.ville AS arrivee
FROM Vol v
JOIN aeroport a1 ON v.idAeroportDepart = a1.idAeroport
JOIN aeroport a2 ON v.idAeroportArrive = a2.idAeroport;

-- Voir les passagers et leurs vols
SELECT p.nom, p.prenom, v.numeroVol
FROM passager p
JOIN reservation r ON p.idReservation = r.idReservation
JOIN billet b ON r.idReservation = b.idReservation
JOIN vol v ON b.idVol = v.idVol;


