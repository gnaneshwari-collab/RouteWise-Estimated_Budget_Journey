# RouteWise - Travel-Friendly Journeys

> **An End-to-End Journey, Route, Timing & Total Trip Cost Estimation Platform**  
> *Powered by Python 3.11, Java 21 LTS, MySQL 8.0, and an Interactive Modern Web Dashboard.*

---

## 💡 The Core Problem Solved
Standard navigation tools like **Google Maps** and **Apple Maps** are pure navigation utilities: they show you directions from point A to B and traffic, but they do **NOT** calculate:
1. **Total Out-of-Pocket Trip Expenses**: How much you will actually spend on fuel, highway toll plazas, hotels, food, and entry tickets.
2. **Highway Toll Accumulation**: Real-time Fastag toll plazas calculation for both ways of the trip.
3. **Budget-Matched Dining & Pitstops**: Where to stop for clean restrooms and affordable food matching your per-person meal budget.
4. **Group-Scaled Hotel Accommodations**: Dynamic room calculation based on travelers count (e.g., 4 travelers = 2 rooms) and duration.
5. **Sightseeing Timings & Schedules**: Opening and closing hours of monuments so you don't arrive after closing.

**RouteWise** bridges all these gaps into one cohesive system.

---

## 🏗️ System Architecture (Python + Java + MySQL)

RouteWise uses a modern multi-tier microservices architecture:

```
                      ┌────────────────────────────────────────┐
                      │    RouteWise Frontend (Port 5173)      │
                      │  Interactive Leaflet Map, Asking Page, │
                      │  GPS Turn-by-Turn, Budget HUD, Booking │
                      └─────────────┬────────────────────┬─────┘
                                    │                    │
                          JSON REST │                    │ JSON REST
                                    ▼                    ▼
        ┌──────────────────────────────────┐   ┌──────────────────────────────────┐
        │  Java 21 Core Backend (Port 8080) │   │ Python Estimation Engine (5000)  │
        │  - User Auth & Session Tokens    │   │ - Fuel & Toll Calculations       │
        │  - Hotel & Transport Bookings    │   │ - Room Math & 10% Safety Buffer  │
        │  - Travel Voucher Generator      │   │ - Destination Weather Forecast   │
        └─────────────────┬────────────────┘   └─────────────────┬────────────────┘
                          │                                      │
                          │            JDBC / SQL Driver         │
                          └───────────────────┬──────────────────┘
                                              ▼
                              ┌────────────────────────────────┐
                              │     MySQL 8.0 (routewise_db)   │
                              │  - users, routes, toll_plazas  │
                              │  - pitstops, sightseeing       │
                              │  - hotels, transports, bookings│
                              └────────────────────────────────┘
```

### 1. Database Tier: MySQL 8.0 (`database/`)
* **`database/schema.sql`**: Full DDL schema with relational constraints, foreign keys, and indexes:
  * `users`: Authentication & traveler profile records
  * `routes`: Highway corridors, driving duration, distance
  * `toll_plazas`: Highway toll booths with real Fastag fees (e.g. Attibele, Krishnagiri, etc.)
  * `pitstops`: Verified clean highway restaurants, cuisine, and washroom quality scores
  * `sightseeing_places`: Must-visit spots with opening/closing hours and ticket prices
  * `hotels`: Budget, mid-range, and luxury stays
  * `transports`: Self-drive car rentals, outstation cabs, express trains, and Volvo buses
  * `bookings`: Confirmed reservations with unique references (`RW-HOTEL-...`, `RW-RIDE-...`)
* **`database/seed_data.sql`**: Comprehensive seed dataset for Bengaluru → Chennai, Delhi → Jaipur, and Mumbai → Goa.

### 2. Java 21 Core Backend (`backend-java/`)
* **Language**: Java 21 LTS (`OpenJDK 21`)
* **Location**: `backend-java/src/main/java/com/routewise/`
* **Responsibilities**:
  * User Authentication (`/api/auth/login`)
  * Hotel & Transport booking transaction engine (`/api/bookings`)
  * Official PDF / printable travel voucher reference generation
  * MySQL database connectivity via JDBC (`DatabaseManager.java`)
* **How to Run**: Run `backend-java\run_java_backend.bat` or compile with `javac`.

### 3. Python 3.11 Journey & Estimation Service (`backend-python/`)
* **Language**: Python 3.11
* **Location**: `backend-python/`
* **Responsibilities**:
  * `budget_engine.py`: Mathematical calculations for fuel consumption based on mileage/fuel rates, toll totals, group room requirements, and the 10% emergency buffer.
  * `weather_service.py`: Destination weather intelligence (temperature, humidity, wind, UV index, rain probability, and clothing advice).
  * `app.py`: REST microservice exposing `/api/estimate-journey` and `/api/weather`.
* **How to Run**: Run `backend-python\run_python_backend.bat` or `python app.py`.

