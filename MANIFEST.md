# MANIFEST.md — Mini jeu tactique multijoueur navigateur

## 1. Objectif du projet

Créer un **mini jeu RPG tactique multijoueur jouable directement depuis un navigateur**, inspiré dans ses grands principes par les MMORPG tactiques comme Dofus :

* univers fantasy coloré ;
* vue 2D/isométrique ;
* déplacement à la souris ;
* plusieurs cartes reliées entre elles ;
* monstres visibles directement dans le monde ;
* possibilité de cliquer sur un monstre pour lancer un combat ;
* combats tactiques au tour par tour sur une grille ;
* personnages persistants ;
* comptes utilisateurs ;
* plusieurs joueurs connectés simultanément ;
* progression avec niveaux, caractéristiques et compétences.

Le but n'est PAS de recréer Dofus à l'identique.

Le projet doit avoir :

* son propre univers ;
* ses propres monstres ;
* ses propres cartes ;
* ses propres interfaces ;
* ses propres illustrations ;
* ses propres sorts ;
* ses propres noms.

La direction artistique peut reprendre les grands codes d'un **RPG fantasy tactique 2D isométrique coloré**, mais aucun asset, personnage, interface, nom ou contenu provenant de Dofus ne doit être copié.

---

# 2. Philosophie du projet

Le projet est volontairement petit.

Le premier objectif n'est PAS de créer un MMORPG complet.

Le premier objectif est de créer une boucle de gameplay entièrement fonctionnelle :

**Créer un compte → créer un personnage → entrer dans le monde → changer de carte → trouver un monstre → lancer un combat → gagner → obtenir XP/or → continuer à jouer.**

Cette boucle doit fonctionner parfaitement avant d'ajouter davantage de contenu.

---

# 3. Stack technique recommandée

## Frontend

Utiliser :

* TypeScript
* React
* Vite
* Phaser 3
* Socket.IO Client

Responsabilités :

### React

React gère principalement :

* connexion ;
* inscription ;
* sélection du personnage ;
* HUD ;
* inventaire ;
* fiche personnage ;
* sorts ;
* fenêtres ;
* chat ;
* menus.

### Phaser

Phaser gère :

* affichage du monde ;
* cartes ;
* sprites ;
* déplacements ;
* caméra ;
* grille ;
* monstres ;
* autres joueurs ;
* animations ;
* combats.

React et Phaser doivent communiquer par un système simple d'événements ou un store partagé.

---

# 4. Backend

Utiliser :

* Node.js
* TypeScript
* NestJS
* Socket.IO
* Prisma
* PostgreSQL

Le backend doit être **autoritaire**.

Le client ne doit jamais pouvoir décider lui-même :

* de sa position réelle ;
* de ses points de vie ;
* des dégâts infligés ;
* de son XP ;
* de son or ;
* de son niveau ;
* de son inventaire ;
* de la mort d'un monstre ;
* de la réussite d'un sort ;
* de la fin d'un combat.

Le navigateur envoie une intention.

Exemple :

`PLAYER_MOVE_REQUEST`

et non :

`PLAYER_POSITION = X,Y`

Le serveur valide l'action puis envoie le nouvel état aux clients.

---

# 5. Organisation du repository

Utiliser un monorepo.

Structure recommandée :

```text
/
├── apps/
│   ├── web/
│   │   ├── src/
│   │   │   ├── game/
│   │   │   ├── components/
│   │   │   ├── pages/
│   │   │   ├── stores/
│   │   │   └── services/
│   │
│   └── server/
│       ├── src/
│       │   ├── auth/
│       │   ├── users/
│       │   ├── characters/
│       │   ├── world/
│       │   ├── monsters/
│       │   ├── combat/
│       │   ├── spells/
│       │   └── websocket/
│
├── packages/
│   └── shared/
│       ├── types/
│       ├── events/
│       ├── constants/
│       └── game-rules/
│
├── assets/
│
├── docs/
│
├── docker-compose.yml
├── README.md
└── MANIFEST.md
```

Les types utilisés par le client et le serveur doivent autant que possible se trouver dans `packages/shared`.

---

# 6. Comptes utilisateurs

Le joueur doit pouvoir :

