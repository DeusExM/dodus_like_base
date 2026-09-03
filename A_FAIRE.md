# A_FAIRE.md

Ce fichier suit l'avancement du projet défini dans `MANIFEST.md`.

## Règles pour Codex

Avant de commencer une tâche :

* [ ] Lire `MANIFEST.md`.
* [ ] Lire entièrement ce fichier.
* [ ] Vérifier les tâches déjà terminées.
* [ ] Ne pas refaire une fonctionnalité existante sans raison.
* [ ] Respecter l'ordre des phases sauf blocage technique justifié.
* [ ] Ne traiter qu'une étape cohérente à la fois.
* [ ] Après chaque étape importante, lancer les tests, le lint et les builds.
* [ ] Corriger les régressions avant de continuer.
* [ ] Mettre ce fichier à jour après chaque tâche terminée.

Convention :

* `[ ]` : à faire
* `[x]` : terminé

---

# PHASE 0 — Analyse initiale

## M00 — Vérifier l'état du repository

* [ ] Inspecter tous les dossiers existants.
* [ ] Vérifier les fichiers déjà présents.
* [ ] Vérifier s'il existe déjà un frontend.
* [ ] Vérifier s'il existe déjà un backend.
* [ ] Vérifier les dépendances installées.
* [ ] Vérifier les scripts disponibles.
* [ ] Vérifier Git.
* [ ] Vérifier `.gitignore`.
* [ ] Lire `README.md` s'il existe.
* [ ] Lire `MANIFEST.md`.

### Validation

À la fin de cette étape, Codex doit pouvoir expliquer brièvement :

* architecture actuelle ;
* technologies présentes ;
* ce qui existe déjà ;
* ce qui manque ;
* éventuels problèmes avant développement.

---

# PHASE 1 — Initialisation du projet

## M01 — Créer le monorepo

Structure cible :

```text
apps/
  web/
  server/

packages/
  shared/
```

* [ ] Configurer pnpm workspace.
* [ ] Créer `pnpm-workspace.yaml`.
* [ ] Créer les `package.json`.
* [ ] Ajouter scripts globaux.
* [ ] Configurer TypeScript strict.

### Scripts souhaités

```bash
pnpm dev
pnpm build
pnpm lint
pnpm test
```

### Validation

* [ ] `pnpm install` fonctionne.
* [ ] Aucun package cassé.
* [ ] Le workspace reconnaît web/server/shared.

---

# PHASE 2 — Frontend minimal

## M02 — Initialiser React

Dans :

```text
apps/web
```

Créer :

* [ ] Vite.
* [ ] React.
* [ ] TypeScript.
* [ ] ESLint.
* [ ] structure de base.

Créer au minimum :

```text
src/
  game/
  components/
  pages/
  services/
  stores/
```

### Validation

* [ ] `pnpm dev` lance le frontend.
* [ ] La page s'affiche.
* [ ] Aucun warning critique.

---

# PHASE 3 — Backend minimal

## M03 — Initialiser NestJS

Dans :

```text
apps/server
```

Créer :

* [ ] serveur NestJS ;
* [ ] configuration TypeScript ;
* [ ] configuration environnement ;
* [ ] endpoint `/health`.

Exemple :

```text
GET /health

{
  "status": "ok"
}
```

### Validation

* [ ] Le serveur démarre.
* [ ] `/health` répond correctement.

---

# PHASE 4 — Package partagé

## M04 — Créer `packages/shared`

Créer :

```text
packages/shared/
  types/
  events/
  constants/
  game-rules/
```

* [ ] Configurer les exports.
* [ ] Le frontend peut importer shared.
* [ ] Le backend peut importer shared.
* [ ] Aucun code Node spécifique dans shared.

### Validation

Créer un type de test partagé et vérifier qu'il est compilé côté web et serveur.

---

# PHASE 5 — Docker et PostgreSQL

## M05 — Ajouter PostgreSQL

Créer :

```text
docker-compose.yml
```

Avec :

* [ ] PostgreSQL ;
* [ ] volume persistant ;
* [ ] variables d'environnement.

Créer :

```text
.env.example
```

Ne jamais ajouter les vrais secrets.

### Validation

```bash
docker compose up -d
```

doit démarrer PostgreSQL correctement.

---

# PHASE 6 — Prisma

## M06 — Installer Prisma

