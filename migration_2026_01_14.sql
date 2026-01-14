-- Migration: 2026-01-14
-- Adds Trajet (route) + Vol-Trajet link + Seat reservation per Vol.
-- Safe to run on an existing database.

CREATE TABLE IF NOT EXISTS trajet (
   idtrajet SERIAL PRIMARY KEY,
   idaeroportdepart INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   idaeroportarrive INTEGER NOT NULL REFERENCES aeroport(idaeroport),
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   UNIQUE (idaeroportdepart, idaeroportarrive)
);

CREATE TABLE IF NOT EXISTS vol_trajet (
   idvol INTEGER PRIMARY KEY REFERENCES vol(idvol) ON DELETE CASCADE,
   idtrajet INTEGER NOT NULL REFERENCES trajet(idtrajet) ON DELETE RESTRICT,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reservation_place (
   idreservation INTEGER NOT NULL REFERENCES reservation(idreservation) ON DELETE CASCADE,
   idvol INTEGER NOT NULL REFERENCES vol(idvol) ON DELETE CASCADE,
   idplace INTEGER NOT NULL REFERENCES place(idplace) ON DELETE RESTRICT,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (idreservation, idvol),
   UNIQUE (idvol, idplace)
);