* créer un compte ;
* se connecter ;
* se déconnecter ;
* rester connecté après rafraîchissement de la page.

Informations minimum :

* email ;
* pseudo de compte ;
* mot de passe ;
* date de création.

Le mot de passe doit être hashé avec Argon2 ou bcrypt.

Ne jamais stocker un mot de passe en clair.

Authentification :

* cookie sécurisé HTTP-only recommandé ;
* session ou JWT sécurisé.

---

# 7. Personnage

Après création du compte, permettre la création d'un personnage.

Pour le MVP, un compte peut posséder **un seul personnage**.

Informations :

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
```

Valeurs de départ proposées :

```text
Niveau : 1
PV : 50
PA : 6
PM : 3
Force : 10
Intelligence : 10
Or : 0
```

---

# 8. Monde

Le monde contient exactement **4 cartes pour le MVP**.

Chaque carte correspond à un écran.

Il n'est pas nécessaire de créer un gigantesque monde avec scrolling continu.

Exemple :

```text
              [Forêt]

                 |
                 |

[Prairie] — [Village] — [Ruines]
```

---

# 9. Les quatre cartes

## MAP 01 — Village

Zone de départ.

Contient :

* point d'apparition du joueur ;
* quelques bâtiments décoratifs ;
* PNJ décoratifs ;
* sortie vers Prairie ;
* sortie vers Ruines ;
* sortie vers Forêt.

Pas de monstre agressif.

---

## MAP 02 — Prairie

Ambiance :

* herbe ;
* fleurs ;
* petites pierres ;
* arbres.

Monstres :

### Gelée des prés

Niveau 1.

```text
PV : 30
PA : 6
PM : 3
```

Attaque :

`Bond gélatineux`

Portée : 1

Dégâts : 6-9.

---

## MAP 03 — Forêt

Ambiance :

* arbres ;
* champignons ;
* racines ;
* végétation dense.

Monstres :

### Sanglier des bois

Niveau 2.

```text
PV : 50
PA : 6
PM : 4
```

Attaque :

`Charge sauvage`

Dégâts : 8-12.

---

## MAP 04 — Ruines

Zone légèrement plus difficile.

Monstres :

### Gardien de pierre

Niveau 3.

```text
PV : 80
PA : 6
PM : 2
```

Attaque :

`Poing de granit`

Dégâts : 10-15.

Possibilité d'avoir occasionnellement un monstre plus puissant :

### Ancien gardien

Niveau 5.

PV : environ 150.

Il joue le rôle de mini-boss du prototype.

---

# 10. Déplacement dans le monde

Le déplacement doit se faire à la souris.

Le joueur clique sur une case.

Le personnage se déplace jusqu'à cette case.

Implémenter une grille logique invisible.

Exemple :

```text
20 × 14 cases
```

Chaque case possède au minimum :

```typescript
{
    x: number;
    y: number;
    walkable: boolean;
}
```

Certaines cases sont bloquées :

* arbres ;
* bâtiments ;
* rochers ;
* eau ;
* décor.

Utiliser un algorithme A* pour trouver le chemin.

Le serveur valide la destination.

---

# 11. Direction graphique

Rechercher un aspect :

* fantasy ;
* chaleureux ;
* coloré ;
* légèrement cartoon ;
* peinture numérique ;
* vue isométrique ou pseudo-isométrique ;
* décors ressemblant à des illustrations peintes ;
* personnages avec des proportions légèrement exagérées.

La lisibilité doit être plus importante que le réalisme.

Résolution artistique recommandée :

* décors 2D ;
* personnages sous forme de sprites ;
* plusieurs orientations ;
* petites animations simples.

Pour le prototype, les animations peuvent être limitées à :

* idle ;
* marche ;
* attaque ;
* dégâts ;
* mort.

Il est acceptable d'utiliser temporairement des placeholders pendant le développement.

---

# 12. Joueurs en ligne

Lorsqu'un joueur arrive sur une carte :

le serveur doit l'inscrire dans une **room Socket.IO correspondant à la carte**.

Exemple :

```text
map:forest
```

Tous les joueurs présents sur cette carte reçoivent :

* arrivée du joueur ;
* départ du joueur ;
* déplacement ;
* changement d'apparence éventuel.

Chaque joueur doit voir les autres personnages connectés sur la même carte.

Le client ne doit pas recevoir inutilement les déplacements des joueurs présents sur les autres cartes.

---

# 13. Monstres dans le monde

Les monstres doivent être visibles directement sur les cartes.

Ils doivent être gérés par le serveur.

Chaque monstre possède :

```text
id
monsterType
level
mapId
x
y
state
```

États possibles :

```text
IDLE
IN_COMBAT
DEAD
RESPAWNING
```

Pour le MVP, les monstres peuvent :

* rester immobiles ;
* ou se déplacer aléatoirement toutes les quelques secondes.

Le déplacement avancé n'est pas prioritaire.

---

# 14. Respawn

Lorsqu'un monstre meurt :

1. il disparaît ;
2. le serveur démarre un timer ;
3. après environ 20 à 60 secondes ;
4. un nouveau monstre du même type apparaît.

Le temps peut être aléatoire.

---

# 15. Lancement d'un combat

Le joueur clique sur un monstre.

Le client envoie :

```text
COMBAT_REQUEST
```

avec l'identifiant du monstre.

Le serveur vérifie :

* que le joueur existe ;
* qu'il est connecté ;
* qu'il n'est pas déjà en combat ;
* que le monstre existe ;
* que le monstre n'est pas déjà en combat ;
* que le joueur est suffisamment proche.

Si tout est valide :

création d'une instance de combat.

---

# 16. Combat

Les combats sont séparés du monde normal.

Créer un objet :

```typescript
CombatInstance
```

contenant :

```text
id
mapId
players
monsters
turnOrder
currentTurn
turnNumber
state
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