* [ ] Installer Prisma dans le backend.
* [ ] Configurer PostgreSQL.
* [ ] Créer première migration.
* [ ] Tester la connexion.

Créer les premiers modèles :

```text
User
Character
```

---

# PHASE 7 — Modèle User

## M07 — Créer User

Champs minimum :

```text
id
email
username
passwordHash
createdAt
updatedAt
```

Contraintes :

* [ ] email unique ;
* [ ] username unique.

### Validation

* [ ] migration fonctionne ;
* [ ] Prisma Client fonctionne.

---

# PHASE 8 — Authentification

## M08 — Inscription

Créer :

```text
POST /auth/register
```

Fonctions :

* [ ] validation email ;
* [ ] validation pseudo ;
* [ ] validation mot de passe ;
* [ ] hash du mot de passe ;
* [ ] création utilisateur ;
* [ ] gestion email existant ;
* [ ] gestion pseudo existant.

---

## M09 — Connexion

Créer :

```text
POST /auth/login
```

* [ ] vérifier utilisateur ;
* [ ] comparer mot de passe ;
* [ ] créer session ;
* [ ] utiliser cookie HTTP-only sécurisé.

---

## M10 — Session utilisateur

Créer :

```text
GET /auth/me
POST /auth/logout
```

### Validation

Le scénario suivant doit fonctionner :

1. inscription ;
2. connexion ;
3. refresh navigateur ;
4. utilisateur toujours connecté ;
5. logout ;
6. session détruite.

---

# PHASE 9 — Pages d'authentification

## M11 — Interface inscription

Créer une page :

```text
/register
```

Avec :

* [ ] email ;
* [ ] pseudo ;
* [ ] mot de passe ;
* [ ] confirmation ;
* [ ] erreurs affichées correctement.

---

## M12 — Interface connexion

Créer :

```text
/login
```

Avec :

* [ ] email ou pseudo ;
* [ ] mot de passe ;
* [ ] bouton connexion ;
* [ ] lien vers inscription.

---

# PHASE 10 — Personnage

## M13 — Modèle Character

Créer les champs :

```text
id
userId
name

level
xp
gold

hp
maxHp

actionPoints
movementPoints

strength
intelligence

mapId
positionX
positionY

createdAt
updatedAt
```

Valeurs initiales :

```text
level = 1
xp = 0
gold = 0

hp = 50
maxHp = 50

actionPoints = 6
movementPoints = 3

strength = 10
intelligence = 10

mapId = village
```

---

## M14 — Création du personnage

Créer :

```text
POST /characters
```

Pour le MVP :

* [ ] maximum 1 personnage par compte ;
* [ ] nom unique ou suffisamment contrôlé ;
* [ ] validation du nom.

---

## M15 — Interface personnage

Si aucun personnage :

afficher :

```text
Créer mon personnage
```

Sinon :

```text
Jouer
```

---

# PHASE 11 — Phaser

## M16 — Intégrer Phaser

Dans React :

* [ ] créer GameCanvas ;
* [ ] initialiser Phaser ;
* [ ] gérer destruction propre de l'instance ;
* [ ] éviter plusieurs instances lors des rerenders React.

---

# PHASE 12 — Première carte

## M17 — Créer Village

Créer une première map fonctionnelle.

Pour commencer, elle peut utiliser :

* tiles placeholders ;
* formes simples ;
* couleurs temporaires.

Prévoir :

```text
20 × 14 cases
```

---

## M18 — Grille logique

Chaque case doit contenir :

```typescript
{
  x: number;
  y: number;
  walkable: boolean;
}
```

* [ ] afficher temporairement la grille en mode debug ;
* [ ] différencier cases traversables/non traversables.

---

# PHASE 13 — Joueur dans le monde

## M19 — Afficher le personnage

* [ ] sprite placeholder ;
* [ ] position correcte ;
* [ ] pseudo éventuellement visible ;
* [ ] caméra correctement configurée.

---

## M20 — Déplacement à la souris

Le joueur clique sur une case.

Le personnage doit :

* [ ] identifier la case ;
* [ ] calculer chemin ;
* [ ] se déplacer ;
* [ ] éviter obstacles.

---

## M21 — Pathfinding A*

Créer ou intégrer A*.

Tester :

* [ ] ligne droite ;
* [ ] obstacle ;
* [ ] destination inaccessible ;
* [ ] clic hors map.

---

# PHASE 14 — Socket.IO

## M22 — Ajouter Socket.IO serveur

