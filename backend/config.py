import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    # App
    APP_NAME = "MedExplain Mobile API"
    APP_VERSION = "1.0.0"
    ENVIRONMENT = os.getenv('ENVIRONMENT', 'development')  # development, staging, production
    DEBUG = ENVIRONMENT == 'development'
    
    # Server
    HOST = os.getenv('HOST', '0.0.0.0')
    PORT = int(os.getenv('PORT', 8000))
    
    # Database
    DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///medexplain.db')
    
    # JWT
    JWT_SECRET = os.getenv('JWT_SECRET')
    JWT_ALGORITHM = 'HS256'
    ACCESS_TOKEN_EXPIRE_MINUTES = 15  # Reduced from 30 days to 15 minutes
    REFRESH_TOKEN_EXPIRE_DAYS = 7
    
    # Security
    MAX_LOGIN_ATTEMPTS = 5
    LOGIN_ATTEMPT_WINDOW_MINUTES = 15
    PASSWORD_MIN_LENGTH = 8
    
    # File Upload
    UPLOAD_DIR = 'uploads'
    MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'pdf', 'txt'}
    ALLOWED_MIME_TYPES = {'image/png', 'image/jpeg', 'application/pdf', 'text/plain'}
    
    # CORS - Allow all origins in development mode for mobile/web clients
    # In production, set specific allowed origins
    _cors_origins = os.getenv('CORS_ORIGINS', '*' if ENVIRONMENT == 'development' else 'https://yourdomain.com')
    CORS_ORIGINS = ['*'] if _cors_origins == '*' else _cors_origins.split(',')
    
    # API
    API_V1_STR = '/api/v1'
    
    def __init__(self):
        """Validate critical settings on initialization"""
        if self.ENVIRONMENT == 'production':
            if not self.JWT_SECRET or self.JWT_SECRET == 'your-secret-key':
                raise ValueError("JWT_SECRET must be set in production environment")
            if self.DEBUG:
                raise ValueError("DEBUG must be False in production")

settings = Settings()
