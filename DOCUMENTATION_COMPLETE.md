# DOCUMENTATION COMPLÈTE - SYSTÈME DE GESTION COMPAGNIE AÉRIENNE
## Skyfly Airlines

**Durée: 2h**

---

# 1. MCD COMPLET (Modèle Conceptuel de Données)

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           MCD - COMPAGNIE AÉRIENNE SKYFLY                               │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                                    ┌──────────────┐
                                    │    USERS     │
                                    ├──────────────┤
                                    │ #id          │
                                    │ name         │
                                    │ password     │
                                    └──────────────┘


    ┌──────────────┐                                              ┌──────────────┐
    │   AEROPORT   │                                              │    AVION     │
    ├──────────────┤                                              ├──────────────┤
    │ #idaeroport  │                                              │ #idavion     │
    │ nom          │                                              │ modele       │
    │ ville        │                                              │ capacite     │
    │ code         │                                              │ code         │
    └──────────┬───┘                                              └──────┬───────┘
              │                                                          │
              │ 1,n                                                       │ 1,n
              ▼                                                          ▼
    ┌──────────────────┐                                        ┌──────────────┐
    │     TRAJET       │                                        │    PLACE     │
    ├──────────────────┤                                        ├──────────────┤
    │ #idtrajet        │◄────── depart ────────┐                │ #idplace     │
    │ idaeroportdepart │                       │                │ numeroplace  │
    │ idaeroportarrive │◄────── arrive ────────┘                │ type_place   │───────► TARIF_CLASSE
    └────────┬─────────┘                                        │ idavion      │
             │                                                  └──────┬───────┘
             │ 1,n                                                     │
             ▼                                                         │ 1,1
    ┌──────────────────┐                                               ▼
    │      VOL         │◄──────────────────────────────────────────────┘
    ├──────────────────┤                     concerne
    │ #idvol           │
    │ numerovol        │
    │ datedepart       │◄───────────────────────────────────────────────────────────┐
    │ datearrive       │                                                             │
    │ heuredepart      │                                                             │
    │ heurearrivee     │                                                             │
    │ idtrajet         │                                                             │
    │ idavion          │                                                             │
    └────────┬─────────┘                                                             │
             │                                                                       │
             │ 1,n                                                                   │
             ▼                                                                       │
    ┌──────────────────────┐         ┌──────────────┐         ┌──────────────────┐   │
    │    RESERVATION       │         │  CATEGORIE   │         │  DIFFUSION_VOL   │   │
    ├──────────────────────┤         ├──────────────┤         ├──────────────────┤   │
    │ #idreservation       │◄────────│ #idcategorie │         │ #iddiffusion     │───┘
    │ datereservation      │ categ   │ libelle      │         │ idachat          │
    │ idvol                │         └──────────────┘         │ idvol            │
    │ idplace              │                                  └────────┬─────────┘
    │ idcategorie          │                                           │
    └────────┬─────────────┘                                           │ n,1
             │                                                         ▼
             │ 1,1                                            ┌──────────────────┐
             ▼                                                │  ACHAT_DIFFUSION │
    ┌──────────────────┐                                      ├──────────────────┤
    │    PASSAGER      │                                      │ #idachat         │
    ├──────────────────┤                                      │ idsociete        │
    │ #idpassager      │                                      │ mois             │
    │ nom              │                                      │ annee            │
    │ prenom           │                                      │ nombre_diffusions│
    │ datenaissance    │                                      │ cout_unitaire    │
    │ numeropasseport  │                                      └────────┬─────────┘
    │ nationalite      │                                               │
    │ telephone        │                                               │ n,1
    │ email            │                                               ▼
    │ idreservation    │                                      ┌──────────────────┐
    └──────────────────┘                                      │     SOCIETE      │
             ▲                                                ├──────────────────┤
             │                                                │ #idsociete       │
             │ 1,1                                            │ nom              │
             │                                                │ adresse          │
    ┌────────┴─────────────┐                                  │ telephone        │
    │      BILLET          │                                  │ email            │
    ├──────────────────────┤                                  └──────────────────┘
    │ #idbillet            │                                           ▲
    │ prix                 │                                           │
    │ classe               │                                  ┌────────┴─────────┐
    │ idreservation        │                                  │ PAIEMENT_SOCIETE │
    │ idpaiement           │───────────┐                      ├──────────────────┤
    └──────────────────────┘           │                      │ #idpaiement      │
                                       │                      │ idachat          │
                                       ▼                      │ montant          │
                              ┌──────────────────┐            │ date_paiement    │
                              │    PAIEMENT      │            │ reference        │
                              ├──────────────────┤            └──────────────────┘
                              │ #idpaiement      │
                              │ montant          │
                              │ datepaiement     │
                              │ idmodepaiement   │─────────► MODE_PAIEMENT
                              └──────────────────┘


    ┌──────────────────┐                              ┌──────────────────┐
    │  TARIF_CLASSE    │                              │  TARIF_DIFFUSION │
    ├──────────────────┤                              ├──────────────────┤
    │ #type_place (PK) │                              │ #idtarif         │
    │ tarif            │                              │ cout_par_diffusion│
    └────────┬─────────┘                              │ date_debut       │
             │                                        │ date_fin         │
             │ 1,n                                    └──────────────────┘
             ▼
    ┌──────────────────┐
    │ REMISE_CATEGORIE │
    ├──────────────────┤
    │ #type_place (FK) │
    │ #idcategorie (FK)│
    │ montant_remise   │
    └──────────────────┘


    ┌──────────────────┐                              ┌──────────────────┐
    │  PRODUIT_EXTRA   │                              │ VENTE_PRODUIT_   │
    ├──────────────────┤         1,n                  │     EXTRA        │
    │ #idproduit       │◄─────────────────────────────├──────────────────┤
    │ nom              │                              │ #idvente         │
    │ prix             │                              │ idproduit        │
    │ description      │                              │ idvol            │─────► VOL
    │ actif            │                              │ quantite         │
    └──────────────────┘                              │ prix_unitaire    │
                                                      │ date_vente       │
                                                      └──────────────────┘


    ┌──────────────────┐
    │  MODE_PAIEMENT   │
    ├──────────────────┤
    │ #idmodepaiement  │
    │ libelle          │
    └──────────────────┘