Créer Gateway NestJS.

Événements initiaux :

```text
WORLD_JOIN
PLAYER_JOINED
PLAYER_LEFT
PLAYER_MOVE_REQUEST
PLAYER_MOVED
```

---

## M23 — Ajouter Socket.IO client

* [ ] connexion socket ;
* [ ] reconnexion ;
* [ ] gestion des erreurs ;
* [ ] identification joueur.

---

# PHASE 15 — Multijoueur monde

## M24 — Rooms par carte

Utiliser :

```text
map:village
map:prairie
map:forest
map:ruins
```

---

## M25 — Synchroniser les joueurs

Lorsqu'un joueur rejoint :

* [ ] recevoir les joueurs déjà présents ;
* [ ] informer les autres de son arrivée.

Lorsqu'il part :

* [ ] supprimer son sprite.

---

## M26 — Synchroniser les déplacements

Le client envoie :

```text
PLAYER_MOVE_REQUEST
```

Le serveur :

1. valide ;
2. met à jour la position ;
3. broadcast `PLAYER_MOVED`.

### Validation obligatoire

Ouvrir deux navigateurs.

* [ ] Joueur A voit B.
* [ ] B voit A.
* [ ] Un déplacement de A apparaît chez B.
* [ ] Un déplacement de B apparaît chez A.
* [ ] Une déconnexion supprime correctement le personnage.

---

# PHASE 16 — Autorité serveur

## M27 — Déplacement serveur

Ne plus considérer la position client comme vérité.

Le serveur doit vérifier :

* [ ] map correcte ;
* [ ] destination existante ;
* [ ] case traversable ;
* [ ] chemin valide.

Le serveur conserve la position officielle.

---

# PHASE 17 — Quatre cartes

## M28 — Prairie

Créer :

* [ ] décor prairie ;
* [ ] grille ;
* [ ] obstacles ;
* [ ] sorties.

---

## M29 — Forêt

Créer :

* [ ] décor forêt ;
* [ ] grille ;
* [ ] obstacles ;
* [ ] sorties.

---

## M30 — Ruines

Créer :

* [ ] décor ruines ;
* [ ] grille ;
* [ ] obstacles ;
* [ ] sorties.

---

# PHASE 18 — Transitions entre cartes

## M31 — Sorties de carte

Définir des zones :

```text
EXIT_VILLAGE
EXIT_PRAIRIE
EXIT_FOREST
EXIT_RUINS
```

---

## M32 — Changement de map serveur

Créer :

```text
MAP_CHANGE_REQUEST
MAP_CHANGED
```

Le serveur doit :

* [ ] vérifier que le joueur est près d'une sortie ;
* [ ] quitter ancienne room ;
* [ ] modifier mapId ;
* [ ] modifier position ;
* [ ] rejoindre nouvelle room ;
* [ ] envoyer nouvel état.

---

# PHASE 19 — Système de monstres

## M33 — MonsterTemplate

Créer les données statiques des monstres.

Minimum :

### Gelée des prés

```text
level 1
hp 30
ap 6
mp 3
```

### Sanglier des bois

```text
level 2
hp 50
ap 6
mp 4
```

### Gardien de pierre

```text
level 3
hp 80
ap 6
mp 2
```

### Ancien gardien

```text
level 5
hp 150
```

---

## M34 — MonsterInstance

Créer côté serveur :

```typescript
MonsterInstance {
  id
  templateId
  mapId
  x
  y
  state
}
```

États :

```text
IDLE
IN_COMBAT
DEAD
RESPAWNING
```

---

## M35 — Spawn des monstres

Créer des points de spawn par carte.

Exemple :

Prairie :

* [ ] 3 à 5 Gelées.

Forêt :

* [ ] 2 à 4 Sangliers.

Ruines :

* [ ] 2 à 4 Gardiens.
* [ ] possibilité Ancien Gardien.

---

## M36 — Synchronisation monstres

Événements :

```text
MONSTER_SPAWNED
MONSTER_REMOVED
MONSTER_MOVED
```

Tous les joueurs d'une même map doivent voir les mêmes monstres.

---

## M37 — Respawn

Lorsqu'un monstre meurt :

* [ ] passer DEAD ;
* [ ] disparaître ;
* [ ] attendre 20 à 60 secondes ;
* [ ] réapparaître.

---

# PHASE 20 — Préparation du combat

## M38 — Clic sur monstre

Permettre :