### 4. Interactive Frontend Web Dashboard
* **Location**: `src/`
* **Key Features**:
  1. **Asking Page Wizard (`TripWizard.jsx`)**: Step-by-step interactive questionnaire asking about destinations, group size, vehicles, and budget preferences.
  2. **Budget Summary Card (`BudgetSummaryCard.jsx`)**: Comprehensive itemized estimation with visual expense distribution.
  3. **Turn-by-Turn GPS Guidance (`TurnByTurnNav.jsx`)**: Own vehicle driving directions with live toll notifications and a simulated navigation HUD.
  4. **Attractions with Timings (`SightseeingList.jsx`)**: Curated places with exact opening & closing hours, duration, and dynamic ticket inclusion.
  5. **Verified Highway Food (`FoodPitstops.jsx`)**: Clean restrooms and budget-matched dining options.
  6. **Transport & Hotel Booking (`BookingModal.jsx`)**: Instant reservation with official booking pass generation.
  7. **Smart Packing Checklist & Emergency Helpline**: Travel gear checklist and 1033 / 112 highway SOS speed-dial directory.
  8. **Group Share Splitter (`ExpenseSplitter.jsx`)**: Cost per person calculation with 1-click copy for WhatsApp.

---

## 🚀 How to Open and Run in VS Code

### Step 1: Open Folder in VS Code
1. Open **VS Code**.
2. Press `Ctrl + K, Ctrl + O` (or **File** → **Open Folder...**).
3. Select this folder:
   ```text
   C:\Users\sriva\Documents\antigravity\quick-raman
   ```

### Step 2: Set up MySQL Database
Open a terminal in VS Code and run:
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p < database\schema.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p < database\seed_data.sql
```
*(Or simply double-click `database\setup_mysql.bat`)*

### Step 3: Run the Services

You can run everything with the one-click launcher:
```cmd
run_all.bat
```

Or run each service individually in separate VS Code terminals:

* **Terminal 1 (Java 21 Backend)**:
  ```cmd
  cd backend-java
  run_java_backend.bat
  ```
  *(Server runs on `http://localhost:8080`)*

* **Terminal 2 (Python 3.11 Microservice)**:
  ```cmd
  cd backend-python
  run_python_backend.bat
  ```
  *(Microservice runs on `http://localhost:5000`)*

* **Terminal 3 (Web UI Dashboard)**:
  ```cmd
  cmd /c npm run dev
  ```
  *(Open `http://localhost:5173` in your browser)*

---

## 📂 Project Directory Structure

```text
RouteWise - Travel-Friendly Journeys/
├── backend-java/
│   ├── pom.xml                                  # Maven project descriptor
│   ├── run_java_backend.bat                     # Javac compile & run script
│   └── src/main/java/com/routewise/
│       ├── RouteWiseApplication.java            # Main Java 21 REST Server (Port 8080)
│       ├── db/
│       │   └── DatabaseManager.java             # MySQL JDBC Connection Manager
│       └── model/
│           ├── Booking.java                     # Booking Entity Model
│           ├── Hotel.java                       # Hotel Entity Model
│           └── User.java                        # User Account Model
├── backend-python/
│   ├── app.py                                   # Python REST API Server (Port 5000)
│   ├── budget_engine.py                         # RouteWise Mathematical Budget Engine
│   ├── weather_service.py                       # Destination Weather & Clothing Guide
│   ├── requirements.txt                         # Dependencies documentation
│   └── run_python_backend.bat                   # Python launcher script
├── database/
│   ├── schema.sql                               # MySQL 8.0 Complete Relational Schema
│   ├── seed_data.sql                            # Seed data (Chennai, Jaipur, Goa, etc.)
│   └── setup_mysql.bat                          # One-click MySQL database importer
├── src/
│   ├── components/
│   │   ├── Navbar.jsx                           # Header with RouteWise branding & Auth
│   │   ├── TripWizard.jsx                       # Interactive "Asking Page" Wizard
│   │   ├── BudgetSummaryCard.jsx                # Complete Journey Cost Card
│   │   ├── RouteMap.jsx                         # Leaflet Map with highway stops
│   │   ├── TurnByTurnNav.jsx                    # Own vehicle GPS & toll gate alerts
│   │   ├── SightseeingList.jsx                  # Recommendations with open/close timings
│   │   ├── FoodPitstops.jsx                     # Clean washrooms & budget dining
│   │   ├── HotelsSection.jsx                    # Group scaled accommodation
│   │   ├── TransportsSection.jsx                # Trains, Cabs, Rentals & Buses
│   │   ├── BookingModal.jsx                     # Reservation & travel voucher popup
│   │   ├── WeatherWidget.jsx                    # Live destination weather forecast
│   │   ├── DayTimeline.jsx                      # Hour-by-hour journey itinerary
│   │   ├── PackingChecklist.jsx                 # Smart packing assistant
│   │   ├── EmergencyDirectory.jsx               # Highway 1033 / 112 SOS helplines
│   │   ├── ExpenseSplitter.jsx                  # Group fair-share calculator
│   │   ├── AuthModal.jsx                        # Login & Sign Up modal
│   │   └── TripForm.jsx                         # Config parameters & sliders
│   ├── data/
│   │   └── travelData.js                        # Highway routes, tolls, attractions
│   ├── App.jsx                                  # Main Application Component
│   ├── main.jsx                                 # React App Entry Point
│   └── index.css                                # Tailwind CSS styles
├── index.html                                   # HTML wrapper with RouteWise title
├── package.json                                 # Frontend package configuration
├── run_all.bat                                  # Master launcher for all 3 tiers
└── README.md                                    # Complete project documentation
```
