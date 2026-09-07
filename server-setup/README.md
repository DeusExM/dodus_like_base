# Reconstruction rapide du VPS agent

Cette branche sert à reconstruire rapidement un VPS Ubuntu pour le développement autonome.

Contenu :
- setup-agent-vps.sh : installation du système
- verify-install.sh : vérification des outils
- secrets.example.md : éléments sensibles à restaurer séparément

Sur un VPS Ubuntu neuf :
sudo bash server-setup/setup-agent-vps.sh

Puis :
bash server-setup/verify-install.sh

Ne jamais stocker dans Git :
- clés SSH
- tokens OpenRouter
- tokens OAuth
- fichiers .env
- mots de passe