```text
clic monstre
→ sélectionner
→ attaquer
```

Pour le MVP, un clic direct peut lancer la demande.

---

## M39 — COMBAT_REQUEST

Envoyer :

```typescript
{
  monsterId
}
```

Le serveur vérifie :

* [ ] joueur connecté ;
* [ ] joueur pas déjà en combat ;
* [ ] monstre existant ;
* [ ] monstre IDLE ;
* [ ] même map ;
* [ ] distance valide.

---

# PHASE 21 — CombatInstance

## M40 — Créer CombatInstance

Structure :

```typescript
CombatInstance {
  id
  mapId
  fighters
  turnOrder
  currentTurnIndex
  turnNumber
  state
}
```

États :

```text
PREPARATION
ACTIVE
VICTORY
DEFEAT
FINISHED
```

---

# PHASE 22 — Grille de combat

## M41 — Créer CombatGrid

Dimension :

```text
12 × 10
```

Doit gérer :

* [ ] cases libres ;
* [ ] cases bloquées ;
* [ ] combattants ;
* [ ] déplacement ;
* [ ] portée.

---

## M42 — Positionnement initial

Positionner :

* [ ] joueur à gauche ;
* [ ] monstre à droite ;
* [ ] obstacles simples.

---

# PHASE 23 — Interface combat

## M43 — Créer CombatScene Phaser

Lors du démarrage combat :

* [ ] quitter affichage monde ;
* [ ] ouvrir scène combat ;
* [ ] afficher grille ;
* [ ] afficher joueur ;
* [ ] afficher monstre.

---

# PHASE 24 — Tours

## M44 — Ordre des tours

Créer une caractéristique initiative simple.

Calculer :

```text
turnOrder
```

Afficher le combattant actif.

---

## M45 — Tour joueur

Au début :

```text
PA = maxPA
PM = maxPM
```

Le joueur peut :

* [ ] marcher ;
* [ ] attaquer ;
* [ ] finir son tour.

---

## M46 — Fin de tour

Créer :

```text
COMBAT_END_TURN
```

Le serveur :

* [ ] valide le joueur ;
* [ ] change combattant actif ;
* [ ] restaure PA/PM du suivant.

---

## M47 — Timer

Maximum :

```text
30 secondes
```

Si timeout :

* [ ] terminer automatiquement le tour.

---

# PHASE 25 — Déplacement combat

## M48 — Déplacement avec PM

Chaque case :

```text
1 PM
```

Vérifier :

* [ ] pathfinding ;
* [ ] nombre de PM ;
* [ ] obstacles ;
* [ ] présence combattants.

---

## M49 — Surbrillance déplacement

Au clic du joueur :

afficher :

* [ ] cases accessibles ;
* [ ] chemin prévisualisé ;
* [ ] coût PM.

---

# PHASE 26 — Sorts

## M50 — Architecture Spell

Créer :

```typescript
Spell {
  id
  name
  apCost
  minRange
  maxRange
  requiresLineOfSight
  effect
}
```

---

## M51 — Coup d'épée

```text
3 PA
Portée 1
8-12 dégâts
Force
```

---

## M52 — Boule de feu

```text
4 PA
Portée 2-5
7-11 dégâts
Intelligence
Ligne de vue
```

---

## M53 — Soin mineur

```text
3 PA
Portée 0-3
6-10 soins
```

---

# PHASE 27 — Sélection des sorts

## M54 — Barre de sorts

Afficher :

```text
[Épée]
[Feu]
[Soin]
```

Chaque bouton doit afficher :

* [ ] nom ;
* [ ] coût PA.

---

## M55 — Portée

Lorsqu'un sort est sélectionné :

* [ ] afficher cases disponibles ;
* [ ] masquer/interdire cases impossibles ;
* [ ] afficher cible sélectionnable.

---

# PHASE 28 — Validation serveur des sorts

## M56 — COMBAT_CAST_REQUEST

Le client envoie uniquement :

```text
spellId
target
```

Le serveur vérifie :

* [ ] bon tour ;
* [ ] joueur vivant ;
* [ ] sort existant ;
* [ ] assez de PA ;
* [ ] portée ;
* [ ] ligne de vue ;
* [ ] cible valide.

---

# PHASE 29 — Dégâts

## M57 — DamageService

Formule initiale :

```typescript
baseDamage * (1 + stat / 100)
```

Ajouter petite variation aléatoire.

