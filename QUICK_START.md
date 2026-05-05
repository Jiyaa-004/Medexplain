# Quick Start Reference - MedExplain Mobile

## Prerequisites Check

- [ ] Python 3.8+ installed
- [ ] Flutter SDK installed
- [ ] Android Emulator or iOS Simulator ready
- [ ] VS Code or preferred IDE

## One-Command Quick Start

### Terminal 1 (Backend):
```bash
cd backend && .venv\Scripts\activate && pip install -r requirements.txt && uvicorn app:app --reload
```

### Terminal 2 (Frontend):
```bash
cd flutter_app && flutter pub get && flutter run
```

## Manual Steps

### Backend Setup:
1. `cd backend`
2. `.venv\Scripts\activate`
3. `pip install -r requirements.txt`
4. `uvicorn app:app --reload --host 0.0.0.0 --port 8000`
5. Open http://localhost:8000/docs in browser ✓

### Frontend Setup:
1. `cd flutter_app`
2. `flutter pub get`
3. `flutter doctor` (verify all checks pass)
4. `flutter devices` (see available devices)
5. `flutter run`

## Testing the Connection

Once both services are running:

1. Open http://localhost:8000/docs
2. Try "Login" endpoint with:
   ```json
   {
     "email": "test@example.com",
     "password": "password123"
   }
   ```
3. In the app, use same credentials to login

## Important URLs

- **API Base:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/health

## Default Credentials (for testing)

Use any email/password combination in the dev environment.

## Issues & Solutions

| Issue | Solution |
|-------|----------|
| Port 8000 in use | Change port: `--port 8001` and update Flutter config |
| Flutter can't connect | Android emulator: use `http://10.0.2.2:8000` |
| Python module not found | Activate venv: `.venv\Scripts\activate` |
| Flutter dependencies error | Run: `flutter clean && flutter pub get` |

## File Changes Made

✅ **Fixed:** `flutter_app/lib/services/api_service.dart`
- Fixed 3 incorrect API URLs
- Corrected baseUrl references

✅ **Verified:** All backend routes properly configured
✅ **Verified:** All Python dependencies in requirements.txt
✅ **Verified:** All Flutter packages in pubspec.yaml
✅ **Created:** Complete setup guide

## Next Steps

1. Follow the SETUP_AND_RUN_GUIDE.md for detailed instructions
2. Run both backend and frontend services
3. Test the app through the UI or Swagger docs
4. Deploy to production following the guide

---

For detailed information, see **SETUP_AND_RUN_GUIDE.md**
