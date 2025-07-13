# Pomodoro App 🕒

Une application Pomodoro simple et efficace développée avec **Flutter**, dans le cadre du module **Développement Desktop** à **Ynov Aix Campus**.

---

## ✨ Fonctionnalités

- ⏱️ Sessions Pomodoro personnalisables (travail, pause courte, pause longue)
- 📊 Historique des sessions
- ⚙️ Paramètres configurables
- 🔐 Authentification avec [Supabase](https://supabase.com/)
- 💻 Compilation possible en `.exe` pour Windows

---

## 🧱 Structure du projet

```
lib/
├── assets/
│   └── sounds/
├── main.dart
├── models/
│   ├── pomodoro_session_record.dart
│   └── pomodoro_timer.dart
├── services/
│   └── supabase_service.dart
├── viewmodels/
│   └── pomodoro_viewmodel.dart
└── views/
    ├── history_page.dart
    ├── home_page.dart
    ├── login_page.dart
    ├── register_page.dart
    └── settings_page.dart
```

---

## 🚀 Lancer le projet en local

### Prérequis

- Flutter installé (`flutter doctor` pour vérifier)
- Un projet [Supabase](https://supabase.com/) avec l'authentification activée

### Installation

1. **Cloner le repo** :
   ```bash
   git clone https://github.com/HugoGarrigues/pomodoro_app.git
   cd pomodoro_app
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Lancer l'app sur Windows** :
   ```bash
   flutter run -d windows
   ```

---

## 🔐 Supabase Auth

- Authentification par email / mot de passe
- Gestion des sessions utilisateur
- Connexion automatique si une session est active
- Déconnexion manuelle via un bouton dédié

---

## 🐛 Problèmes rencontrés

- Utilisation de **WSL** pour le dev sous Linux, mais les **plugins audio/notifications** n’étaient pas compatibles
- Plusieurs difficultés liées aux **builds Windows** (chemins, librairies manquantes, droits d’accès…)

---

## 🙌 Auteur

- Hugo Garrigues  
- GitHub : [@HugoGarrigues](https://github.com/HugoGarrigues)