# 17. Grille de combat

Le combat se déroule sur une grille carrée.

Exemple :

```text
12 × 10
```

Certaines cases peuvent être bloquées.

Exemple :

```text
. . . X . .
. . . X . .
P . . . . M
. . X . . .
```

`P` = joueur.

`M` = monstre.

`X` = obstacle.

---

# 18. Placement initial

Le serveur définit les cases de départ.

Exemple :

joueur à gauche.

monstres à droite.

Une très courte phase de préparation peut être ajoutée.

Pour le premier prototype, il est également acceptable de commencer immédiatement le combat.

---

# 19. Initiative

Chaque combattant possède une initiative.

Le serveur calcule :

```text
player
monster1
monster2
player
...
```

Afficher la timeline des tours à l'écran.

---

# 20. Tour de jeu

Chaque tour dispose d'un maximum de :

**30 secondes.**

Au début du tour :

```text
PA = PA maximum
PM = PM maximum
```

Le joueur peut :

* se déplacer ;
* lancer plusieurs sorts ;
* passer son tour.

Lorsque :

* il clique sur « Fin du tour » ;
* ou le timer atteint zéro ;

le serveur passe au combattant suivant.

---

# 21. Points de mouvement

Le personnage possède par exemple :

```text
3 PM
```

Déplacer le personnage d'une case coûte :

```text
1 PM
```

Le serveur doit calculer la distance et vérifier le chemin.

---

# 22. Points d'action

Le joueur possède :

```text
6 PA
```

Chaque sort coûte des PA.

Exemple :

```text
Coup d'épée : 3 PA
Boule de feu : 4 PA
```

Le joueur peut donc utiliser plusieurs actions pendant un même tour tant qu'il possède suffisamment de PA.

---

# 23. Sorts du joueur

Créer uniquement trois capacités pour commencer.

## Coup d'épée

```text
Coût : 3 PA
Portée : 1
Dégâts : 8-12
```

Dégâts principalement influencés par Force.

---

## Boule de feu

```text
Coût : 4 PA
Portée : 2-5
Dégâts : 7-11
```

Dégâts principalement influencés par Intelligence.

La ligne de vue doit être vérifiée.

---

## Soin mineur

```text
Coût : 3 PA
Portée : 0-3
Soin : 6-10
```

Permet au joueur de se soigner lui-même.

---

# 24. Calcul des dégâts

Conserver une formule volontairement simple.

Exemple :

```typescript
damage =
baseDamage *
(1 + relevantStat / 100);
```