Les dégâts sont calculés uniquement serveur.

---

## M58 — Feedback dégâts

Afficher au-dessus du personnage :

```text
-12
```

Ajouter si possible :

* [ ] petit mouvement ;
* [ ] flash ;
* [ ] animation simple.

---

# PHASE 30 — Soins

## M59 — Gestion soin

Le soin :

* [ ] ne dépasse pas maxHP ;
* [ ] retire PA ;
* [ ] fonctionne sur soi-même.

Afficher :

```text
+8
```

---

# PHASE 31 — IA monstres

## M60 — IA version 1

À son tour :

1. trouver joueur ;
2. si attaque possible → attaquer ;
3. sinon avancer ;
4. attaquer si possible ;
5. finir tour.

---

## M61 — Pathfinding IA

Le monstre doit :

* [ ] éviter obstacles ;
* [ ] éviter cases occupées ;
* [ ] respecter PM.

---

# PHASE 32 — Mort

## M62 — Mort d'un combattant

Si :

```text
HP <= 0
```

* [ ] passer mort ;
* [ ] ne plus jouer ;
* [ ] ne plus bloquer certains calculs selon règle choisie ;
* [ ] jouer animation mort.

---

# PHASE 33 — Victoire / défaite

## M63 — Victoire

Lorsque tous les monstres sont morts :

```text
VICTORY
```

---

## M64 — Défaite

Lorsque tous les joueurs sont morts :

```text
DEFEAT
```

---

# PHASE 34 — Récompenses

## M65 — XP

Récompenses :

```text
Gelée : 20
Sanglier : 35
Gardien : 60
Ancien Gardien : 150
```

---

## M66 — Or

Créer récompenses simples en or.

Exemple :

```text
Gelée : 4-8
Sanglier : 7-15
Gardien : 12-25
Ancien Gardien : 40-70
```

Toutes les valeurs sont générées côté serveur.

---

# PHASE 35 — Écran de résultat

## M67 — Fenêtre victoire

Afficher :

```text
VICTOIRE

XP +35
Or +12

Continuer
```

---

## M68 — Retour dans le monde

Après combat :

* [ ] fermer CombatScene ;
* [ ] revenir sur map ;
* [ ] remettre monstre en état mort ;
* [ ] mettre à jour personnage ;
* [ ] synchroniser monde.

---

# PHASE 36 — Level-up

## M69 — Progression niveau

Valeurs :

```text
Niveau 2 : 100 XP
Niveau 3 : 250 XP
Niveau 4 : 500 XP
Niveau 5 : 900 XP
```

---

## M70 — Statistiques niveau

À chaque niveau :

```text
+10 maxHP
+2 Force
+2 Intelligence
```

---

## M71 — Effet level-up

Afficher :

```text
NIVEAU SUPÉRIEUR !
```

Ajouter un petit effet graphique.

---

# PHASE 37 — Sauvegarde

## M72 — Persistance personnage

Sauvegarder :

* [ ] map ;
* [ ] position ;
* [ ] HP ;
* [ ] XP ;
* [ ] level ;
* [ ] gold ;
* [ ] stats.

---

## M73 — Reconnexion

Tester :

1. gagner combat ;
2. gagner XP ;
3. gagner or ;
4. logout ;
5. arrêter serveur ;
6. relancer serveur ;
7. reconnecter.

Les données doivent être conservées.

---

# PHASE 38 — Défaite

## M74 — Retour Village

Après défaite :

* [ ] téléporter au Village ;
* [ ] restaurer les PV ;
* [ ] sauvegarder position.

---

# PHASE 39 — Chat

## M75 — Interface chat

Créer petite fenêtre.

---

## M76 — WebSocket chat

Événements :

```text
CHAT_SEND
CHAT_MESSAGE
```

Un message contient :

```text
playerName
message
timestamp
```

---

## M77 — Protection chat

* [ ] longueur maximum ;
* [ ] rate limit ;
* [ ] nettoyage contenu ;
* [ ] empêcher payload invalide.

---

# PHASE 40 — HUD

## M78 — HUD principal

Afficher :

* [ ] nom ;
* [ ] niveau ;
* [ ] HP ;
* [ ] XP ;
* [ ] or.

---

## M79 — Barre XP

Afficher progression vers niveau suivant.

---

# PHASE 41 — Inventaire minimal

## M80 — Architecture inventaire

Créer :

```text
Item
CharacterItem
```

