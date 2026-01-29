P17-ETU003389-Web-Dynamique

## Résumé

Application web de gestion d'une compagnie aérienne (vols, trajets, réservations, billets, avions, etc.). UI en JSP, backend en servlets Java, base de données SQL.

## Nouveautés

### 2026-01-29 - Produits Extra & Filtre CA

- **Produits Extra**: vente de produits à bord des vols (ex: tablette de chocolat 5000 Ar, boissons, snacks)
  - Gestion du catalogue produits: `ProduitExtraServlet` (list/new/edit/delete)
  - Enregistrement des ventes: `VenteProduitExtraServlet` (list/new/edit/delete)
  - Pas de logique de paiement, juste un enregistrement de la vente liée au vol
- **CA par Vol amélioré**: 
  - Nouvelle colonne "Produits Extra" dans le tableau CA
  - **Filtre par date** pour voir le CA sur une période spécifique
  - Recalcul dynamique des totaux selon le filtre

### 2026-01-15 - Places Avion

- Migration `migration_2026_01_15_places_avion.sql`: gestion des places d'avion

### 2026-01-14 - Trajets & Réservations

- **Trajets**: tables `trajet` + `vol_trajet` pour regrouper plusieurs vols sur une même route
- **Chiffre d'affaires par avion (par trajet)**: `TrajetServlet?action=ca&idTrajet=...`
- **Réservation avec choix de place**: grille de sélection des places disponibles

## Mise à jour BD

Si vous créez la base depuis zéro, exécuter dans l'ordre:

1. `script.sql`
2. `data.sql`

Si vous avez déjà une base existante, exécuter les migrations dans l'ordre:

1. `migration_2026_01_14.sql`
2. `migration_2026_01_15_places_avion.sql`
3. `migration_2026_01_29_produit_extra.sql`

## Endpoints

| Servlet | Description |
|---------|-------------|
| `TrajetServlet` | Gestion des trajets + CA par trajet |
| `ReservationServlet` | Réservations avec choix vol/place |
| `CAParVolServlet` | Vue CA par vol (billets + pub + produits extra) avec filtre date |
| `ProduitExtraServlet` | Catalogue des produits vendus à bord |
| `VenteProduitExtraServlet` | Enregistrement des ventes de produits |

## Note compilation

Si `javac` échoue avec "class file has wrong version 55.0, should be 52.0", utilisez un JDK plus récent (au moins Java 11) ou alignez les .jar du dossier `lib/` avec la version de Java utilisée.
