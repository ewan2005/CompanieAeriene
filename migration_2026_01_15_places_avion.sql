-- Migration: Ajouter les colonnes places première classe et économique pour les avions
-- Date: 2026-01-15

-- Ajouter les nouvelles colonnes à la table avion
ALTER TABLE avion ADD COLUMN IF NOT EXISTS nb_places_premiere_classe INTEGER DEFAULT 0;
ALTER TABLE avion ADD COLUMN IF NOT EXISTS nb_places_economique INTEGER DEFAULT 0;

-- Mettre à jour les avions existants avec des valeurs par défaut basées sur la capacité
-- Par exemple: 20% première classe, 80% économique
UPDATE avion 
SET nb_places_premiere_classe = COALESCE(CAST(capacite AS INTEGER) * 0.2, 0)::INTEGER,
    nb_places_economique = COALESCE(CAST(capacite AS INTEGER) * 0.8, 0)::INTEGER
WHERE nb_places_premiere_classe = 0 AND nb_places_economique = 0 AND capacite IS NOT NULL;

-- Commentaires sur les colonnes
COMMENT ON COLUMN avion.nb_places_premiere_classe IS 'Nombre de places en première classe';
COMMENT ON COLUMN avion.nb_places_economique IS 'Nombre de places en classe économique';

-- Exemple de données pour test
-- INSERT INTO avion (modele, capacite, code, nb_places_premiere_classe, nb_places_economique) 
-- VALUES ('Boeing 737-800', 180, 'B738', 20, 160);

-- Vue pour afficher la valeur maximale potentielle par avion
-- (les prix sont paramétrables, ici exemple Tana-Nosy Be)
CREATE OR REPLACE VIEW v_avion_valeur_max AS
SELECT 
    a.idavion,
    a.modele,
    a.code,
    a.nb_places_premiere_classe,
    a.nb_places_economique,
    (a.nb_places_premiere_classe + a.nb_places_economique) AS capacite_totale,
    -- Valeur max avec prix exemple (1 200 000 Ar première classe, 700 000 Ar économique)
    (a.nb_places_premiere_classe * 1200000 + a.nb_places_economique * 800000) AS valeur_max_vol_exemple
FROM avion a;