```

---

# 2. LISTE DES CLASSES COMPLÈTES (sans attributs)

## Package `oo` (Objets Métier)

| # | Classe | Description |
|---|--------|-------------|
| 1 | `Aeroport` | Gestion des aéroports (départ/arrivée) |
| 2 | `Avion` | Gestion de la flotte d'avions |
| 3 | `Place` | Places dans un avion (types: première classe, premium, économique) |
| 4 | `Trajet` | Liaison entre deux aéroports |
| 5 | `Vol` | Vols programmés sur un trajet avec un avion |
| 6 | `Reservation` | Réservation d'une place sur un vol |
| 7 | `Passager` | Informations du passager associé à une réservation |
| 8 | `Billet` | Billet émis pour une réservation payée |
| 9 | `Paiement` | Paiement pour un billet |
| 10 | `ModePaiement` | Modes de paiement disponibles (espèces, carte, etc.) |
| 11 | `Categorie` | Catégories de passagers (adulte, enfant, bébé) |
| 12 | `Societe` | Sociétés publicitaires |
| 13 | `AchatDiffusion` | Achat de diffusions publicitaires par une société |
| 14 | `DiffusionVol` | Affectation des diffusions aux vols |
| 15 | `TarifDiffusion` | Configuration des tarifs de diffusion publicitaire |
| 16 | `PaiementSociete` | Paiements des sociétés pour les diffusions |
| 17 | `ProduitExtra` | Produits vendus à bord (snacks, boissons) |
| 18 | `VenteProduitExtra` | Ventes de produits extra sur les vols |
| 19 | `CAParVol` | Calcul du chiffre d'affaires par vol |
| 20 | `User` | Utilisateurs du système (authentification) |
| 21 | `DiffusionPaiement` | Détails paiements diffusions |
| 22 | `ReservationPlace` | Liaison réservation-place |
| 23 | `VolTrajet` | Association vol-trajet |

## Package `servlets` (Contrôleurs)

| # | Servlet | Description |
|---|---------|-------------|
| 1 | `AeroportServlet` | CRUD Aéroports |
| 2 | `AvionServlet` | CRUD Avions avec gestion des places |
| 3 | `TrajetServlet` | CRUD Trajets |
| 4 | `VolServlet` | CRUD Vols |
| 5 | `ReservationServlet` | CRUD Réservations |
| 6 | `PassagerServlet` | CRUD Passagers |
| 7 | `BilletServlet` | CRUD Billets |
| 8 | `PaiementServlet` | CRUD Paiements |
| 9 | `SocieteServlet` | CRUD Sociétés publicitaires |
| 10 | `DiffusionServlet` | Gestion des diffusions publicitaires |
| 11 | `TarifDiffusionServlet` | Configuration tarifs diffusion |
| 12 | `TarifServlet` | Configuration tarifs classes |
| 13 | `PaiementSocieteServlet` | Paiements des sociétés |
| 14 | `DiffusionPaiementServlet` | Suivi paiements diffusions |
| 15 | `ProduitExtraServlet` | CRUD Produits extra |
| 16 | `VenteProduitExtraServlet` | Enregistrement ventes produits |
| 17 | `CAParVolServlet` | Affichage CA par vol |
| 18 | `LoginServlet` | Authentification |
| 19 | `HistoriqueServlet` | Historique des opérations |

## Package `utils` (Utilitaires)

| # | Classe | Description |
|---|--------|-------------|
| 1 | `DB` | Connexion à la base de données PostgreSQL |
| 2 | `Schema` | Utilitaires pour vérifier le schéma BD |
| 3 | `Historique` | Gestion de l'historique |
| 4 | `Web` | Utilitaires web |

---

# 3. FONCTIONNALITÉS PAR MODULE

---

## 3.1 GESTION DES AÉROPORTS

### 3.1.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                    LISTE DES AÉROPORTS                                 │
├────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvel Aéroport]                                                   │
├────────────────────────────────────────────────────────────────────────┤
│  ID  │  Code  │  Nom                        │  Ville      │  Actions   │
├──────┼────────┼─────────────────────────────┼─────────────┼────────────┤
│  1   │  TNR   │  Aéroport Ivato             │  Antananarivo│ ✏️ 🗑️     │
│  2   │  MJN   │  Aéroport Amborovy          │  Mahajanga  │ ✏️ 🗑️     │
│  3   │  TLE   │  Aéroport Toliara           │  Toliara    │ ✏️ 🗑️     │
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE AÉROPORT                                 │
├────────────────────────────────────────────────────────────────────────┤
│  Code:     [________]                                                  │
│  Nom:      [________________________________]                          │
│  Ville:    [________________]                                          │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.1.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Aeroport` | Enregistrer un nouvel aéroport |
| `save(Connection conn)` | `Aeroport` | Enregistrer avec connexion existante |
| `update()` | `Aeroport` | Modifier un aéroport |
| `update(Connection conn)` | `Aeroport` | Modifier avec connexion existante |
| `delete()` | `Aeroport` | Supprimer un aéroport |
| `delete(Connection conn)` | `Aeroport` | Supprimer avec connexion existante |
| `findById(int id)` | `Aeroport` | Trouver par ID |
| `findById(Connection conn, int id)` | `Aeroport` | Trouver par ID avec connexion |
| `findAll()` | `Aeroport` | Liste de tous les aéroports |
| `findAll(Connection conn)` | `Aeroport` | Liste avec connexion existante |

### 3.1.3 Table utilisée

**Table principale:** `aeroport`

### 3.1.4 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `idaeroport` | SERIAL PRIMARY KEY | Identifiant unique |
| `nom` | VARCHAR(100) | Nom de l'aéroport |
| `ville` | VARCHAR(100) | Ville de l'aéroport |
| `code` | VARCHAR(10) UNIQUE | Code IATA |
| `date_creation` | TIMESTAMP | Date de création |

---

## 3.2 GESTION DES AVIONS

### 3.2.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              LISTE DES AVIONS                                          │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvel Avion]                                                                      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ID │ Code   │ Modèle      │ 1ère Classe │ Premium │ Économique │ Total  │ Actions    │
├─────┼────────┼─────────────┼─────────────┼─────────┼────────────┼────────┼────────────┤
│  1  │ MD-001 │ Boeing 737  │     10      │   20    │    120     │  150   │ 👁️ ✏️ 🗑️  │
│  2  │ MD-002 │ Airbus A320 │     12      │   24    │    144     │  180   │ 👁️ ✏️ 🗑️  │
└────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE AVION                                    │
├────────────────────────────────────────────────────────────────────────┤
│  Code:              [________]                                         │
│  Modèle:            [________________]                                 │
│  Capacité totale:   [________]                                         │
│                                                                        │
│  Répartition des places:                                               │
│  ├─ Première Classe: [____] places                                     │
│  ├─ Premium:         [____] places                                     │
│  └─ Économique:      [____] places                                     │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.2.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Avion` | Enregistrer un nouvel avion |
| `findById(int id)` | `Avion` | Trouver par ID |
| `findAll()` | `Avion` | Liste de tous les avions |
| `update()` | `Avion` | Modifier un avion |
| `delete()` | `Avion` | Supprimer un avion |
| `getNbPlacesPremiereClasse()` | `Avion` | Nombre de places 1ère classe |
| `getNbPlacesPremium()` | `Avion` | Nombre de places premium |
| `getNbPlacesEconomique()` | `Avion` | Nombre de places économique |
| `getTotalPlaces()` | `Avion` | Total des places |
| `getValeurMaximaleVol()` | `Avion` | Valeur max d'un vol |
| `getPlaces()` | `Avion` | Liste des places de l'avion |
| `save()` | `Place` | Enregistrer une place |
| `findByAvion(int idAvion)` | `Place` | Places d'un avion |
| `countByTypeAndAvion(int idAvion, String type)` | `Place` | Compter par type |

### 3.2.3 Tables utilisées

**Table principale:** `avion`
**Table annexe:** `place`

### 3.2.4 Structure des tables

**Table `avion`:**
| Colonne | Type | Description |
|---------|------|-------------|
| `idavion` | SERIAL PRIMARY KEY | Identifiant unique |
| `modele` | VARCHAR(50) | Modèle de l'avion |
| `capacite` | INTEGER | Capacité totale |
| `code` | VARCHAR(50) UNIQUE | Code de l'avion |
| `date_creation` | TIMESTAMP | Date de création |

**Table `place`:**
| Colonne | Type | Liaison |
|---------|------|---------|
| `idplace` | SERIAL PRIMARY KEY | - |
| `numeroplace` | INTEGER | Numéro de la place |
| `type_place` | VARCHAR(20) | FK → `tarif_classe.type_place` |
| `idavion` | INTEGER | FK → `avion.idavion` |

---

## 3.3 GESTION DES TRAJETS

### 3.3.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                         LISTE DES TRAJETS                              │
├────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Trajet]                                                    │
├────────────────────────────────────────────────────────────────────────┤
│  ID  │  Départ                    │  Arrivée                │ Actions  │
├──────┼────────────────────────────┼─────────────────────────┼──────────┤
│  1   │  Antananarivo (TNR)        │  Mahajanga (MJN)        │ ✏️ 🗑️   │
│  2   │  Antananarivo (TNR)        │  Toliara (TLE)          │ ✏️ 🗑️   │
│  3   │  Mahajanga (MJN)           │  Antananarivo (TNR)     │ ✏️ 🗑️   │
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE TRAJET                                   │
├────────────────────────────────────────────────────────────────────────┤
│  Aéroport de départ:   [▼ Sélectionner un aéroport    ]                │
│  Aéroport d'arrivée:   [▼ Sélectionner un aéroport    ]                │
│                                                                        │
│  ⚠️ Le départ et l'arrivée doivent être différents                     │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.3.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Trajet` | Enregistrer un trajet |
| `update()` | `Trajet` | Modifier un trajet |
| `delete()` | `Trajet` | Supprimer un trajet |
| `findById(int id)` | `Trajet` | Trouver par ID |
| `findAllDetailed()` | `Trajet` | Liste avec détails aéroports |
| `findOrCreate(Connection, int, int)` | `Trajet` | Trouver ou créer |
| `isAvailable(Connection conn)` | `Trajet` | Vérifier disponibilité table |

### 3.3.3 Tables utilisées

**Table principale:** `trajet`
**Tables annexes:** `aeroport` (départ), `aeroport` (arrivée)

### 3.3.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idtrajet` | SERIAL PRIMARY KEY | - |
| `idaeroportdepart` | INTEGER NOT NULL | FK → `aeroport.idaeroport` |
| `idaeroportarrive` | INTEGER NOT NULL | FK → `aeroport.idaeroport` |
| `date_creation` | TIMESTAMP | - |

**Contraintes:**
- UNIQUE (idaeroportdepart, idaeroportarrive)
- CHECK (idaeroportdepart <> idaeroportarrive)

---

## 3.4 GESTION DES VOLS

