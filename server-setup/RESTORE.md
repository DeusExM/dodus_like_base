# Restauration complète d'un nouveau VPS

Ce document complète les scripts d'installation.

## 1. Installation système

Depuis le dépôt :

sudo bash server-setup/setup-agent-vps.sh

Puis ouvrir une session avec l'utilisateur agent et lancer :

bash server-setup/setup-agent-user.sh

## 2. Installer Tailscale

Commande officielle Linux :

curl -fsSL https://tailscale.com/install.sh | sh

Puis connecter le nouveau VPS au tailnet :

sudo tailscale up

Cette commande affiche une URL d'authentification à ouvrir dans le navigateur.

## 3. Utiliser le NAS comme exit node

Une fois le nouveau VPS présent dans Tailscale, récupérer l'adresse Tailscale actuelle du NAS puis lancer :

sudo tailscale set --exit-node=IP_TAILSCALE_DU_NAS

Sur l'installation actuelle, le NAS était utilisé comme exit node afin que certains services IA voient l'IP Internet de la maison.

Ne pas recopier aveuglément une ancienne IP Tailscale : vérifier d'abord les adresses actuelles.

## 4. Accès SSH

Les clés privées ne sont PAS sauvegardées dans Git.

À restaurer séparément :

~/.ssh/

Puis vérifier les permissions :

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config 2>/dev/null || true
chmod 600 ~/.ssh/* 2>/dev/null || true
chmod 644 ~/.ssh/*.pub 2>/dev/null || true

Tester ensuite chaque dépôt GitHub avec son alias SSH.

Exemple :

ssh -T github.com

ou avec un alias configuré :

ssh -T github-muse
ssh -T github-dodus-base

## 5. OpenCode

OpenCode est installé pour l'utilisateur agent par setup-agent-user.sh.

Vérification :

opencode --version

Les projets pouvant fonctionner en mode autonome peuvent contenir :

opencode.json

avec :

{
  "$schema": "https://opencode.ai/config.json",
  "permission": "allow"
}

Lancement autonome :

opencode --auto

Les sessions et données locales OpenCode sont normalement sous :

~/.local/share/opencode/

Les clés/API doivent être restaurées séparément et ne doivent jamais être committées.

## 6. Antigravity / AGY

Les identifiants OAuth Antigravity ne doivent jamais être mis dans Git.

Emplacement utilisé sur l'ancien VPS :

~/.gemini/antigravity-cli/

Après réinstallation d'AGY, reconnecter le compte ou restaurer les fichiers d'authentification depuis une sauvegarde privée.

Vérification :

agy --version

Ne pas copier les tokens dans ce dépôt.

## 7. Docker

Vérifier :

docker --version
docker compose version
docker ps

Si l'utilisateur agent vient juste d'être ajouté au groupe docker, se déconnecter puis se reconnecter avant de tester.

## 8. PostgreSQL de projet

Les projets peuvent lancer PostgreSQL via Docker Compose.

Exemple :

docker compose up -d

Les mots de passe et fichiers .env ne doivent pas être stockés dans cette branche publique.

## 9. tmux

Sessions longues :

tmux new -s muse

Détacher :

Ctrl+B puis D

Reprendre :

tmux attach -t muse

Lister :

tmux ls

## 10. Vérification finale

Lancer :

bash server-setup/verify-install.sh

Puis vérifier manuellement :

opencode --version
agy --version
tailscale status
docker ps