Puis appliquer une petite variation aléatoire.

Toute la formule doit être calculée côté serveur.

---

# 25. IA des monstres

L'IA doit rester simple.

Pendant son tour :

1. trouver le joueur le plus proche ;
2. vérifier si une attaque est possible ;
3. attaquer si possible ;
4. sinon se rapprocher ;
5. si l'attaque devient possible après déplacement, attaquer ;
6. terminer son tour.

Utiliser un pathfinding sur la grille.

Ne pas créer d'intelligence artificielle complexe.

---

# 26. Mort

Lorsque :

```text
HP <= 0
```

le combattant est mort.

Il ne peut plus jouer.

Quand tous les monstres sont morts :

```text
VICTORY
```

Quand tous les joueurs sont morts :

```text
DEFEAT
```

---

# 27. Victoire

Afficher une fenêtre de résultat.

Exemple :

```text
VICTOIRE

XP gagnée : 35
Or gagné : 12
Monstres vaincus : 2
```

Après validation :

retour sur la carte du monde.

---

# 28. Défaite

En cas de défaite :

* ne pas supprimer le personnage ;
* restaurer partiellement ou totalement ses PV ;
* téléporter le joueur au Village.

Aucune mécanique punitive importante pour le MVP.

---

# 29. XP

Chaque monstre donne de l'XP.

Exemple :

```text
Gelée : 20 XP
Sanglier : 35 XP
Gardien : 60 XP
Ancien Gardien : 150 XP
```

Progression simple :

```text
Niveau 1 → 2 : 100 XP
Niveau 2 → 3 : 250 XP
Niveau 3 → 4 : 500 XP
Niveau 4 → 5 : 900 XP
```

---

# 30. Level-up

Lors d'un niveau :

augmenter par exemple :

```text
+10 PV maximum
+2 Force
+2 Intelligence
```

Afficher :

```text
NIVEAU SUPÉRIEUR !
```

avec un petit effet visuel.

Le serveur sauvegarde immédiatement le nouveau niveau.

---

# 31. Or

Les monstres donnent une petite quantité d'or.

Pour cette première version, l'or peut simplement être stocké.

Il n'est PAS nécessaire de développer immédiatement :

* magasins ;
* économie ;
* hôtel des ventes ;
* échanges.

---

# 32. Inventaire

Créer l'architecture d'un inventaire mais limiter fortement son utilisation dans le MVP.

Interface :

```text
Inventaire
[ ][ ][ ][ ]
[ ][ ][ ][ ]
[ ][ ][ ][ ]
```

Prévoir la structure de données permettant ultérieurement :

* équipements ;
* ressources ;
* consommables.

Mais ne pas perdre de temps à créer des centaines d'objets.

---

# 33. Interface du monde

L'écran principal doit ressembler approximativement à :

```text
┌──────────────────────────────────────────────────┐
│                                                  │
│                                                  │
│                  CARTE DU JEU                    │
│                                                  │
│        joueur        monstre                     │
│                                                  │
│                                                  │
├──────────────────────────────────────────────────┤
│ LVL 3     ❤️ 72/80     XP █████░░       125 or   │
│                                                  │
│ [Perso] [Sorts] [Inventaire]            [Chat]   │
└──────────────────────────────────────────────────┘
```

---

# 34. Interface du combat

Afficher clairement :

* grille ;
* combattants ;
* PV ;
* PA ;
* PM ;
* sorts ;
* tour actuel ;
* ordre des prochains tours ;
* timer ;
* bouton Fin du tour.

Exemple :

```text
Combat

Tour : Arkan
Temps : 23 sec

PA : ●●●●●●
PM : ●●●

[Épée 3PA]
[Feu 4PA]
[Soin 3PA]

              [FIN DU TOUR]
```

---

# 35. Survol des cases

Pendant le combat :

survoler une case doit pouvoir afficher :

* chemin prévu ;
* coût en PM.

Lorsqu'un sort est sélectionné :

mettre en évidence :

* cases à portée ;
* cases non accessibles ;
* cible sélectionnable.

---

# 36. Feedback visuel

Une attaque doit générer un feedback.

Exemple :

```text
-12
```

au-dessus de la cible.

Un soin :

```text
+8
```