### 3.4.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    LISTE DES VOLS                                            │
├──────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Vol]                                                                             │
├──────────────────────────────────────────────────────────────────────────────────────────────┤
│  N° Vol │ Trajet                          │ Date Départ │ Heure │ Avion   │ Actions         │
├─────────┼─────────────────────────────────┼─────────────┼───────┼─────────┼─────────────────┤
│  SF001  │ Antananarivo → Mahajanga        │ 2026-02-15  │ 08:00 │ MD-001  │ 👁️ ✏️ 🗑️       │
│  SF002  │ Mahajanga → Antananarivo        │ 2026-02-15  │ 14:00 │ MD-001  │ 👁️ ✏️ 🗑️       │
└──────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE VOL                                      │
├────────────────────────────────────────────────────────────────────────┤
│  Numéro de vol:      [________]                                        │
│  Trajet:             [▼ Sélectionner un trajet           ]             │
│  Avion:              [▼ Sélectionner un avion            ]             │
│                                                                        │
│  Date de départ:     [____-__-__]                                      │
│  Heure de départ:    [__:__]                                           │
│  Date d'arrivée:     [____-__-__]                                      │
│  Heure d'arrivée:    [__:__]                                           │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.4.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Vol` | Enregistrer un vol |
| `update()` | `Vol` | Modifier un vol |
| `delete()` | `Vol` | Supprimer un vol |
| `findById(int id)` | `Vol` | Trouver par ID |
| `findAll()` | `Vol` | Liste de tous les vols |
| `findAllDetailed()` | `Vol` | Liste avec détails trajet/avion |
| `findByTrajet(int idTrajet)` | `Vol` | Vols d'un trajet |
| `findByNumeroVol(String numero)` | `Vol` | Trouver par numéro |
| `countReservations(Connection)` | `Vol` | Compter les réservations |

### 3.4.3 Tables utilisées

**Table principale:** `vol`
**Tables annexes:** 
- `trajet` (trajet du vol) - JOIN sur `idtrajet`
- `avion` (avion utilisé) - JOIN sur `idavion`
- `aeroport` (départ) - via trajet
- `aeroport` (arrivée) - via trajet

### 3.4.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idvol` | SERIAL PRIMARY KEY | - |
| `numerovol` | VARCHAR(20) | Numéro du vol |
| `datedepart` | DATE | Date de départ |
| `datearrive` | DATE | Date d'arrivée |
| `heuredepart` | TIME | Heure de départ |
| `heurearrivee` | TIME | Heure d'arrivée |
| `idtrajet` | INTEGER NOT NULL | FK → `trajet.idtrajet` |
| `idavion` | INTEGER NOT NULL | FK → `avion.idavion` |

---

## 3.5 GESTION DES RÉSERVATIONS

### 3.5.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    LISTE DES RÉSERVATIONS                                            │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvelle Réservation]                                                                            │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Date        │ Vol   │ Trajet                  │ Place │ Passager       │ Catég. │ Billet │ Act│
├──────┼─────────────┼───────┼─────────────────────────┼───────┼────────────────┼────────┼────────┼────┤
│  1   │ 2026-01-15  │ SF001 │ TNR → MJN               │  12   │ RAKOTO Jean    │ Adulte │  ✅    │ ✏️🗑️│
│  2   │ 2026-01-16  │ SF002 │ MJN → TNR               │  5    │ RABE Marie     │ Enfant │  ❌    │ ✏️🗑️│
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE RÉSERVATION                              │
├────────────────────────────────────────────────────────────────────────┤
│  Vol:                [▼ Sélectionner un vol              ]             │
│  Place:              [▼ Sélectionner une place disponible]             │
│  Catégorie passager: [▼ Adulte                           ]             │
│  Date réservation:   [____-__-__]                                      │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.5.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Reservation` | Enregistrer une réservation |
| `update()` | `Reservation` | Modifier une réservation |
| `delete()` | `Reservation` | Supprimer une réservation |
| `findById(int id)` | `Reservation` | Trouver par ID |
| `findAll()` | `Reservation` | Liste des réservations |
| `findAllDetailed()` | `Reservation` | Liste avec détails complets |
| `findWithoutBillet()` | `Reservation` | Réservations sans billet |
| `findReservedPlaceIds(int idVol)` | `Reservation` | Places déjà réservées |
| `findReservedPlaceIdsExcluding(...)` | `Reservation` | Places réservées sauf une |

### 3.5.3 Tables utilisées

**Table principale:** `reservation`
**Tables annexes:**
- `vol` - JOIN sur `idvol`
- `place` - JOIN sur `idplace`
- `categorie` - JOIN sur `idcategorie`
- `passager` - JOIN sur `idreservation`
- `billet` - Vérification existence

### 3.5.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idreservation` | SERIAL PRIMARY KEY | - |
| `datereservation` | TIMESTAMP | Date de réservation |
| `idvol` | INTEGER NOT NULL | FK → `vol.idvol` |
| `idplace` | INTEGER NOT NULL | FK → `place.idplace` |
| `idcategorie` | INTEGER DEFAULT 1 | FK → `categorie.idcategorie` |

**Contraintes:**
- UNIQUE (idvol, idplace) - Une place ne peut être réservée qu'une fois par vol

---

## 3.6 GESTION DES PASSAGERS

### 3.6.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    LISTE DES PASSAGERS                                             │
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [Rechercher: _______________]  [Rechercher]                                                       │
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Nom            │ Prénom     │ Passeport    │ Nationalité │ Téléphone     │ Actions         │
├──────┼────────────────┼────────────┼──────────────┼─────────────┼───────────────┼─────────────────┤
│  1   │ RAKOTO         │ Jean       │ MG123456     │ Malgache    │ 034 00 000 00 │ ✏️ 🗑️           │
│  2   │ RABE           │ Marie      │ MG789012     │ Malgache    │ 033 11 111 11 │ ✏️ 🗑️           │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE PASSAGER                                 │
├────────────────────────────────────────────────────────────────────────┤
│  Réservation:        [▼ Sélectionner une réservation    ]              │
│                                                                        │
│  Nom:                [________________]                                │
│  Prénom:             [________________]                                │
│  Date de naissance:  [____-__-__]                                      │
│  N° Passeport:       [____________]                                    │
│  Nationalité:        [________________]                                │
│  Téléphone:          [______________]                                  │
│  Email:              [________________________]                        │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.6.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Passager` | Enregistrer un passager |
| `update()` | `Passager` | Modifier un passager |
| `delete()` | `Passager` | Supprimer un passager |
| `findById(int id)` | `Passager` | Trouver par ID |
| `findAll()` | `Passager` | Liste des passagers |
| `findByReservation(int idReservation)` | `Passager` | Passager d'une réservation |
| `findByNameOrPassport(String search)` | `Passager` | Recherche par nom/passeport |

### 3.6.3 Tables utilisées

**Table principale:** `passager`
**Table annexe:** `reservation` - JOIN sur `idreservation`

### 3.6.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idpassager` | SERIAL PRIMARY KEY | - |
| `nom` | VARCHAR(100) NOT NULL | Nom du passager |
| `prenom` | VARCHAR(100) | Prénom |
| `datenaissance` | DATE | Date de naissance |
| `numeropasseport` | VARCHAR(50) | N° passeport |
| `nationalite` | VARCHAR(100) | Nationalité |
| `telephone` | VARCHAR(50) | Téléphone |
| `email` | VARCHAR(150) | Email |
| `idreservation` | INTEGER NOT NULL | FK → `reservation.idreservation` |

---

## 3.7 GESTION DES BILLETS

### 3.7.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                         LISTE DES BILLETS                                                │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Billet]                                                                                      │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Vol   │ Trajet           │ Place │ Passager       │ Classe      │ Prix        │ Payé  │ Actions  │
├──────┼───────┼──────────────────┼───────┼────────────────┼─────────────┼─────────────┼───────┼──────────┤
│  1   │ SF001 │ TNR → MJN        │  12   │ RAKOTO Jean    │ Économique  │ 900 000 Ar  │  ✅   │ 👁️ ✏️ 🗑️ │
│  2   │ SF001 │ TNR → MJN        │  3    │ RABE Marie     │ 1ère Classe │ 1 200 000 Ar│  ✅   │ 👁️ ✏️ 🗑️ │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE BILLET                                   │
├────────────────────────────────────────────────────────────────────────┤
│  Réservation:        [▼ Sélectionner réservation sans billet]          │
│                                                                        │
│  Informations calculées automatiquement:                               │
│  ├─ Tarif de base:   1 200 000 Ar                                      │
│  ├─ Remise (enfant): -  200 000 Ar                                     │
│  └─ Prix final:      1 000 000 Ar                                      │
│                                                                        │
│  Paiement:           [▼ Sélectionner un paiement         ]             │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.7.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Billet` | Enregistrer un billet |
| `update()` | `Billet` | Modifier un billet |
| `delete()` | `Billet` | Supprimer un billet |
| `findById(int id)` | `Billet` | Trouver par ID |
| `findAll()` | `Billet` | Liste des billets |
| `findAllDetailed()` | `Billet` | Liste avec détails complets |
| `computePriceForReservation(int idRes)` | `Billet` | Calculer le prix |

**Classe interne `PriceInfo`:**
- `tarifBase` : Tarif de base selon le type de place
- `remise` : Montant de la remise selon catégorie
- `prixFinal` : Prix après remise
- `classe` : Classe de la place

### 3.7.3 Tables utilisées

**Table principale:** `billet`
**Tables annexes:**
- `reservation` - JOIN sur `idreservation`
- `paiement` - JOIN sur `idpaiement`
- `place` - Via réservation
- `tarif_classe` - Pour le calcul du prix
- `remise_categorie` - Pour les remises
- `categorie` - Pour le type de passager

### 3.7.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idbillet` | SERIAL PRIMARY KEY | - |
| `prix` | NUMERIC(15,2) NOT NULL | Prix du billet |
| `classe` | VARCHAR(50) | Classe de la place |
| `idreservation` | INTEGER NOT NULL UNIQUE | FK → `reservation.idreservation` |
| `idpaiement` | INTEGER | FK → `paiement.idpaiement` |