---

## M81 — Interface inventaire

Créer une grille simple.

Aucun système complexe nécessaire.

---

# PHASE 42 — Déconnexions

## M82 — Déconnexion monde

Lorsqu'un socket disparaît :

* [ ] attendre délai court ;
* [ ] retirer joueur ;
* [ ] informer autres joueurs.

---

## M83 — Déconnexion combat

Politique MVP :

```text
30 secondes pour revenir
```

Sinon :

```text
abandon
```

---

# PHASE 43 — Sécurité

## M84 — Validation payloads

Tous les événements réseau doivent utiliser des DTO ou schémas de validation.

---

## M85 — Rate limiting

Ajouter au minimum :

* [ ] login ;
* [ ] register ;
* [ ] chat ;
* [ ] événements abusables.

---

## M86 — Secrets

Vérifier :

* [ ] aucun mot de passe ;
* [ ] aucun token ;
* [ ] aucune clé API ;
* [ ] `.env` ignoré ;
* [ ] `.env.example` présent.

---

# PHASE 44 — Logs

## M87 — Logger structuré

Logger :

```text
playerConnected
playerDisconnected
mapChanged
combatStarted
combatEnded
levelUp
serverError
```

---

# PHASE 45 — Tests combat

## M88 — Tests règles principales

Créer tests :

* [ ] impossible jouer hors tour ;
* [ ] impossible attaquer sans PA ;
* [ ] impossible avancer sans PM ;
* [ ] impossible attaquer hors portée ;
* [ ] obstacle bloque déplacement ;
* [ ] ligne de vue ;
* [ ] mort ;
* [ ] victoire ;
* [ ] défaite.

---

# PHASE 46 — Tests monde

## M89 — Tests monde

Tester :

* [ ] déplacement autorisé ;
* [ ] déplacement interdit ;
* [ ] transition map valide ;
* [ ] transition invalide ;
* [ ] monstre déjà en combat ;
* [ ] joueur déjà en combat.

---

# PHASE 47 — Tests authentification

## M90 — Tests auth

Tester :

* [ ] register ;
* [ ] login ;
* [ ] mauvais mot de passe ;
* [ ] utilisateur inexistant ;
* [ ] session ;
* [ ] logout.

---

# PHASE 48 — Qualité

## M91 — Lint global

La commande :

```bash
pnpm lint
```

doit fonctionner sans erreur.

---

## M92 — Tests globaux

```bash
pnpm test
```

doit fonctionner.

---

## M93 — Build global

```bash
pnpm build
```

doit réussir frontend et backend.

---

# PHASE 49 — README

## M94 — Documentation

Documenter :

* [ ] prérequis ;
* [ ] installation ;
* [ ] `.env` ;
* [ ] PostgreSQL ;
* [ ] Docker ;
* [ ] Prisma ;
* [ ] migrations ;
* [ ] démarrage ;
* [ ] tests ;
* [ ] architecture.

Objectif :

un nouveau développeur doit pouvoir lancer le projet sans connaissance préalable.

---

# PHASE 50 — Amélioration graphique

## M95 — Remplacer placeholders

Une fois seulement le gameplay stable :

* [ ] décor Village ;
* [ ] décor Prairie ;
* [ ] décor Forêt ;
* [ ] décor Ruines ;
* [ ] héros ;
* [ ] Gelée ;
* [ ] Sanglier ;
* [ ] Gardien.

---

## M96 — Animations

Ajouter progressivement :

* [ ] idle ;
* [ ] walk ;
* [ ] attack ;
* [ ] damage ;
* [ ] death.

---

# PHASE 51 — Audio

## M97 — Sons

Ajouter :

* [ ] clic UI ;
* [ ] déplacement ;
* [ ] attaque épée ;
* [ ] boule de feu ;
* [ ] soin ;
* [ ] victoire ;
* [ ] level-up.

---

# PHASE 52 — Polish

## M98 — Transitions

Ajouter :

* [ ] transition changement de map ;
* [ ] transition combat ;
* [ ] retour monde ;
* [ ] animations fenêtres.

---

## M99 — Feedback utilisateur

Vérifier que chaque action donne un retour clair.

Exemples :

* [ ] destination inaccessible ;
* [ ] pas assez de PA ;
* [ ] pas assez de PM ;
* [ ] hors portée ;
* [ ] mauvais tour ;
* [ ] monstre déjà attaqué.

---

