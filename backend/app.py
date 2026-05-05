from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
import os
import logging
from datetime import datetime
from config import settings
from routes import auth, reports, analysis, users, chat, doctors, appointments, notifications, reviews_records_prescriptions

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create upload directory
os.makedirs(settings.UPLOAD_DIR, exist_ok=True)

# Initialize FastAPI
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    debug=settings.DEBUG,
    docs_url="/docs" if settings.DEBUG else None,
    openapi_url="/openapi.json" if settings.DEBUG else None,
    redoc_url="/redoc" if settings.DEBUG else None,
)

# Security: Remove X-Powered-By header
@app.middleware("http")
async def remove_server_header(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    return response

# CORS Middleware - Restricted origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=['GET', 'POST', 'PUT', 'DELETE'],
    allow_headers=['Content-Type', 'Authorization'],
)

# Global exception handlers
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.warning(f"Validation error on {request.url}: {exc}")
    return JSONResponse(
        status_code=422,
        content={"detail": "Invalid request data", "errors": exc.errors()},
    )

@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception on {request.url}: {str(exc)}", exc_info=True)
    if settings.DEBUG:
        raise exc
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error", "timestamp": datetime.utcnow().isoformat()},
    )

# Include all routers
app.include_router(auth.router, prefix=settings.API_V1_STR, tags=['auth'])
app.include_router(users.router, prefix=settings.API_V1_STR, tags=['users'])
app.include_router(reports.router, prefix=settings.API_V1_STR, tags=['reports'])
app.include_router(analysis.router, prefix=settings.API_V1_STR, tags=['analysis'])
app.include_router(chat.router, prefix=settings.API_V1_STR, tags=['chat'])
app.include_router(doctors.router, prefix=settings.API_V1_STR, tags=['doctors'])
app.include_router(appointments.router, prefix=settings.API_V1_STR, tags=['appointments'])
app.include_router(notifications.router, prefix=settings.API_V1_STR, tags=['notifications'])
app.include_router(reviews_records_prescriptions.router, tags=['reviews', 'medical-records', 'prescriptions'])

@app.get('/')
def root():
    return {
        'message': 'Welcome to MedExplain Mobile API',
        'version': settings.APP_VERSION,
        'docs': '/docs' if settings.DEBUG else None
    }

@app.get('/health')
def health_check():
    return {
        'status': 'healthy',
        'version': settings.APP_VERSION,
        'timestamp': datetime.utcnow().isoformat()
    }

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(
        'app:app',
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
        log_level='info' if settings.DEBUG else 'warning'
    )