---

## 3.8 GESTION DES PAIEMENTS

### 3.8.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              LISTE DES PAIEMENTS                                       │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Paiement]                                                                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Montant        │ Date       │ Mode de paiement  │ Actions                       │
├──────┼────────────────┼────────────┼───────────────────┼───────────────────────────────┤
│  1   │ 900 000 Ar     │ 2026-01-15 │ Espèces           │ ✏️ 🗑️                         │
│  2   │ 1 200 000 Ar   │ 2026-01-16 │ Mobile Money      │ ✏️ 🗑️                         │
└────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE PAIEMENT                                 │
├────────────────────────────────────────────────────────────────────────┤
│  Montant:            [____________] Ar                                 │
│  Date de paiement:   [____-__-__ __:__]                                │
│  Mode de paiement:   [▼ Sélectionner un mode             ]             │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.8.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Paiement` | Enregistrer un paiement |
| `update()` | `Paiement` | Modifier un paiement |
| `delete()` | `Paiement` | Supprimer un paiement |
| `findById(int id)` | `Paiement` | Trouver par ID |
| `findAll()` | `Paiement` | Liste des paiements |

### 3.8.3 Tables utilisées

**Table principale:** `paiement`
**Table annexe:** `modepaiement` - JOIN sur `idmodepaiement`

### 3.8.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idpaiement` | SERIAL PRIMARY KEY | - |
| `montant` | NUMERIC(15,2) NOT NULL | Montant payé |
| `datepaiement` | TIMESTAMP | Date du paiement |
| `idmodepaiement` | INTEGER | FK → `modepaiement.idmodepaiement` |

---

## 3.9 GESTION DES TARIFS (CLASSES)

### 3.9.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                         TARIFS PAR CLASSE                              │
├────────────────────────────────────────────────────────────────────────┤
│  Type de place        │  Tarif            │  Actions                   │
├───────────────────────┼───────────────────┼────────────────────────────┤
│  Première Classe      │  1 200 000 Ar     │  ✏️                        │
│  Premium              │  1 000 000 Ar     │  ✏️                        │
│  Économique           │    900 000 Ar     │  ✏️                        │
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    MODIFIER TARIF                                      │
├────────────────────────────────────────────────────────────────────────┤
│  Type de place:      Première Classe                                   │
│  Tarif actuel:       1 200 000 Ar                                      │
│  Nouveau tarif:      [____________] Ar                                 │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.9.2 Tables utilisées

**Table principale:** `tarif_classe`

### 3.9.3 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `type_place` | VARCHAR(20) PRIMARY KEY | Type: premiere_classe, premium, economique |
| `tarif` | NUMERIC(15,2) NOT NULL | Tarif de base |
| `date_creation` | TIMESTAMP | Date de création |

**Valeurs par défaut:**
- `premiere_classe`: 1 200 000 Ar
- `premium`: 1 000 000 Ar
- `economique`: 900 000 Ar

---

## 3.10 GESTION DES CATÉGORIES ET REMISES

### 3.10.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                    CATÉGORIES DE PASSAGERS                             │
├────────────────────────────────────────────────────────────────────────┤
│  ID  │  Libellé                                                        │
├──────┼─────────────────────────────────────────────────────────────────┤
│  1   │  Adulte                                                         │
│  2   │  Enfant                                                         │
│  3   │  Bébé                                                           │
└────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    REMISES PAR CATÉGORIE                               │
├────────────────────────────────────────────────────────────────────────┤
│  Type Place     │  Catégorie  │  Montant Remise                        │
├─────────────────┼─────────────┼────────────────────────────────────────┤
│  Économique     │  Enfant     │  200 000 Ar (prix fixe: 700 000 Ar)    │
│  Toutes classes │  Bébé       │  10% du tarif adulte                   │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.10.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `findAll()` | `Categorie` | Liste des catégories |
| `findByLibelle(String libelle)` | `Categorie` | Trouver par libellé |

### 3.10.3 Tables utilisées

**Tables:** `categorie`, `remise_categorie`

### 3.10.4 Structure des tables

**Table `categorie`:**
| Colonne | Type | Description |
|---------|------|-------------|
| `idcategorie` | SERIAL PRIMARY KEY | ID |
| `libelle` | VARCHAR(50) UNIQUE | Libellé |

**Table `remise_categorie`:**
| Colonne | Type | Liaison |
|---------|------|---------|
| `type_place` | VARCHAR(20) | FK → `tarif_classe.type_place` |
| `idcategorie` | INTEGER | FK → `categorie.idcategorie` |
| `montant_remise` | NUMERIC(15,2) | Montant de la remise |
| PRIMARY KEY | (type_place, idcategorie) | - |

---

## 3.11 GESTION DES SOCIÉTÉS PUBLICITAIRES

### 3.11.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              LISTE DES SOCIÉTÉS                                        │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvelle Société]                                                                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Nom                    │ Adresse            │ Téléphone     │ Actions          │
├──────┼────────────────────────┼────────────────────┼───────────────┼──────────────────┤
│  1   │ Orange Madagascar      │ Analakely          │ 034 00 00 00  │ ✏️ 🗑️            │
│  2   │ Telma                  │ Andraharo          │ 033 11 11 11  │ ✏️ 🗑️            │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.11.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `Societe` | Enregistrer une société |
| `update()` | `Societe` | Modifier une société |
| `delete()` | `Societe` | Supprimer une société |
| `findById(int id)` | `Societe` | Trouver par ID |
| `findAll()` | `Societe` | Liste des sociétés |

### 3.11.3 Table utilisée

**Table principale:** `societe`

### 3.11.4 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `idsociete` | SERIAL PRIMARY KEY | ID |
| `nom` | VARCHAR(100) NOT NULL UNIQUE | Nom |
| `adresse` | VARCHAR(255) | Adresse |
| `telephone` | VARCHAR(50) | Téléphone |
| `email` | VARCHAR(150) | Email |

---

## 3.12 GESTION DES ACHATS DE DIFFUSIONS

### 3.12.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    ACHATS DE DIFFUSIONS                                              │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvel Achat]                                                                                    │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID │ Société          │ Période      │ Nb Diff. │ Coût Unit.  │ Total        │ Payé   │ Actions    │
├────┼──────────────────┼──────────────┼──────────┼─────────────┼──────────────┼────────┼────────────┤
│  1  │ Orange Madagascar│ Janvier 2026 │    10    │ 400 000 Ar  │ 4 000 000 Ar │ 50%    │ 👁️ ✏️ 🗑️  │
│  2  │ Telma            │ Janvier 2026 │    5     │ 400 000 Ar  │ 2 000 000 Ar │ 100%   │ 👁️ ✏️ 🗑️  │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    FORMULAIRE ACHAT DIFFUSION                          │
├────────────────────────────────────────────────────────────────────────┤
│  Société:            [▼ Sélectionner une société         ]             │
│  Mois:               [▼ Janvier                          ]             │
│  Année:              [2026]                                            │
│  Nombre de diffusions: [____]                                          │
│                                                                        │
│  Coût unitaire:      400 000 Ar (tarif actuel)                         │
│  Montant total:      __________ Ar                                     │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.12.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `AchatDiffusion` | Enregistrer un achat |
| `update()` | `AchatDiffusion` | Modifier un achat |
| `delete()` | `AchatDiffusion` | Supprimer un achat |
| `findById(int id)` | `AchatDiffusion` | Trouver par ID |
| `findAll()` | `AchatDiffusion` | Liste des achats |
| `findByMoisAnnee(int mois, int annee)` | `AchatDiffusion` | Achats d'un mois |
| `getMontantTotal()` | `AchatDiffusion` | Montant total |
| `getMontantPaye()` | `AchatDiffusion` | Montant payé |
| `getResteAPayer()` | `AchatDiffusion` | Reste à payer |
| `getNomMois()` | `AchatDiffusion` | Nom du mois en français |
| `getPeriode()` | `AchatDiffusion` | Période formatée |

