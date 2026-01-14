CREATE database compagnie;
\c compagnie;

-- =============================================
-- TABLES DE BASE (sans dépendances)
-- =============================================

CREATE TABLE avion (
   idavion SERIAL PRIMARY KEY,
   modele VARCHAR(50),
   capacite INTEGER,
   code VARCHAR(50) UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE aeroport (
   idaeroport SERIAL PRIMARY KEY,
   nom VARCHAR(100),
   ville VARCHAR(100),
   code VARCHAR(10) UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE place (
   idplace SERIAL PRIMARY KEY,
   numeroplace INTEGER NOT NULL UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE modepaiement (
   idmodepaiement SERIAL PRIMARY KEY,
   libelle VARCHAR(100) NOT NULL UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pays (
   idpays SERIAL PRIMARY KEY,
   nom VARCHAR(100),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
   id SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL UNIQUE,
   password VARCHAR(255) NOT NULL,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TRAJET (dépend de aeroport)
-- =============================================

CREATE TABLE trajet (
   idtrajet SERIAL PRIMARY KEY,
   idaeroportdepart INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idaeroportarrive INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   UNIQUE (idaeroportdepart, idaeroportarrive),
   CHECK (idaeroportdepart <> idaeroportarrive)
);

-- =============================================
-- VOL (dépend de trajet, avion)
-- =============================================

CREATE TABLE vol (
   idvol SERIAL PRIMARY KEY,
   numerovol VARCHAR(20),
   datedepart DATE,
   datearrive DATE,
   heuredepart TIME,
   heurearrivee TIME,
   idtrajet INTEGER NOT NULL REFERENCES trajet(idtrajet),
   idavion INTEGER NOT NULL REFERENCES avion(idavion),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- PAIEMENT
-- =============================================

CREATE TABLE paiement (
   idpaiement SERIAL PRIMARY KEY,
   montant NUMERIC(15,2) NOT NULL,
   datepaiement TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   idmodepaiement INTEGER REFERENCES modepaiement(idmodepaiement),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- RESERVATION (dépend de vol, place)
-- =============================================

CREATE TABLE reservation (
   idreservation SERIAL PRIMARY KEY,
   datereservation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   idvol INTEGER NOT NULL REFERENCES vol(idvol),
   idplace INTEGER NOT NULL REFERENCES place(idplace),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   UNIQUE (idvol, idplace)
);

-- =============================================
-- PASSAGER (dépend de reservation)
-- =============================================

CREATE TABLE passager (
   idpassager SERIAL PRIMARY KEY,
   nom VARCHAR(100) NOT NULL,
   prenom VARCHAR(100),
   datenaissance DATE,
   numeropasseport VARCHAR(50),
   nationalite VARCHAR(100),
   telephone VARCHAR(50),
   email VARCHAR(150),
   idreservation INTEGER NOT NULL REFERENCES reservation(idreservation) ON DELETE CASCADE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- BILLET (dépend de reservation, paiement)
-- =============================================

CREATE TABLE billet (
   idbillet SERIAL PRIMARY KEY,
   prix NUMERIC(15,2) NOT NULL,
   classe VARCHAR(50),
   idreservation INTEGER NOT NULL UNIQUE REFERENCES reservation(idreservation),
   idpaiement INTEGER REFERENCES paiement(idpaiement),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLES ASSOCIATIVES
-- =============================================

CREATE TABLE pays_aeroport (
   idaeroport INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idpays INTEGER NOT NULL REFERENCES pays(idpays),
   PRIMARY KEY (idaeroport, idpays)
);

-- =============================================
-- DONNÉES INITIALES
-- =============================================

INSERT INTO users (name, password) VALUES ('admin', 'admin');

INSERT INTO modepaiement (libelle) VALUES 
   ('Espèces'),
   ('Carte bancaire'),
   ('Virement'),
   ('Mobile Money');

-- Places numérotées de 1 à 50
INSERT INTO place (numeroplace) 
SELECT generate_series(1, 50);