Afficher également :

* animation ;
* flash ;
* petite vibration de sprite ;
* son simple.

Même avec des placeholders, le combat doit donner une impression de réponse immédiate.

---

# 37. Chat

Créer un petit chat global par carte.

Fonctionnalités :

* envoyer un message ;
* recevoir les messages ;
* afficher le pseudo du joueur.

Exemple :

```text
Arkan : Salut !
Meridia : Je vais dans la forêt.
```

Limiter la longueur des messages.

Prévoir un rate-limit anti-spam.

---

# 38. Changement de carte

Chaque carte possède des zones de sortie.

Exemple :

```text
FOREST_EXIT
VILLAGE_EXIT
```

Lorsque le joueur atteint une sortie :

le client envoie une demande.

Le serveur :

1. valide la sortie ;
2. change `mapId` ;
3. retire le joueur de l'ancienne room Socket.IO ;
4. ajoute le joueur dans la nouvelle ;
5. envoie les données de la nouvelle carte.

---

# 39. Sauvegarde

Sauvegarder au minimum :

* carte ;
* position ;
* PV ;
* niveau ;
* XP ;
* or ;
* caractéristiques.

La déconnexion puis reconnexion doit ramener le joueur dans le même état cohérent.

Exception :

si le joueur s'est déconnecté pendant un combat, il peut être replacé au Village pour simplifier le MVP.

---

# 40. Base de données

Tables principales proposées :

```text
User
Character
Item
CharacterItem
MonsterTemplate
Spell
```

Les monstres actuellement présents dans le monde peuvent être gérés en mémoire par le GameServer.

Ils n'ont pas forcément besoin d'être persistés individuellement.

---

# 41. Architecture réseau

Deux types de communication.

## HTTP REST

Utilisé pour :

```text
POST /auth/register
POST /auth/login
POST /auth/logout

GET /characters
POST /characters
GET /characters/:id
```

---

## WebSocket

Utilisé pour le jeu temps réel.

Exemples d'événements :

```text
WORLD_JOIN
WORLD_STATE

PLAYER_JOINED
PLAYER_LEFT

PLAYER_MOVE_REQUEST
PLAYER_MOVED

MAP_CHANGE_REQUEST
MAP_CHANGED

MONSTER_SPAWNED
MONSTER_MOVED
MONSTER_REMOVED

COMBAT_REQUEST
COMBAT_STARTED

COMBAT_MOVE_REQUEST
COMBAT_CAST_REQUEST
COMBAT_END_TURN

COMBAT_STATE
COMBAT_FINISHED

CHAT_SEND
CHAT_MESSAGE
```

Définir les événements dans :

```text
packages/shared/events
```

afin que client et serveur utilisent exactement les mêmes contrats.

---

# 42. Règle fondamentale réseau

Toutes les actions critiques passent par :

```text
CLIENT REQUEST
      ↓
SERVER VALIDATION
      ↓
SERVER STATE UPDATE
      ↓
SERVER BROADCAST
      ↓
CLIENT RENDER
```

Ne jamais faire :

```text
CLIENT MODIFIES STATE
      ↓
SERVER TRUSTS CLIENT
```

---

# 43. Gestion des déconnexions

Si un joueur ferme son navigateur :

* retirer le joueur de la carte après quelques secondes ;
* informer les autres joueurs ;
* conserver les données persistantes.

En combat :

pour le MVP :

* attendre environ 30 secondes ;
* si aucune reconnexion ;
* considérer le joueur comme ayant abandonné.

---

# 44. Sécurité minimale

Mettre en place :

* validation serveur de toutes les entrées ;
* protection contre injection SQL via Prisma ;
* hash des mots de passe ;
* rate limiting login ;
* rate limiting chat ;
* protection XSS ;
* validation des payloads WebSocket ;
* aucun secret dans le repository ;
* variables dans `.env`.

Créer :

```text
.env.example
```

sans credentials réels.

---

# 45. Gestion des erreurs

Ne jamais laisser une erreur serveur faire planter le GameServer entier.

Logger au minimum :

```text
playerConnected
playerDisconnected
mapChanged
combatStarted
combatEnded
levelUp
serverError
```

Créer un logger structuré.