### 3.12.3 Tables utilisées

**Table principale:** `achat_diffusion`
**Table annexe:** `societe` - JOIN sur `idsociete`

### 3.12.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idachat` | SERIAL PRIMARY KEY | - |
| `idsociete` | INTEGER NOT NULL | FK → `societe.idsociete` |
| `mois` | INTEGER CHECK (1-12) | Mois de l'achat |
| `annee` | INTEGER | Année de l'achat |
| `nombre_diffusions` | INTEGER DEFAULT 1 | Nombre acheté |
| `cout_unitaire` | NUMERIC(15,2) DEFAULT 400000 | Coût par diffusion |

**Contrainte:** UNIQUE (idsociete, mois, annee)

---

## 3.13 AFFECTATION DES DIFFUSIONS AUX VOLS

### 3.13.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    DIFFUSIONS PAR VOL                                                │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Affecter Diffusions]                                                                             │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID │ Société          │ Vol    │ Date Vol     │ Nb Diff. │ Montant     │ Actions                    │
├─────┼──────────────────┼────────┼──────────────┼──────────┼─────────────┼────────────────────────────┤
│  1  │ Orange Madagascar│ SF001  │ 2026-02-15   │    3     │ 1 200 000 Ar│ 🗑️                        │
│  2  │ Telma            │ SF001  │ 2026-02-15   │    2     │   800 000 Ar│ 🗑️                        │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────┐
│                    AFFECTER DIFFUSIONS À UN VOL                        │
├────────────────────────────────────────────────────────────────────────┤
│  Achat (Société/Période): [▼ Orange Madagascar - Janvier 2026   ]      │
│  Vol:                     [▼ SF001 - TNR→MJN - 2026-02-15       ]      │
│  Nombre de diffusions:    [____]                                       │
│                                                                        │
│  Diffusions restantes à affecter: 7                                    │
│                                                                        │
│  [Affecter]  [Annuler]                                                 │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.13.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `DiffusionVol` | Enregistrer une diffusion |
| `delete()` | `DiffusionVol` | Supprimer une diffusion |
| `affecterDiffusions(int idAchat, int idVol, int nb)` | `DiffusionVol` | Affecter plusieurs diffusions |
| `supprimerDiffusions(int idAchat, int idVol, int nb)` | `DiffusionVol` | Supprimer plusieurs diffusions |
| `findById(int id)` | `DiffusionVol` | Trouver par ID |
| `findAll()` | `DiffusionVol` | Liste des diffusions |
| `findByVol(int idVol)` | `DiffusionVol` | Diffusions d'un vol |
| `countBySocieteForVol(int idVol)` | `DiffusionVol` | Compter par société |

### 3.13.3 Tables utilisées

**Table principale:** `diffusion_vol`
**Tables annexes:**
- `achat_diffusion` - JOIN sur `idachat`
- `vol` - JOIN sur `idvol`
- `societe` - Via achat_diffusion

### 3.13.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `iddiffusion` | SERIAL PRIMARY KEY | - |
| `idachat` | INTEGER NOT NULL | FK → `achat_diffusion.idachat` ON DELETE CASCADE |
| `idvol` | INTEGER NOT NULL | FK → `vol.idvol` |

---

## 3.14 TARIFS DE DIFFUSION

### 3.14.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                    CONFIGURATION TARIFS DIFFUSION                      │
├────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Tarif]                                                     │
├────────────────────────────────────────────────────────────────────────┤
│  ID │ Coût/Diffusion │ Date Début  │ Date Fin    │ Actions            │
├─────┼────────────────┼─────────────┼─────────────┼────────────────────┤
│  1  │ 400 000 Ar     │ 2026-01-01  │ -           │ ✏️ 🗑️ (actif)      │
│  2  │ 350 000 Ar     │ 2025-01-01  │ 2025-12-31  │ ✏️ 🗑️ (expiré)     │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.14.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `TarifDiffusion` | Enregistrer un tarif |
| `update()` | `TarifDiffusion` | Modifier un tarif |
| `delete()` | `TarifDiffusion` | Supprimer un tarif |
| `findById(int id)` | `TarifDiffusion` | Trouver par ID |
| `findAll()` | `TarifDiffusion` | Liste des tarifs |
| `getTarifActuel()` | `TarifDiffusion` | Tarif en vigueur |
| `getTarifPourDate(Date date)` | `TarifDiffusion` | Tarif à une date |

### 3.14.3 Table utilisée

**Table principale:** `tarif_diffusion`

### 3.14.4 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `idtarif` | SERIAL PRIMARY KEY | ID |
| `cout_par_diffusion` | NUMERIC(15,2) DEFAULT 400000 | Coût unitaire |
| `date_debut` | DATE NOT NULL | Date de début |
| `date_fin` | DATE | Date de fin (NULL = actif) |

---

## 3.15 PAIEMENTS DES SOCIÉTÉS

### 3.15.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    PAIEMENTS DES SOCIÉTÉS                                            │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Paiement]                                                                                │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID │ Société          │ Période      │ Montant      │ Date       │ Référence    │ Actions          │
├─────┼──────────────────┼──────────────┼──────────────┼────────────┼──────────────┼──────────────────┤
│  1  │ Orange Madagascar│ Janvier 2026 │ 2 000 000 Ar │ 2026-01-20 │ PAY-001      │ ✏️ 🗑️            │
│  2  │ Telma            │ Janvier 2026 │ 2 000 000 Ar │ 2026-01-15 │ PAY-002      │ ✏️ 🗑️            │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.15.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `PaiementSociete` | Enregistrer un paiement |
| `update()` | `PaiementSociete` | Modifier un paiement |
| `delete()` | `PaiementSociete` | Supprimer un paiement |
| `findById(int id)` | `PaiementSociete` | Trouver par ID |
| `findAll()` | `PaiementSociete` | Liste des paiements |
| `findByAchat(int idAchat)` | `PaiementSociete` | Paiements d'un achat |
| `getTotalPayeByAchat(int idAchat)` | `PaiementSociete` | Total payé pour un achat |
| `getTotalPayeBySociete(int, int, int)` | `PaiementSociete` | Total par société/mois/année |

### 3.15.3 Tables utilisées

**Table principale:** `paiement_societe`
**Table annexe:** `achat_diffusion` - JOIN sur `idachat`

### 3.15.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idpaiement` | SERIAL PRIMARY KEY | - |
| `idachat` | INTEGER NOT NULL | FK → `achat_diffusion.idachat` ON DELETE CASCADE |
| `montant` | NUMERIC(15,2) NOT NULL | Montant payé |
| `date_paiement` | DATE DEFAULT CURRENT_DATE | Date du paiement |
| `reference` | VARCHAR(100) | Référence du paiement |

---

## 3.16 PRODUITS EXTRA

### 3.16.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              LISTE DES PRODUITS EXTRA                                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouveau Produit]                                                                   │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  ID  │ Nom                    │ Prix        │ Description          │ Actif │ Actions  │
├──────┼────────────────────────┼─────────────┼──────────────────────┼───────┼──────────┤
│  1   │ Tablette Chocolat      │ 5 000 Ar    │ Chocolat noir        │  ✅   │ ✏️ 🗑️    │
│  2   │ Café                   │ 3 000 Ar    │ Café chaud           │  ✅   │ ✏️ 🗑️    │
│  3   │ Sandwich               │ 8 000 Ar    │ Sandwich jambon      │  ✅   │ ✏️ 🗑️    │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.16.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `ProduitExtra` | Enregistrer un produit |
| `update()` | `ProduitExtra` | Modifier un produit |
| `delete(int id)` | `ProduitExtra` | Supprimer un produit |
| `findById(int id)` | `ProduitExtra` | Trouver par ID |
| `findAll()` | `ProduitExtra` | Liste des produits |
| `findAllActifs()` | `ProduitExtra` | Produits actifs uniquement |

### 3.16.3 Table utilisée

**Table principale:** `produit_extra`

### 3.16.4 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `idproduit` | SERIAL PRIMARY KEY | ID |
| `nom` | VARCHAR(100) NOT NULL | Nom du produit |
| `prix` | NUMERIC(15,2) NOT NULL | Prix de vente |
| `description` | TEXT | Description |
| `actif` | BOOLEAN DEFAULT TRUE | Produit actif |

---

## 3.17 VENTES DE PRODUITS EXTRA

### 3.17.1 Dessin d'écran