# PHASE 53 — Test MVP complet

## M100 — Test final

Faire ce test manuellement avec deux navigateurs.

### Compte A

* [ ] créer compte ;
* [ ] créer personnage ;
* [ ] entrer Village.

### Compte B

* [ ] créer compte ;
* [ ] créer personnage ;
* [ ] entrer Village.

### Multijoueur

* [ ] A voit B.
* [ ] B voit A.
* [ ] déplacements synchronisés.

### Exploration

* [ ] quitter Village ;
* [ ] entrer Prairie ;
* [ ] entrer Forêt ;
* [ ] entrer Ruines ;
* [ ] revenir Village.

### Monstres

* [ ] monstres identiques pour les joueurs ;
* [ ] spawn correct ;
* [ ] respawn correct.

### Combat

* [ ] lancer combat ;
* [ ] déplacement ;
* [ ] PA ;
* [ ] PM ;
* [ ] attaque épée ;
* [ ] feu ;
* [ ] soin ;
* [ ] IA ;
* [ ] timer ;
* [ ] victoire.

### Progression

* [ ] XP gagnée ;
* [ ] or gagné ;
* [ ] niveau gagné ;
* [ ] statistiques modifiées.

### Persistance

* [ ] déconnexion ;
* [ ] reconnexion ;
* [ ] données conservées.

---

# MVP VALIDÉ

Le MVP est terminé lorsque toutes les tâches obligatoires de `M00` à `M100` nécessaires au scénario final sont fonctionnelles.

À ce moment-là :

**NE PAS commencer immédiatement à ajouter énormément de contenu.**

Faire d'abord :

* [ ] audit architecture ;
* [ ] audit sécurité ;
* [ ] audit performances ;
* [ ] audit duplication de code ;
* [ ] audit tests ;
* [ ] suppression du code temporaire inutile ;
* [ ] correction des bugs connus.

---

# APRÈS MVP

Ces fonctionnalités sont volontairement repoussées.

## V2 — Multijoueur en combat

* [ ] groupe de joueurs ;
* [ ] invitation ;
* [ ] 2 joueurs contre monstres ;
* [ ] synchronisation tours ;
* [ ] abandon individuel ;
* [ ] récompenses partagées.

---

## V2 — Classes

* [ ] Guerrier ;
* [ ] Mage ;
* [ ] Archer.

---

## V2 — Équipement

* [ ] armes ;
* [ ] armures ;
* [ ] statistiques ;
* [ ] équipement personnage.

---

## V2 — Loot

* [ ] drops ;
* [ ] ressources ;
* [ ] rareté.

---

## V2 — Quêtes

* [ ] PNJ ;
* [ ] dialogues ;
* [ ] objectifs ;
* [ ] récompenses.

---

## V2 — Donjon

* [ ] plusieurs salles ;
* [ ] combats successifs ;
* [ ] boss.

---

# EN COURS

Aucune tâche pour le moment.

---

# BLOQUANTS

Aucun blocage connu pour le moment.

---

# PROBLÈMES CONNUS

* La politique d'exécution PowerShell de cette machine bloque le shim
  `pnpm.ps1`. Utiliser `pnpm.cmd` dans PowerShell ; les scripts internes pnpm
  fonctionnent normalement.

---

# IDÉES FUTURES

À ne pas implémenter avant la fin du MVP :

* PvP ;
* guildes ;
* groupes ;
* métiers ;
* craft ;
* hôtel des ventes ;
* échanges ;
* familiers ;
* montures ;
* donjons multiples ;
* succès ;
* quêtes narratives ;
* plusieurs personnages par compte ;
* classes supplémentaires ;
* skins ;
* émotes ;
* liste d'amis ;
* messages privés ;
* classement ;
* boss mondiaux.

---

# Instruction finale pour Codex

Lorsque tu termines une tâche :

1. coche-la dans ce fichier ;
2. indique brièvement ce qui a été réalisé ;
3. indique les fichiers principaux modifiés ;
4. lance les tests concernés ;
5. lance le lint si pertinent ;
6. lance le build si pertinent ;
7. corrige les erreurs avant de passer à la suite ;
8. choisis ensuite la prochaine tâche non cochée dans l'ordre.

Ne saute pas directement à une fonctionnalité plus spectaculaire simplement parce qu'elle est plus intéressante.

**La priorité est d'obtenir un jeu petit, propre, stable et entièrement jouable.**
