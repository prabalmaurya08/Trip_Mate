✈️ TripMate – Smart Trip Planner App
TripMate is a beautifully designed Flutter app to help friends and families collaboratively plan trips. From managing checklists to organizing daily itineraries with reminders, TripMate ensures a smooth and joyful travel experience.

🚀 Features
✅ Trip Dashboard
View progress of your checklist and see upcoming itinerary events at a glance.

📋 Checklist Manager
Add, check off, and manage tasks before and during your trip.

📅 Itinerary Planning
Create and organize daily events with time-based notifications.

🔔 Smart Notifications
Get reminded about your scheduled activities using local notifications.

🧠 Persistent Storage
All data is saved locally using Hive for fast, offline access.

⚙️ Clean Architecture
Uses Riverpod for state management, separating logic from UI.

🛠️ Tech Stack
Tech	Usage
Flutter	Cross-platform app framework
Riverpod	State management
Hive	Local NoSQL storage
Flutter Local Notifications	In-app reminders
Path Provider	To locate device directories
TimeZone	Schedule reminders in local time
📸 Screenshots
(Add your app screenshots here)

📦 Installation
Prerequisites:
Flutter SDK

Android Studio / Xcode

Steps:
bash
Copy
Edit
git clone https://github.com/your-username/tripmate.git
cd tripmate
flutter pub get
flutter run
Make sure you have an Android/iOS emulator or device connected.

📁 Folder Structure (Clean Architecture)
bash
Copy
Edit
lib/
├── app.dart
├── main.dart
├── features/
│   ├── checklist/
│   │   ├── data/            # Hive models and providers
│   │   └── presentation/    # UI screens
│   └── itinerary/
│       ├── data/
│       └── presentation/
📌 Roadmap
 Shared trip planning (multi-user)

 Trip budget tracking

 Map view for itinerary

 Trip themes and templates

👨‍💻 Author
Your Name
GitHub: prabalmaurya08
Feel free to contribute, raise issues, or suggest features!