**Liste des ventes:**
```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    VENTES DE PRODUITS EXTRA                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  [+ Nouvelle Vente]                                                                                  │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ID │ Vol    │ Produit              │ Quantité │ Prix Unit. │ Total      │ Date       │ Actions     │
├─────┼────────┼──────────────────────┼──────────┼────────────┼────────────┼────────────┼─────────────┤
│  1  │ SF001  │ Tablette Chocolat    │    5     │ 5 000 Ar   │ 25 000 Ar  │ 2026-02-15 │ ✏️ 🗑️       │
│  2  │ SF001  │ Café                 │   10     │ 3 000 Ar   │ 30 000 Ar  │ 2026-02-15 │ ✏️ 🗑️       │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

**Formulaire de création/modification:**
```
┌────────────────────────────────────────────────────────────────────────┐
│                    NOUVELLE VENTE DE PRODUIT EXTRA                     │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  Vol:               [▼ SF001 - TNR→MJN - 2026-02-15          ]         │
│                                                                        │
│  Produit:           [▼ Tablette Chocolat - 5 000 Ar          ]         │
│                                                                        │
│  Quantité:          [____]                                             │
│                                                                        │
│  Prix unitaire:     [________] Ar  (pré-rempli selon produit)          │
│                                                                        │
│  Date de vente:     [____-__-__ __:__]                                 │
│                                                                        │
│  ─────────────────────────────────────────────────────────────         │
│  Récapitulatif:                                                        │
│  ├─ Prix unitaire:    5 000 Ar                                         │
│  ├─ Quantité:         × 5                                              │
│  └─ Montant total:    25 000 Ar                                        │
│                                                                        │
│  [Enregistrer]  [Annuler]                                              │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.17.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `VenteProduitExtra` | Enregistrer une vente |
| `update()` | `VenteProduitExtra` | Modifier une vente |
| `delete(int id)` | `VenteProduitExtra` | Supprimer une vente |
| `findById(int id)` | `VenteProduitExtra` | Trouver par ID |
| `findAll()` | `VenteProduitExtra` | Liste des ventes |
| `findByVol(int idVol)` | `VenteProduitExtra` | Ventes d'un vol |
| `getMontantTotal()` | `VenteProduitExtra` | Montant de la vente |

### 3.17.3 Tables utilisées

**Table principale:** `vente_produit_extra`
**Tables annexes:**
- `produit_extra` - JOIN sur `idproduit`
- `vol` - JOIN sur `idvol`

### 3.17.4 Structure de la table

| Colonne | Type | Liaison |
|---------|------|---------|
| `idvente` | SERIAL PRIMARY KEY | - |
| `idproduit` | INTEGER NOT NULL | FK → `produit_extra.idproduit` |
| `idvol` | INTEGER NOT NULL | FK → `vol.idvol` |
| `quantite` | INTEGER DEFAULT 1 | Quantité vendue |
| `prix_unitaire` | NUMERIC(15,2) | Prix au moment de la vente |
| `date_vente` | TIMESTAMP | Date de la vente |

---

## 3.18 CHIFFRE D'AFFAIRES PAR VOL

### 3.18.1 Dessin d'écran

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                          CHIFFRE D'AFFAIRES PAR VOL                                              │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  Filtre: Date début [____-__-__]  Date fin [____-__-__]  [Filtrer]                                               │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  Vol   │ Trajet        │ Date       │ Billets      │ Diffusions    │ Produits    │ CA TOTAL        │ Détails    │
├────────┼───────────────┼────────────┼──────────────┼───────────────┼─────────────┼─────────────────┼────────────┤
│  SF001 │ TNR → MJN     │ 2026-02-15 │ 45 000 000 Ar│ 1 600 000 Ar  │ 55 000 Ar   │ 46 655 000 Ar   │ 👁️         │
│  SF002 │ MJN → TNR     │ 2026-02-15 │ 38 000 000 Ar│   800 000 Ar  │ 42 000 Ar   │ 38 842 000 Ar   │ 👁️         │
├────────┼───────────────┼────────────┼──────────────┼───────────────┼─────────────┼─────────────────┼────────────┤
│  TOTAL │               │            │ 83 000 000 Ar│ 2 400 000 Ar  │ 97 000 Ar   │ 85 497 000 Ar   │            │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.18.2 Signature des fonctions

#### Classe principale: `CAParVol`

| Fonction | Classe | Description |
|----------|--------|-------------|
| `getCAParVol()` | `CAParVol` | CA de tous les vols |
| `getCAParVol(Connection conn)` | `CAParVol` | CA avec connexion existante |
| `getCAParVol(Date debut, Date fin)` | `CAParVol` | CA avec filtre par période |
| `getCAParVol(Connection conn, Date debut, Date fin)` | `CAParVol` | CA avec filtre et connexion |
| `getCAByVolId(int idVol)` | `CAParVol` | CA d'un vol spécifique par ID |
| `getCAByVolId(Connection conn, int idVol)` | `CAParVol` | CA d'un vol avec connexion |
| `getCATotalGlobal()` | `CAParVol` | CA total global (tous vols) |
| `getCATotalGlobal(Connection conn)` | `CAParVol` | CA global avec connexion |

#### Méthodes privées (calculs internes):

| Fonction | Description |
|----------|-------------|
| `getDiffusionsInfoForVolWithPayment(Connection, int idVol)` | Calcule diffusions + paiements proportionnels |
| `getProduitsExtraInfoForVol(Connection, int idVol)` | Calcule ventes produits extra |

#### Classe interne: `CAVolDetail` (Détail CA d'un vol)

| Fonction | Type retour | Description |
|----------|-------------|-------------|
| `getIdVol()` | `int` | ID du vol |
| `getNumeroVol()` | `String` | Numéro du vol |
| `getAeroportDepart()` | `String` | Nom aéroport départ |
| `getAeroportArrive()` | `String` | Nom aéroport arrivée |
| `getAvionCode()` | `String` | Code de l'avion |
| `getAvionModele()` | `String` | Modèle de l'avion |
| `getDateDepart()` | `Date` | Date de départ |
| `getHeureDepart()` | `Time` | Heure de départ |
| `getMontantBillets()` | `BigDecimal` | Somme des prix billets |
| `getMontantDiffusions()` | `BigDecimal` | Montant total diffusions (dû) |
| `getMontantDiffusionsPaye()` | `BigDecimal` | Montant diffusions payé |
| `getMontantProduitsExtra()` | `BigDecimal` | Montant ventes produits |
| `getNbBillets()` | `int` | Nombre de billets vendus |
| `getNbDiffusions()` | `int` | Nombre de diffusions |
| `getNbProduitsExtra()` | `int` | Quantité produits vendus |
| `getDetailDiffusions()` | `String` | Détail texte diffusions |
| `getDiffusionDetails()` | `List<DiffusionDetail>` | Liste détails par société |
| `getMontantTotal()` | `BigDecimal` | **CA TOTAL = Billets + Diffusions + Produits** |
| `getMontantTotalAvecPaiement()` | `BigDecimal` | CA avec diffusions payées uniquement |
| `getResteDiffusionsAPayer()` | `BigDecimal` | Diffusions - Diffusions payées |

#### Classe interne: `DiffusionDetail` (Détail diffusion par société)

| Fonction | Type retour | Description |
|----------|-------------|-------------|
| `getSocieteNom()` | `String` | Nom de la société |
| `getNbDiffusions()` | `int` | Nombre de diffusions sur ce vol |
| `getCoutUnitaire()` | `BigDecimal` | Coût par diffusion |
| `getMontantDu()` | `BigDecimal` | Montant dû = nb × coût unitaire |
| `getMontantPaye()` | `BigDecimal` | Montant payé (proportionnel) |
| `getResteAPayer()` | `BigDecimal` | Montant dû - Montant payé |

---

### 3.18.3 Tables utilisées

#### Table principale: `vol`

| Colonne | Type | Description |
|---------|------|-------------|
| `idvol` | SERIAL PRIMARY KEY | Identifiant du vol |
| `numerovol` | VARCHAR(20) | Numéro du vol |
| `datedepart` | DATE | Date de départ |
| `heuredepart` | TIME | Heure de départ |
| `idtrajet` | INTEGER | FK → trajet |
| `idavion` | INTEGER | FK → avion |

#### Tables annexes et liaisons:

| Table | Type liaison | Colonne de liaison | Description |
|-------|--------------|-------------------|-------------|
| `trajet` | JOIN | `vol.idtrajet = trajet.idtrajet` | Trajet du vol |
| `aeroport` (départ) | JOIN | `trajet.idaeroportdepart = aeroport.idaeroport` | Aéroport de départ |
| `aeroport` (arrivée) | JOIN | `trajet.idaeroportarrive = aeroport.idaeroport` | Aéroport d'arrivée |
| `avion` | JOIN | `vol.idavion = avion.idavion` | Avion utilisé |
| `reservation` | LEFT JOIN | `reservation.idvol = vol.idvol` | Réservations du vol |
| `billet` | LEFT JOIN | `billet.idreservation = reservation.idreservation` | Billets des réservations |
| `diffusion_vol` | LEFT JOIN | `diffusion_vol.idvol = vol.idvol` | Diffusions affectées au vol |
| `achat_diffusion` | JOIN | `diffusion_vol.idachat = achat_diffusion.idachat` | Achat de diffusion |
| `societe` | JOIN | `achat_diffusion.idsociete = societe.idsociete` | Société publicitaire |
| `paiement_societe` | LEFT JOIN | `paiement_societe.idachat = achat_diffusion.idachat` | Paiements des sociétés |
| `vente_produit_extra` | LEFT JOIN | `vente_produit_extra.idvol = vol.idvol` | Ventes de produits extra |

