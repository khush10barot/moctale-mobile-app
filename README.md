# MocTale 🎬

A Flutter mobile app that lets users search for movies, save them to a 
personal watchlist, rate and review films, and find nearby cinemas.

## Features
- 🔍 Search 1M+ movies in real-time via TMDB REST API
- 📋 Personal watchlist with persistent SQLite storage
- ⭐ Rate movies (1–5 stars) and write personal reviews
- 🗺️ Find nearby cinemas via Google Maps with interactive markers
- 📱 5-screen Android app (Splash, Watchlist, Search, Movie Details, Map)

## Tech Stack
- Dart & Flutter
- SQLite (sqflite) — local persistent storage
- TMDB REST API — movie data
- Google Maps Flutter SDK — nearby cinemas

## Setup & Installation
1. Clone the repository
   git clone https://github.com/khush10barot/moctale-mobile-app.git
2. Navigate to project folder
   cd moctale
3. Install dependencies
   flutter pub get
4. Add your TMDB API key in the config file
5. Run the app
   flutter run