---

# 46. Tests

Créer des tests principalement sur les règles du jeu.

Tester notamment :

### Combat

* impossible d'attaquer sans PA ;
* impossible de marcher sans PM ;
* impossible de jouer pendant le tour adverse ;
* impossible d'attaquer hors portée ;
* impossible de traverser un obstacle ;
* mort à 0 PV ;
* victoire lorsque tous les ennemis sont morts.

### Monde

* changement de carte valide ;
* changement de carte invalide ;
* déplacement sur case interdite ;
* lancement de combat avec un monstre déjà occupé.

### Compte

* création ;
* connexion ;
* mauvais mot de passe ;
* sauvegarde personnage.

---

# 47. Assets temporaires

Ne pas bloquer le développement sur les graphismes.

Commencer avec :

* formes ;
* carrés ;
* sprites placeholders ;
* images libres ou générées spécifiquement pour le projet.

Le code et le gameplay doivent fonctionner indépendamment des assets définitifs.

Les assets doivent être remplaçables facilement.

---

# 48. Ordre de développement

Le développement doit impérativement suivre cet ordre.

## PHASE 1 — Infrastructure

Créer :

* monorepo ;
* frontend ;
* backend ;
* PostgreSQL ;
* Prisma ;
* Docker Compose ;
* shared package.

Résultat :

frontend et serveur démarrent correctement.

---

## PHASE 2 — Authentification

Créer :

* inscription ;
* connexion ;
* logout ;
* personnage.

Résultat :

un utilisateur peut créer son compte et son personnage.

---

## PHASE 3 — Première carte

Créer uniquement Village.

Ajouter :

* rendu Phaser ;
* personnage ;
* grille ;
* obstacles ;
* déplacement à la souris ;
* pathfinding.

Résultat :

le personnage peut se déplacer.

---

## PHASE 4 — Multijoueur

Ajouter Socket.IO.

Deux navigateurs connectés doivent pouvoir :

* entrer sur la même carte ;
* voir l'autre joueur ;
* observer ses déplacements ;
* voir sa déconnexion.

C'est une étape essentielle.

---

## PHASE 5 — Quatre cartes

Ajouter :

* Village ;
* Prairie ;
* Forêt ;
* Ruines.

Ajouter les transitions.

Résultat :

le joueur peut parcourir les quatre cartes.

---

## PHASE 6 — Monstres

Ajouter :

* spawn ;
* affichage ;
* respawn ;
* état serveur.

Résultat :

plusieurs joueurs voient exactement les mêmes monstres.

---

## PHASE 7 — Prototype combat

Créer :

* grille de combat ;
* joueur ;
* monstre ;
* tours ;
* PA ;
* PM ;
* déplacement ;
* attaque.

Commencer uniquement avec :

```text
1 joueur
vs
1 monstre
```

---

## PHASE 8 — Combat complet

Ajouter :

* plusieurs monstres ;
* trois sorts ;
* ligne de vue ;
* IA ;
* timer ;
* victoire ;
* défaite.

---

## PHASE 9 — Progression

Ajouter :

* XP ;
* niveaux ;
* or ;
* sauvegarde.

---

## PHASE 10 — Polish

Ajouter :

* animations ;
* feedback ;
* sons ;
* HUD ;
* transitions ;
* particules ;
* écran de victoire ;
* améliorations graphiques.

---

# 49. Ce qu'il NE faut PAS développer au début

Ne pas ajouter tant que le MVP n'est pas terminé :

* métiers ;
* crafting ;
* guildes ;
* hôtel des ventes ;
* PvP ;
* dizaines de classes ;
* centaines de sorts ;
* dizaines de cartes ;
* quêtes complexes ;
* montures ;
* familiers ;
* système économique ;
* marketplace ;
* donjons complexes ;
* équipements avec 50 statistiques ;
* matchmaking ;
* application mobile.

Ces fonctionnalités sont hors scope.

---

# 50. Définition du MVP terminé

Le MVP est considéré comme terminé uniquement lorsque le scénario suivant fonctionne.

## Test complet

### Étape 1

Un nouvel utilisateur ouvre :

```text
http://localhost:5173
```

### Étape 2

Il crée un compte.

### Étape 3