---

### 3.18.4 Requêtes SQL utilisées

#### Requête 1: CA Billets par vol
```sql
SELECT 
    v.idvol,
    v.numerovol,
    ad.nom AS aeroport_depart,
    aa.nom AS aeroport_arrive,
    av.code AS avion_code,
    av.modele AS avion_modele,
    v.datedepart,
    v.heuredepart,
    COALESCE(SUM(b.prix), 0) AS montant_billets,
    COUNT(DISTINCT b.idbillet) AS nb_billets
FROM vol v
JOIN trajet t ON v.idtrajet = t.idtrajet
JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport
JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport
JOIN avion av ON v.idavion = av.idavion
LEFT JOIN reservation r ON r.idvol = v.idvol
LEFT JOIN billet b ON b.idreservation = r.idreservation
WHERE v.datedepart BETWEEN ? AND ?  -- Optionnel: filtre par date
GROUP BY v.idvol, v.numerovol, ad.nom, aa.nom, av.code, av.modele, v.datedepart, v.heuredepart
ORDER BY v.datedepart DESC, v.heuredepart DESC
```

#### Requête 2: Diffusions avec paiement proportionnel par vol
```sql
SELECT 
    s.nom AS societe_nom,
    COUNT(dv.iddiffusion) AS nb_diff,
    a.cout_unitaire,
    a.idachat,
    (a.nombre_diffusions * a.cout_unitaire) AS montant_total_achat,
    COALESCE((SELECT SUM(ps.montant) FROM paiement_societe ps WHERE ps.idachat = a.idachat), 0) AS montant_paye_achat
FROM diffusion_vol dv
JOIN achat_diffusion a ON dv.idachat = a.idachat
JOIN societe s ON a.idsociete = s.idsociete
WHERE dv.idvol = ?
GROUP BY s.nom, a.cout_unitaire, a.idachat, a.nombre_diffusions
ORDER BY s.nom
```

#### Requête 3: Produits extra par vol
```sql
SELECT 
    COALESCE(SUM(quantite * prix_unitaire), 0) AS montant,
    COALESCE(SUM(quantite), 0) AS nb
FROM vente_produit_extra 
WHERE idvol = ?
```

---

### 3.18.5 Formules de calcul

| Élément | Formule | Tables impliquées |
|---------|---------|-------------------|
| **CA Billets** | `SUM(billet.prix)` WHERE reservation.idvol = X | `billet` ← `reservation` ← `vol` |
| **CA Diffusions (dû)** | `COUNT(diffusion_vol) × achat_diffusion.cout_unitaire` | `diffusion_vol` ← `achat_diffusion` |
| **CA Diffusions (payé)** | `montant_diffusion_vol × (paiement_total / montant_total_achat)` | `diffusion_vol` ← `achat_diffusion` ← `paiement_societe` |
| **CA Produits Extra** | `SUM(vente_produit_extra.quantite × vente_produit_extra.prix_unitaire)` | `vente_produit_extra` |
| **CA TOTAL** | `CA Billets + CA Diffusions (dû) + CA Produits Extra` | Toutes les tables |
| **CA avec paiement** | `CA Billets + CA Diffusions (payé) + CA Produits Extra` | Toutes les tables |
| **Reste à payer** | `CA Diffusions (dû) - CA Diffusions (payé)` | `diffusion_vol`, `achat_diffusion`, `paiement_societe` |

---

### 3.18.6 Règle de répartition proportionnelle des paiements

Pour calculer le montant payé des diffusions sur un vol spécifique:

```
1. Pour chaque achat de diffusion affecté au vol:
   - montant_total_achat = nombre_diffusions × cout_unitaire
   - montant_paye_achat = SUM(paiement_societe.montant) pour cet achat
   - pourcentage_paye = (montant_paye_achat / montant_total_achat) × 100

2. Pour les diffusions de ce vol:
   - montant_diffusions_vol = nb_diffusions_vol × cout_unitaire
   - montant_paye_vol = montant_diffusions_vol × (pourcentage_paye / 100)
```

**Exemple:**
- Société X achète 10 diffusions à 400 000 Ar = 4 000 000 Ar total
- Société X a payé 2 000 000 Ar (50%)
- Sur le vol SF001, 3 diffusions de Société X = 1 200 000 Ar
- Montant payé pour ce vol = 1 200 000 × 50% = 600 000 Ar

---

## 3.19 CHIFFRE D'AFFAIRES PUBLICITÉ

### 3.19.1 Dessin d'écran

**Page principale - CA Publicité:**
```
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    📊 CHIFFRE D'AFFAIRES PUBLICITÉ                                               │
│                                         Janvier 2026                                                             │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐ │
│  │  🔎 Filtrer par période                                                                                     │ │
│  │  Mois: [▼ Janvier]   Année: [▼ 2026]   [Rechercher]                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐ │
│  │                           💰 CA TOTAL RÉEL - Janvier 2026                                                   │ │
│  │                                                                                                             │ │
│  │                                    6,000,000 Ar                                                             │ │
│  │                                                                                                             │ │
│  │                               15 diffusions vendues                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐ │
│  │  🧮 Simulation Fictive (sans modifier la base de données)                                                   │ │
│  │  Tarif fictif par diffusion (Ar): [500000_____]   [🧮 Calculer]                                             │ │
│  │  Tarif actuel: 400,000 Ar                                                                                   │ │
│  │                                                                                                             │ │
│  │  ┌───────────────────────────────────────────────────────────────────────────────────────────────────────┐  │ │
│  │  │  💡 CA Simulé avec le nouveau tarif                                                                   │  │ │
│  │  │                          7,500,000 Ar                                                                 │  │ │
│  │  │                    15 diffusions × 500,000 Ar                                                         │  │ │
│  │  │           Différence avec le CA réel: +1,500,000 Ar                                                   │  │ │
│  │  └───────────────────────────────────────────────────────────────────────────────────────────────────────┘  │ │
│  └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  📋 DÉTAIL PAR SOCIÉTÉ                                                                                           │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  Société          │ Diffusions              │ Montant Total  │ Montant Payé │ Reste à Payer                     │
├───────────────────┼─────────────────────────┼────────────────┼──────────────┼───────────────────────────────────┤
│  Orange Madagascar│ 10 × 400,000 Ar         │ 4,000,000 Ar   │ 2,000,000 Ar │ 2,000,000 Ar                      │
│  Telma            │ 5 × 400,000 Ar          │ 2,000,000 Ar   │ 2,000,000 Ar │ ✓ Soldé                           │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ✈️ RÉPARTITION PAR VOL                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  Vol    │ Date       │ Nb Diffusions │ Sociétés                      │ Actions                                  │
├─────────┼────────────┼───────────────┼───────────────────────────────┼──────────────────────────────────────────┤
│  SF001  │ 2026-01-15 │ 8             │ Orange Madagascar, Telma      │ [Détail]                                 │
│  SF002  │ 2026-01-16 │ 7             │ Orange Madagascar, Telma      │ [Détail]                                 │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.19.2 Signature des fonctions

#### Classe principale: `AchatDiffusion`

| Fonction | Classe | Description |
|----------|--------|-------------|
| `getCAByMoisAnnee(int mois, int annee)` | `AchatDiffusion` | CA total pour un mois/année |
| `getCAByMoisAnnee(Connection conn, int mois, int annee)` | `AchatDiffusion` | CA avec connexion existante |
| `findByMoisAnnee(int mois, int annee)` | `AchatDiffusion` | Liste des achats d'un mois/année |
| `findByMoisAnnee(Connection conn, int mois, int annee)` | `AchatDiffusion` | Liste avec connexion |
| `getMontantTotal()` | `AchatDiffusion` | Montant total d'un achat |
| `getMontantPaye()` | `AchatDiffusion` | Montant payé pour un achat |
| `getResteAPayer()` | `AchatDiffusion` | Reste à payer |
| `getDiffusionsAffectees()` | `AchatDiffusion` | Nombre de diffusions affectées |
| `getDiffusionsRestantes()` | `AchatDiffusion` | Nombre de diffusions non affectées |
| `getNomMois()` | `AchatDiffusion` | Nom du mois en français |

#### Classe: `DiffusionVol`

| Fonction | Classe | Description |
|----------|--------|-------------|
| `getResumeParVol(int mois, int annee)` | `DiffusionVol` | Résumé des diffusions par vol |
| `getResumeParVol(Connection conn, int mois, int annee)` | `DiffusionVol` | Résumé avec connexion |
| `countBySocieteForVol(int idVol)` | `DiffusionVol` | Compter diffusions par société pour un vol |
| `countByAchat(int idAchat)` | `DiffusionVol` | Compter diffusions d'un achat |
| `countByAchatAndVol(int idAchat, int idVol)` | `DiffusionVol` | Compter par achat et vol |

#### Classe: `TarifDiffusion`

| Fonction | Classe | Description |
|----------|--------|-------------|
| `getTarifActuel()` | `TarifDiffusion` | Tarif en vigueur actuellement |

#### Servlet: `DiffusionServlet` (action=ca)

| Méthode | Description |
|---------|-------------|
| `doGet(request, response)` action="ca" | Affiche la page CA Publicité |

**Paramètres de requête:**
- `mois` (int): Mois à afficher (1-12)
- `annee` (int): Année à afficher
- `tarifSimule` (BigDecimal, optionnel): Tarif pour simulation

**Attributs de réponse:**
- `mois`, `annee`: Période sélectionnée
- `caTotal`: CA total réel (BigDecimal)
- `achats`: Liste des achats du mois (List<AchatDiffusion>)
- `resumeParVol`: Résumé par vol (List<Object[]>)
- `totalDiffusions`: Nombre total de diffusions (int)
- `tarifActuel`: Tarif actuel (BigDecimal)
- `tarifSimulation`, `caSimule`, `differenceSimule`: Données simulation

---

### 3.19.3 Tables utilisées

#### Table principale: `achat_diffusion`

| Colonne | Type | Description |
|---------|------|-------------|
| `idachat` | SERIAL PRIMARY KEY | Identifiant de l'achat |
| `idsociete` | INTEGER NOT NULL | FK → societe.idsociete |
| `mois` | INTEGER CHECK (1-12) | Mois de l'achat |
| `annee` | INTEGER | Année de l'achat |
| `nombre_diffusions` | INTEGER | Nombre de diffusions achetées |
| `cout_unitaire` | NUMERIC(15,2) | Coût par diffusion |

#### Tables annexes et liaisons:

| Table | Type liaison | Colonne de liaison | Description |
|-------|--------------|-------------------|-------------|
| `societe` | JOIN | `achat_diffusion.idsociete = societe.idsociete` | Société publicitaire |
| `diffusion_vol` | LEFT JOIN | `diffusion_vol.idachat = achat_diffusion.idachat` | Diffusions affectées |
| `vol` | JOIN | `diffusion_vol.idvol = vol.idvol` | Vols concernés |
| `paiement_societe` | LEFT JOIN | `paiement_societe.idachat = achat_diffusion.idachat` | Paiements reçus |
| `tarif_diffusion` | - | (tarif en vigueur) | Configuration du tarif |

---

### 3.19.4 Requêtes SQL utilisées

#### Requête 1: CA Total par mois/année
```sql
SELECT COALESCE(SUM(nombre_diffusions * cout_unitaire), 0) AS ca_total
FROM achat_diffusion 
WHERE mois = ? AND annee = ?
```

#### Requête 2: Liste des achats par mois/année (détail par société)
```sql
SELECT a.*, s.nom AS societe_nom 
FROM achat_diffusion a
JOIN societe s ON a.idsociete = s.idsociete
WHERE a.mois = ? AND a.annee = ?
ORDER BY s.nom
```

#### Requête 3: Résumé des diffusions par vol
```sql
SELECT 
    v.idvol, 
    v.numerovol, 
    v.datedepart,
    COUNT(dv.iddiffusion) AS nb_diffusions,
    STRING_AGG(DISTINCT s.nom, ', ' ORDER BY s.nom) AS societes
