-- Migration: Ajout des produits extra pour les vols
-- Date: 2026-01-29
-- Description: Table pour gérer les produits vendus aux passagers (tablette chocolat, etc.)
--              et les ventes associées à chaque vol

\c compagnie;

-- =============================================
-- TABLE PRODUIT EXTRA
-- =============================================
-- Catalogue des produits vendus à bord

CREATE TABLE IF NOT EXISTS produit_extra (
   idproduit SERIAL PRIMARY KEY,
   nom VARCHAR(100) NOT NULL,
   prix NUMERIC(15,2) NOT NULL,
   description VARCHAR(255),
   actif BOOLEAN DEFAULT true,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLE VENTE PRODUIT EXTRA
-- =============================================
-- Enregistrement des ventes de produits extra par vol
-- Pas de logique de paiement, juste un enregistrement de vente

CREATE TABLE IF NOT EXISTS vente_produit_extra (
   idvente SERIAL PRIMARY KEY,
   idproduit INTEGER NOT NULL REFERENCES produit_extra(idproduit) ON DELETE CASCADE,
   idvol INTEGER NOT NULL REFERENCES vol(idvol) ON DELETE CASCADE,
   quantite INTEGER NOT NULL DEFAULT 1,
   prix_unitaire NUMERIC(15,2) NOT NULL,
   date_vente TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index pour améliorer les performances des requêtes CA
CREATE INDEX IF NOT EXISTS idx_vente_produit_idvol ON vente_produit_extra(idvol);
CREATE INDEX IF NOT EXISTS idx_vente_produit_date ON vente_produit_extra(date_vente);

-- =============================================
-- DONNEES INITIALES
-- =============================================

-- Produit par défaut: Tablette de chocolat à 5000 Ar
INSERT INTO produit_extra (nom, prix, description) 
VALUES ('Tablette de chocolat', 5000, 'Tablette de chocolat artisanal')
ON CONFLICT DO NOTHING;

-- Quelques autres produits courants
-- INSERT INTO produit_extra (nom, prix, description) VALUES
-- ('Eau minérale', 2000, 'Bouteille d''eau 50cl'),
-- ('Sandwich', 8000, 'Sandwich jambon-fromage'),
-- ('Chips', 3000, 'Paquet de chips'),
-- ('Café', 2500, 'Café chaud'),
-- ('Jus de fruit', 3500, 'Jus d''orange ou pomme')
-- ON CONFLICT DO NOTHING;

-- =============================================
-- FIN DE LA MIGRATION
-- =============================================
