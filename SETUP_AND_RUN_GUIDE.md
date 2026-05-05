# MedExplain Mobile - Setup & Run Guide

This guide will help you set up and run the MedExplain Mobile project (Flutter frontend + FastAPI backend).

## Project Structure

```
MedExplain-Mobile-Complete/
├── backend/              # FastAPI backend (Python)
├── flutter_app/          # Flutter mobile app
├── docs/                 # Documentation
├── docker/               # Docker configuration
└── Database/             # Database files
```

---

## Prerequisites

Before starting, ensure you have installed:

### For Backend:
- **Python 3.8+** - [Download](https://www.python.org/downloads/)
- **pip** (usually comes with Python)

### For Frontend:
- **Flutter SDK** - [Download](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **Xcode** (for emulator/simulator)
- **Dart** (comes with Flutter)

---

## Part 1: Backend Setup (FastAPI)

### Step 1: Navigate to Backend Directory
```bash
cd backend
```

### Step 2: Create Virtual Environment
```bash
# On Windows:
python -m venv .venv

# Activate virtual environment:
.venv\Scripts\activate
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Verify Environment Configuration
The `.env` file is already configured with default values. Review it:
```bash
cat .env
```

**Key environment variables:**
- `DEBUG=True` (set to `False` in production)
- `HOST=0.0.0.0`
- `PORT=8000`
- `DATABASE_URL=sqlite:///medexplain.db`
- `JWT_SECRET=your-secret-key-change-in-production-12345`

### Step 5: Run the Backend Server
```bash
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

**Expected Output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete
```

✅ Backend is now running on `http://localhost:8000`

### Access Backend Documentation
Open your browser and visit: `http://localhost:8000/docs`

---

## Part 2: Frontend Setup (Flutter)

### Step 1: Navigate to Flutter App Directory
```bash
cd flutter_app
```

### Step 2: Get Flutter Dependencies
```bash
flutter pub get
```

### Step 3: Verify Flutter Installation
```bash
flutter doctor
```

All items should show checkmarks (✓). Fix any issues shown.

### Step 4: Check Available Devices
```bash
flutter devices
```

You should see at least one device (emulator or physical device).

### Step 5: Run the Flutter App

#### Option A: Run on Connected Device
```bash
flutter run
```

#### Option B: Run on Specific Device
```bash
flutter run -d <device_id>
```

#### Option C: Run in Release Mode (Better Performance)
```bash
flutter run --release
```

✅ App is now running and will connect to the backend at `http://localhost:8000/api/v1`

---

## Running Both Services Simultaneously

### Method 1: Using Multiple Terminal Windows

**Terminal 1 - Backend:**
```bash
cd backend
.venv\Scripts\activate
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Frontend:**
```bash
cd flutter_app
flutter run
```

### Method 2: Using VS Code

1. Open the project in VS Code
2. Open Terminal 1: `Ctrl + Shift + ~`
3. Open Terminal 2: `Ctrl + Shift + ~` again
4. Run backend in Terminal 1
5. Run frontend in Terminal 2

---

## Available API Endpoints

Once the backend is running, you can test these endpoints:

### Authentication
- `POST /api/v1/auth/signup` - Register new user
- `POST /api/v1/auth/login` - User login

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PUT /api/v1/users/profile` - Update user profile

### Doctors
- `GET /api/v1/doctors/recommendations` - Get recommended doctors
- `GET /api/v1/doctors/{doctor_id}` - Get doctor details

### Appointments
- `POST /api/v1/appointments/book` - Book appointment
- `GET /api/v1/appointments` - Get user appointments
- `GET /api/v1/appointments/{appointment_id}` - Get appointment details

### Reports
- `POST /api/v1/reports/upload` - Upload medical report
- `GET /api/v1/reports` - Get all reports
- `GET /api/v1/reports/{report_id}` - Get specific report

### Analysis
- `POST /api/v1/analysis/analyze` - Analyze medical report
- `GET /api/v1/analysis/{report_id}` - Get analysis results

### Chat
- `POST /api/v1/chat/send` - Send chat message
- `GET /api/v1/chat/history` - Get chat history

### Notifications
- `POST /api/v1/notifications/register-device` - Register device for notifications
- `GET /api/v1/notifications` - Get user notifications

---

## Troubleshooting

### Issue: Backend Port Already in Use
**Solution:** Change the port in the run command:
```bash
uvicorn app:app --reload --host 0.0.0.0 --port 8001
```
Then update `baseUrl` in `flutter_app/lib/services/api_service.dart` to `http://localhost:8001/api/v1`

### Issue: Flutter App Cannot Connect to Backend
**Solution:** 
- Ensure backend is running on `http://localhost:8000`
- Check if Android emulator/iOS simulator can reach localhost
- On Android emulator, use `http://10.0.2.2:8000` instead of `http://localhost:8000`
- On iOS simulator, use `http://localhost:8000`

### Issue: `ModuleNotFoundError` in Python
**Solution:** Ensure virtual environment is activated:
```bash
.venv\Scripts\activate
```

### Issue: Flutter Dependencies Issue
**Solution:** Clean and reinstall:
```bash
flutter clean
flutter pub get
```

### Issue: Database Error
**Solution:** Delete the existing database and let it recreate:
```bash
rm medexplain.db
```

---

## Project Features

### Backend Features:
✅ User Authentication (JWT)
✅ Doctor Management
✅ Appointment Booking
✅ Medical Report Upload & Analysis
✅ Chat System
✅ Notifications
✅ User Profile Management

### Frontend Features:
✅ User Authentication Screen
✅ Dashboard with Health Summary
✅ Doctor Search & Discovery
✅ Doctor Profile View
✅ Appointment Booking
✅ Appointments Management
✅ Notifications View
✅ User Profile Management
✅ Report Upload & Analysis

---

## Development Notes

### Adding New Dependencies

**Backend (Python):**
```bash
pip install package_name
pip freeze > requirements.txt
```

**Frontend (Flutter):**
```bash
flutter pub add package_name
```

### Database

- Currently using SQLite (`medexplain.db`)
- Located in the backend root directory
- To reset: delete the file and restart the server

### Environment Variables

Update `.env` file in the backend directory for:
- Database configuration
- JWT secrets (change in production!)
- API keys for external services
- CORS settings

---

## Deployment Notes

### For Production:

1. **Change Debug Mode:**
   - Update `.env`: `DEBUG=False`

2. **Set Strong JWT Secret:**
   ```
   JWT_SECRET=<generate-strong-random-string>
   ```

3. **Update CORS Origins:**
   ```
   CORS_ORIGINS=your-frontend-url,your-api-url
   ```

4. **Use PostgreSQL instead of SQLite:**
   ```
   DATABASE_URL=postgresql://user:password@localhost/medexplain
   ```

5. **Build Flutter for Release:**
   ```bash
   flutter build apk  # For Android
   flutter build ios  # For iOS
   ```

---

## API Documentation

Full interactive API documentation available at:
- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`

---

## Support & Documentation

- Flutter Documentation: https://flutter.dev/docs
- FastAPI Documentation: https://fastapi.tiangolo.com
- Project Wiki: See `docs/COMPLETE_GUIDE.md`

---

## Quick Start Summary

```bash
# Terminal 1 - Backend
cd backend
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app:app --reload --host 0.0.0.0 --port 8000

# Terminal 2 - Frontend
cd flutter_app
flutter pub get
flutter run
```

That's it! 🎉 Your MedExplain Mobile app is now running!

---

**Last Updated:** May 3, 2026
**Version:** 1.0.0