FROM diffusion_vol dv
JOIN achat_diffusion a ON dv.idachat = a.idachat
JOIN societe s ON a.idsociete = s.idsociete
JOIN vol v ON dv.idvol = v.idvol
WHERE a.mois = ? AND a.annee = ?
GROUP BY v.idvol, v.numerovol, v.datedepart
ORDER BY v.datedepart
```

#### Requête 4: Montant payé pour un achat
```sql
SELECT COALESCE(SUM(montant), 0) 
FROM paiement_societe 
WHERE idachat = ?
```

---

### 3.19.5 Formules de calcul

| Élément | Formule | Tables impliquées |
|---------|---------|-------------------|
| **CA Total Réel** | `SUM(nombre_diffusions × cout_unitaire)` WHERE mois/annee | `achat_diffusion` |
| **Montant Total Achat** | `nombre_diffusions × cout_unitaire` | `achat_diffusion` |
| **Montant Payé** | `SUM(paiement_societe.montant)` WHERE idachat | `paiement_societe` |
| **Reste à Payer** | `Montant Total - Montant Payé` | `achat_diffusion`, `paiement_societe` |
| **Diffusions Affectées** | `COUNT(diffusion_vol)` WHERE idachat | `diffusion_vol` |
| **Diffusions Restantes** | `nombre_diffusions - Diffusions Affectées` | `achat_diffusion`, `diffusion_vol` |
| **CA Simulé** | `totalDiffusions × tarifSimulé` | Calcul JavaScript côté client |
| **Différence Simulation** | `CA Simulé - CA Réel` | Calcul JavaScript côté client |

---

### 3.19.6 Fonctionnalité de Simulation

La simulation permet de calculer **fictivement** le CA avec un tarif différent, **sans modifier la base de données**.

**Formule:**
```
CA Simulé = Nombre total de diffusions du mois × Tarif simulé
Différence = CA Simulé - CA Réel
```

**Exemple:**
- Janvier 2026: 15 diffusions vendues
- CA Réel: 15 × 400,000 = 6,000,000 Ar
- Si tarif simulé = 500,000 Ar:
  - CA Simulé: 15 × 500,000 = 7,500,000 Ar
  - Différence: +1,500,000 Ar

---

## 3.20 AUTHENTIFICATION

### 3.19.1 Dessin d'écran

```
┌────────────────────────────────────────────────────────────────────────┐
│                                                                        │
│                        ✈️  SKYFLY AIRLINES                             │
│                                                                        │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│                           CONNEXION                                    │
│                                                                        │
│           Nom d'utilisateur: [________________]                        │
│           Mot de passe:      [________________]                        │
│                                                                        │
│                       [    Se connecter    ]                           │
│                                                                        │
│           ⚠️ Identifiants incorrects (si erreur)                       │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.19.2 Signature des fonctions

| Fonction | Classe | Description |
|----------|--------|-------------|
| `save()` | `User` | Créer un utilisateur |
| `findById(int id)` | `User` | Trouver par ID |
| `findByName(String name)` | `User` | Trouver par nom |
| `authenticate(String name, String password)` | `User` | Authentifier |
| `findAll()` | `User` | Liste des utilisateurs |

### 3.19.3 Table utilisée

**Table principale:** `users`

### 3.19.4 Structure de la table

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | SERIAL PRIMARY KEY | ID |
| `name` | VARCHAR(100) NOT NULL UNIQUE | Nom d'utilisateur |
| `password` | VARCHAR(255) NOT NULL | Mot de passe |

---

# RÈGLES DE GESTION

## Réservations et Billets
1. Une place ne peut être réservée qu'une seule fois par vol
2. Un billet ne peut être créé que pour une réservation sans billet existant
3. Le prix du billet est calculé automatiquement selon:
   - Le type de place (tarif_classe)
   - La catégorie du passager (remise_categorie)
   - Règle bébé: 10% du tarif adulte
   - Règle enfant économique: prix fixe selon remise

## Diffusions Publicitaires
1. Une société achète un nombre de diffusions pour un mois
2. Ces diffusions sont ensuite affectées aux vols
3. Coût par diffusion: 400 000 Ar (par défaut)
4. Les paiements sont répartis proportionnellement sur les vols

## Tarification
1. Tarifs par classe: Première > Premium > Économique
2. Remises possibles selon catégorie de passager
3. Les tarifs de diffusion peuvent évoluer dans le temps

---

# ANNEXE: SCRIPTS SQL PRINCIPAUX

```sql
-- Insérer valeurs par défaut tarifs
INSERT INTO tarif_classe (type_place, tarif) VALUES
('premiere_classe', 1200000),
('economique', 900000),
('premium', 1000000);

-- Insérer catégories par défaut
INSERT INTO categorie (libelle) VALUES
('adulte'),
('enfant'),
('bebe');

-- Utilisateur par défaut
INSERT INTO users (name, password) VALUES ('admin', 'admin');
```

---

**Document généré le: 30 Janvier 2026**
**Projet: Skyfly Airlines - Système de Gestion Compagnie Aérienne**
