# Troubleshooting Guide - MedExplain Mobile

## Fixing Common Issues

### Backend Issues

#### 1. Python Virtual Environment Not Activating
```bash
# Error: 'python' is not recognized
# Solution:
python -m venv .venv

# Windows
.venv\Scripts\activate

# Mac/Linux
source .venv/bin/activate

# Verify:
python --version
```

#### 2. pip: command not found
```bash
# Solution:
python -m pip install --upgrade pip

# Then use:
python -m pip install -r requirements.txt
```

#### 3. Port 8000 Already in Use
```bash
# Find process using port 8000:
netstat -ano | findstr :8000

# Kill the process (replace PID):
taskkill /PID <PID> /F

# Or use different port:
uvicorn app:app --reload --host 0.0.0.0 --port 8001

# Then update Flutter app's baseUrl in api_service.dart
```

#### 4. Module Not Found Errors
```bash
# Ensure virtual environment is activated:
.venv\Scripts\activate

# Reinstall dependencies:
pip install -r requirements.txt

# Check what's installed:
pip list
```

#### 5. Uvicorn Not Found
```bash
# Solution:
.venv\Scripts\activate
pip install uvicorn==0.24.0
```

#### 6. Database Errors
```bash
# Delete and recreate SQLite database:
cd backend
del medexplain.db

# Restart the server - it will create a new one
```

#### 7. CORS Errors
If frontend can't reach backend, update `.env`:
```
CORS_ORIGINS=*
```

For production, specify exact URLs:
```
CORS_ORIGINS=http://localhost:19006,https://yourdomain.com
```

---

### Frontend Issues

#### 1. Flutter Packages Not Found
```bash
# Solution:
cd flutter_app
flutter pub get
flutter pub upgrade
flutter clean
flutter pub get
```

#### 2. Doctor Check Failures
```bash
# Run diagnostic:
flutter doctor

# Accept Android licenses:
flutter doctor --android-licenses

# Update Flutter:
flutter upgrade
```

#### 3. No Device Available
```bash
# List available devices:
flutter devices

# Launch Android emulator:
flutter emulators --launch Pixel_4_API_30

# Launch iOS simulator:
open -a Simulator
```

#### 4. App Crashes on Startup
```
# Check logs:
flutter run -v

# Clean project:
flutter clean
flutter pub get
flutter run
```

#### 5. Cannot Connect to Backend (Network Error)

**For Android Emulator:**
```dart
// In api_service.dart, use this instead:
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
```

**For iOS Simulator:**
```dart
// Keep this:
static const String baseUrl = 'http://localhost:8000/api/v1';
```

**For Physical Device:**
```dart
// Use your machine's IP address:
static const String baseUrl = 'http://192.168.X.X:8000/api/v1';
```

#### 6. Package Import Errors
```bash
# Solution:
flutter pub cache repair
flutter pub get
flutter clean
flutter pub get
```

#### 7. Build Cache Issues
```bash
# Clear everything and rebuild:
flutter clean
cd ios && rm -rf Pods
cd ../
flutter pub get
flutter run
```

---

### Connection Issues Between Frontend & Backend

#### Test Backend Connectivity
```bash
# From terminal on same machine:
curl http://localhost:8000/health

# Should return:
# {"status":"healthy","version":"1.0.0"}
```

#### Debug API Calls
```bash
# Check Flutter logs:
flutter run -v

# Check Backend logs:
# Look at uvicorn output in backend terminal
```

#### Network Debugging (Android)
```bash
# Use Charles or Fiddler proxy
# Or check adb logs:
adb logcat | grep flutter
```

---

### Git & Version Control Issues

#### Reset Project to Clean State
```bash
# Backend:
cd backend
git clean -fd
pip install -r requirements.txt

# Frontend:
cd flutter_app
git clean -fd
flutter pub get
```

---

### Performance Issues

#### Slow Backend Response
```bash
# Check database:
# SQLite is slow, consider PostgreSQL for production

# Monitor server:
# Add logging to routes to find bottlenecks
```

#### App Crashes or Lags
```bash
# Profile the app:
flutter run --profile

# Check for memory leaks in Flutter DevTools:
flutter pub global activate devtools
devtools
```

---

### File Permission Issues

#### Windows: File Access Denied
```bash
# Run VS Code as Administrator
# Or check file properties and unlock if needed
```

#### Database File Locked
```bash
# Solution: Restart backend server
# Or delete medexplain.db and let it recreate
```

---

### Environment File Issues

#### .env Not Being Read
```bash
# In app.py, ensure this is at the top:
from dotenv import load_dotenv
load_dotenv()

# Verify .env is in backend root directory
```

#### Environment Variables Not Loading
```bash
# Restart the server after changing .env:
# Press Ctrl+C to stop
# Make changes to .env
# Run uvicorn again
```

---

### API Endpoint Issues

#### 404 Not Found Errors
- Check if backend is running
- Verify the API route exists in routes folder
- Check for typos in URL

#### 500 Internal Server Error
- Check backend terminal for error message
- Look at the routes file for the problematic endpoint
- Check if required dependencies are installed

#### Authentication Errors
- Ensure JWT_SECRET is set in .env
- Verify token is being sent correctly
- Check token expiration time

---

### Specific Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `[Errno 111] Connection refused` | Backend not running | Start backend server |
| `json.decoder.JSONDecodeError` | Invalid API response | Check backend logs |
| `Certificate verify failed` | SSL/TLS issue | Use http instead of https for local dev |
| `TimeoutError` | Request took too long | Increase timeout or check network |
| `FlutterError: No material library found` | Missing imports | Check Flutter imports |

---

### Emergency Fixes

#### Complete Reset (Last Resort)
```bash
# Backend:
cd backend
.venv\Scripts\deactivate
rmdir /s .venv
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
del medexplain.db

# Frontend:
cd flutter_app
flutter clean
rm -rf pubspec.lock
flutter pub get
```

#### Verify Everything Works
```bash
# Backend test:
curl http://localhost:8000/health

# Frontend test:
flutter run -v
```

---

### Getting Help

1. Check the main **SETUP_AND_RUN_GUIDE.md**
2. Review **QUICK_START.md** for fast reference
3. Check backend logs: Look at uvicorn terminal
4. Check Flutter logs: Run `flutter run -v`
5. Check API docs: http://localhost:8000/docs

---

### Support Resources

- **Flutter Issues:** https://flutter.dev/docs/testing/debugging
- **FastAPI Issues:** https://fastapi.tiangolo.com/deployment/
- **Python Issues:** https://www.python.org/doc/
- **Network Issues:** Use browser DevTools or Postman to test API

---

**Pro Tips:**
- Always activate virtual environment before working with backend
- Always check error logs in the terminal where service is running
- Use `flutter run -v` for verbose output when debugging
- Use Swagger UI (http://localhost:8000/docs) to test backend endpoints
- Clear cache regularly: `flutter clean`, `.venv` reset

---

Last Updated: May 3, 2026