Il crée son personnage.

### Étape 4

Il apparaît dans Village.

### Étape 5

Un deuxième utilisateur se connecte dans un deuxième navigateur.

Les deux personnages se voient.

### Étape 6

Le premier joueur se déplace.

Le deuxième voit son déplacement.

### Étape 7

Le joueur quitte Village.

### Étape 8

Il arrive dans Prairie.

### Étape 9

Il voit plusieurs monstres.

### Étape 10

Il clique sur un monstre.

### Étape 11

Le combat démarre.

### Étape 12

Il peut :

* marcher ;
* utiliser ses sorts ;
* perdre des PA ;
* perdre des PM ;
* terminer son tour.

### Étape 13

Le monstre joue automatiquement.

### Étape 14

Le joueur tue le monstre.

### Étape 15

Une fenêtre affiche :

```text
Victoire
+ XP
+ Or
```

### Étape 16

Il retourne dans le monde.

### Étape 17

Son XP et son or ont réellement augmenté.

### Étape 18

Il se déconnecte.

### Étape 19

Il revient plus tard.

### Étape 20

Son personnage possède toujours :

* son niveau ;
* son XP ;
* son or ;
* ses statistiques.

Si tout ce scénario fonctionne, alors le **MVP 1 est terminé**.

---

# 51. Évolutions après MVP

Une fois seulement le MVP stable, envisager :

## Classes

Par exemple :

* Guerrier ;
* Mage ;
* Archer.

---

## Équipements

Ajouter :

* casque ;
* arme ;
* armure ;
* anneau.

---

## Loot

Les monstres pourraient donner :

* ressources ;
* équipements ;
* objets rares.

---

## Groupes

Permettre à plusieurs joueurs de rejoindre le même combat.

Première cible :

```text
2 joueurs
vs
1 à 4 monstres
```

---

## Quêtes

Ajouter quelques PNJ.

Exemple :

```text
Tue 5 Gelées des prés.
Récompense :
100 XP
50 pièces d'or
```

---

## Donjon

Créer une cinquième zone composée de plusieurs salles avec un boss final.

---

# 52. Contraintes pour Codex

Lorsque tu travailles sur ce projet :

1. Lis complètement `MANIFEST.md` avant toute modification importante.

2. Inspecte le code existant avant de créer une nouvelle architecture.

3. Ne remplace pas une fonctionnalité existante fonctionnelle sans raison.

4. Favorise du code simple et lisible.

5. TypeScript strict.

6. Éviter `any` sauf justification réelle.

7. Mutualiser les types client/serveur.

8. Ne jamais faire confiance au client pour les règles du jeu.

9. Ajouter des tests lorsqu'une nouvelle règle métier est introduite.

10. Après chaque grande étape :

* lancer les tests ;
* lancer le lint ;
* vérifier le build client ;
* vérifier le build serveur.

11. Corriger les erreurs avant de poursuivre.

12. Maintenir un fichier :

```text
A_FAIRE.md
```

avec :

```text
À faire
En cours
Terminé
Problèmes connus
Idées futures
```

13. Ne pas implémenter spontanément les fonctionnalités de la section « hors scope ».

14. Si une fonctionnalité peut être faite simplement ou avec une architecture extrêmement complexe, privilégier la solution simple tant qu'elle permet les évolutions prévues.

15. Le projet doit rester lançable localement avec le moins de commandes possible.

Objectif :

```bash
docker compose up -d
pnpm install
pnpm dev
```

16. Le README doit expliquer clairement :

* installation ;
* prérequis ;
* démarrage ;
* base de données ;
* migrations ;
* tests ;
* architecture.

---

# 53. Priorité absolue

La priorité n'est pas :

> avoir beaucoup de fonctionnalités.

La priorité est :

> avoir un petit jeu qui donne réellement l'impression de jouer à un RPG tactique en ligne.

Un jeu avec :

* quatre belles cartes ;
* trois monstres ;
* trois sorts ;
* cinq niveaux ;

mais extrêmement agréable à utiliser est préférable à un projet contenant 50 systèmes à moitié terminés.

Le cœur du projet est :

**exploration → rencontre → combat tactique → récompense → progression → nouvelle rencontre.**
