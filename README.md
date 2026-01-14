P17-ETU003389-Web-Dynamique

## Nouveautés (2026-01-14)

- **Trajets**: ajout des tables `trajet` + `vol_trajet` pour regrouper plusieurs vols (donc plusieurs avions) sur une même route (départ → arrivée).
- **Chiffre d'affaires par avion (par trajet)**: écran `TrajetServlet?action=ca&idTrajet=...` qui somme `billet.prix` par avion sur tous les vols du trajet.
- **Réservation avec choix de place**: sur `ReservationServlet?action=new` (ou edit), vous pouvez choisir un vol puis sélectionner une place sur une grille. Une place déjà réservée pour ce vol devient indisponible.

## Mise à jour BD

Si vous créez la base depuis zéro, exécuter `script.sql` puis `data.sql`.

Si vous avez déjà une base existante, exécuter la migration:

- `migration_2026_01_14.sql`

## Endpoints

- `TrajetServlet` (list/new/edit/delete + CA)
- `ReservationServlet` (inchangé, avec option vol+place)

## Note compilation

Si `javac` échoue avec un message du type "class file has wrong version 55.0, should be 52.0", utilisez un JDK plus récent (au moins Java 11) ou alignez les .jar du dossier `lib/` avec la version de Java utilisée.
