\c postgres;
drop database compagnie;
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

-- =============================================
-- CATEGORIES & REMISES
-- =============================================
-- Table pour indiquer les catégories (ex: adulte, enfant)
CREATE TABLE IF NOT EXISTS categorie (
   idcategorie SERIAL PRIMARY KEY,
   libelle VARCHAR(50) NOT NULL UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE aeroport (
   idaeroport SERIAL PRIMARY KEY,
   nom VARCHAR(100),
   ville VARCHAR(100),
   code VARCHAR(10) UNIQUE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table des tarifs par classe (source de vérité pour les tarifs)
CREATE TABLE IF NOT EXISTS tarif_classe (
   type_place VARCHAR(20) PRIMARY KEY,
   tarif NUMERIC(15,2) NOT NULL,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table des places: on référence la table tarif_classe via le champ type_place
CREATE TABLE place (
   idplace SERIAL PRIMARY KEY,
   numeroplace INTEGER NOT NULL,
   type_place VARCHAR(20) NOT NULL DEFAULT 'economique',
   idavion INTEGER NOT NULL REFERENCES avion(idavion) ON DELETE CASCADE,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   UNIQUE (numeroplace, idavion),
   CONSTRAINT fk_place_tarifclasse FOREIGN KEY (type_place) REFERENCES tarif_classe(type_place)
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
-- RESERVATION (dépend de vol, place, categorie)
-- =============================================

CREATE TABLE reservation (
   idreservation SERIAL PRIMARY KEY,
   datereservation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   idvol INTEGER NOT NULL REFERENCES vol(idvol),
   idplace INTEGER NOT NULL REFERENCES place(idplace),
   /* Catégorie du passager pour cette réservation: 1 = adulte (par défaut), 2 = enfant */
   idcategorie INTEGER NOT NULL DEFAULT 1 REFERENCES categorie(idcategorie),
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
-- TABLE DES TARIFS PAR CLASSE
-- =============================================

CREATE TABLE IF NOT EXISTS tarif_classe (
   type_place VARCHAR(20) PRIMARY KEY,
   tarif NUMERIC(15,2) NOT NULL,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Valeurs par défaut
INSERT INTO tarif_classe (type_place, tarif) VALUES
('premiere_classe', 1200000),
('economique', 800000),
('premium', 1000000)
ON CONFLICT (type_place) DO NOTHING;


-- Table qui associe une remise (valeur absolue) à une paire (type_place, categorie)
CREATE TABLE IF NOT EXISTS remise_categorie (
   type_place VARCHAR(20) NOT NULL REFERENCES tarif_classe(type_place),
   idcategorie INTEGER NOT NULL REFERENCES categorie(idcategorie),
   montant_remise NUMERIC(15,2) NOT NULL DEFAULT 0,
   PRIMARY KEY (type_place, idcategorie)
);

-- Valeurs par défaut pour les categories
INSERT INTO categorie (libelle) VALUES
('adulte'),
('enfant')
ON CONFLICT (libelle) DO NOTHING;

-- Exemple de remise: les enfants ont 500000 Ar de remise sur la classe 'economique'
INSERT INTO remise_categorie (type_place, idcategorie, montant_remise)
SELECT tc.type_place, c.idcategorie, 500000.00
FROM tarif_classe tc, categorie c
WHERE tc.type_place = 'economique' AND c.libelle = 'enfant'
ON CONFLICT (type_place, idcategorie) DO NOTHING;

-- =============================================
-- DONNÉES INITIALES
-- =============================================

BEGIN;

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
    users,
    pays,
    aeroport,
    avion
RESTART IDENTITY CASCADE;

-- Ne pas toucher à tarif_classe (table de référence)

COMMIT;

INSERT INTO users (name, password) VALUES ('admin', 'admin');


