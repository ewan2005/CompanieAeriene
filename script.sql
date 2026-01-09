CREATE database compagnie;
\c compagnie;

-- PostgreSQL-adapted schema
CREATE TABLE avion (
   idavion SERIAL PRIMARY KEY,
   model VARCHAR(50),
   capacite VARCHAR(50),
   code VARCHAR(50),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE paiement (
   idpaiement SERIAL PRIMARY KEY,
   montant NUMERIC(15,2),
   datepaiement TIMESTAMP,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reservation (
   idreservation SERIAL PRIMARY KEY,
   datereservation TIMESTAMP,
   status BOOLEAN,
   idpaiement INTEGER REFERENCES paiement(idpaiement),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE passager (
   idpassager SERIAL PRIMARY KEY,
   nom VARCHAR(50),
   prenom VARCHAR(50),
   datenaissance TIMESTAMP,
   numeropasseport VARCHAR(50),
   nationalite VARCHAR(50),
   idreservation INTEGER NOT NULL REFERENCES reservation(idreservation),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE aeroport (
   idaeroport SERIAL PRIMARY KEY,
   nom VARCHAR(50),
   ville VARCHAR(50),
   code VARCHAR(50),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE place (
   idPlace SERIAL PRIMARY KEY,
   numeroPlace INTEGER NOT NULL,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vol (
   idvol SERIAL PRIMARY KEY,
   numerovol INTEGER,
   datedepart TIMESTAMP,
   datearrive TIMESTAMP,
   heuredepart TIME,
   heurearrivee TIME,
   idavion INTEGER NOT NULL REFERENCES avion(idavion),
   idaeroportdepart INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idaeroportarrive INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idpassager INTEGER REFERENCES passager(idpassager),
   idPlace INTEGER REFERENCES place(idPlace),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pays (
   idpays SERIAL PRIMARY KEY,
   nom VARCHAR(50),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employe (
   idemploye SERIAL PRIMARY KEY,
   nom VARCHAR(50),
   prenom VARCHAR(50),
   poste VARCHAR(50),
   salaire INTEGER,
   dateembauche TIMESTAMP,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE modepaiement (
   idmode SERIAL PRIMARY KEY,
   mode VARCHAR(50),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE billet (
   idbillet SERIAL PRIMARY KEY,
   prix NUMERIC(15,2) NOT NULL,
   classe VARCHAR(50),
   idreservation INTEGER NOT NULL REFERENCES reservation(idreservation),
   idvol INTEGER NOT NULL REFERENCES vol(idvol),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pays_aeroport (
   idaeroport INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idpays INTEGER NOT NULL REFERENCES pays(idpays),
   PRIMARY KEY (idaeroport, idpays)
);

CREATE TABLE modepaiement_paiement (
   idpaiement INTEGER NOT NULL REFERENCES paiement(idpaiement),
   idmode INTEGER NOT NULL REFERENCES modepaiement(idmode),
   PRIMARY KEY (idpaiement, idmode)
);

CREATE TABLE users (
   id SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL UNIQUE,
   password VARCHAR(255) NOT NULL,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, password) VALUES ('admin', 'admin');
