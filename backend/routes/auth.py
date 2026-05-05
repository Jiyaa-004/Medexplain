from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime, timedelta, timezone
import bcrypt
import jwt
from config import settings
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str = Field(min_length=1)

class SignupRequest(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    password: str = Field(min_length=settings.PASSWORD_MIN_LENGTH)

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = 'bearer'
    user: dict
    expires_in: int

class RefreshTokenRequest(BaseModel):
    refresh_token: str

# Mock users database
users_db = {}
# Account lockout tracking
login_attempts = {}

def validate_password(password: str) -> tuple[bool, str]:
    """Validate password meets requirements"""
    if len(password) < settings.PASSWORD_MIN_LENGTH:
        return False, f"Password must be at least {settings.PASSWORD_MIN_LENGTH} characters"
    if not any(c.isupper() for c in password):
        return False, "Password must contain at least one uppercase letter"
    if not any(c.isdigit() for c in password):
        return False, "Password must contain at least one number"
    return True, ""

def check_account_lockout(email: str) -> bool:
    """Check if account is locked due to too many failed attempts"""
    if email not in login_attempts:
        return False
    
    attempts_info = login_attempts[email]
    if attempts_info['count'] >= settings.MAX_LOGIN_ATTEMPTS:
        time_elapsed = datetime.now(timezone.utc) - attempts_info['first_attempt']
        if time_elapsed < timedelta(minutes=settings.LOGIN_ATTEMPT_WINDOW_MINUTES):
            return True
        else:
            # Reset attempts after window expires
            del login_attempts[email]
    return False

def record_failed_attempt(email: str):
    """Record a failed login attempt"""
    if email not in login_attempts:
        login_attempts[email] = {
            'count': 1,
            'first_attempt': datetime.now(timezone.utc)
        }
    else:
        time_elapsed = datetime.now(timezone.utc) - login_attempts[email]['first_attempt']
        if time_elapsed < timedelta(minutes=settings.LOGIN_ATTEMPT_WINDOW_MINUTES):
            login_attempts[email]['count'] += 1
        else:
            # Reset attempts after window expires
            login_attempts[email] = {
                'count': 1,
                'first_attempt': datetime.now(timezone.utc)
            }

def clear_login_attempts(email: str):
    """Clear failed login attempts after successful login"""
    if email in login_attempts:
        del login_attempts[email]

@router.post('/auth/signup', response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def signup(request: SignupRequest):
    """Create a new user account"""
    # Check if email already exists
    if request.email in users_db:
        logger.warning(f"Signup attempt with existing email: {request.email}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail='Email already registered'
        )
    
    # Validate password
    is_valid, message = validate_password(request.password)
    if not is_valid:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=message
        )
    
    # Hash password
    hashed_password = bcrypt.hashpw(request.password.encode(), bcrypt.gensalt()).decode()
    
    # Create user
    user = {
        'id': len(users_db) + 1,
        'name': request.name,
        'email': request.email,
        'password': hashed_password,
        'created_at': datetime.now(timezone.utc).isoformat()
    }
    
    users_db[request.email] = user
    logger.info(f"New user registered: {request.email}")
    
    # Generate tokens
    now = datetime.now(timezone.utc)
    access_token = jwt.encode(
        {
            'sub': request.email,
            'exp': now + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
            'iat': now,
            'type': 'access'
        },
        settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM
    )
    
    refresh_token = jwt.encode(
        {
            'sub': request.email,
            'exp': now + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS),
            'iat': now,
            'type': 'refresh'
        },
        settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM
    )
    
    # Store refresh token
    user['refresh_token'] = refresh_token
    
    return {
        'access_token': access_token,
        'token_type': 'bearer',
        'user': {'id': user['id'], 'name': user['name'], 'email': user['email']},
        'expires_in': settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60  # in seconds
    }

@router.post('/auth/login', response_model=TokenResponse)
def login(request: LoginRequest):
    """Authenticate user and return access token"""
    # Check account lockout
    if check_account_lockout(request.email):
        logger.warning(f"Login attempt on locked account: {request.email}")
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail='Account locked due to too many failed attempts. Try again later.'
        )
    
    # Check if user exists
    if request.email not in users_db:
        record_failed_attempt(request.email)
        logger.warning(f"Login attempt for non-existent user: {request.email}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid credentials'
        )
    
    user = users_db[request.email]
    
    # Verify password
    if not bcrypt.checkpw(request.password.encode(), user['password'].encode()):
        record_failed_attempt(request.email)
        logger.warning(f"Failed login for user: {request.email}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid credentials'
        )
    
    # Clear failed attempts on successful login
    clear_login_attempts(request.email)
    logger.info(f"Successful login for user: {request.email}")
    
    # Generate tokens
    now = datetime.now(timezone.utc)
    access_token = jwt.encode(
        {
            'sub': request.email,
            'exp': now + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
            'iat': now,
            'type': 'access'
        },
        settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM
    )
    
    refresh_token = jwt.encode(
        {
            'sub': request.email,
            'exp': now + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS),
            'iat': now,
            'type': 'refresh'
        },
        settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM
    )
    
    # Store refresh token
    user['refresh_token'] = refresh_token
    
    return {
        'access_token': access_token,
        'token_type': 'bearer',
        'user': {'id': user['id'], 'name': user['name'], 'email': user['email']},
        'expires_in': settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60  # in seconds
    }

@router.post('/auth/refresh', response_model=TokenResponse)
def refresh_token(request: RefreshTokenRequest):
    """Refresh access token using refresh token"""
    try:
        payload = jwt.decode(
            request.refresh_token,
            settings.JWT_SECRET,
            algorithms=[settings.JWT_ALGORITHM]
        )
        
        if payload.get('type') != 'refresh':
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail='Invalid token type'
            )
        
        email = payload.get('sub')
        if not email or email not in users_db:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail='Invalid token'
            )
        
        user = users_db[email]
        
        # Generate new access token
        now = datetime.now(timezone.utc)
        access_token = jwt.encode(
            {
                'sub': email,
                'exp': now + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
                'iat': now,
                'type': 'access'
            },
            settings.JWT_SECRET,
            algorithm=settings.JWT_ALGORITHM
        )
        
        return {
            'access_token': access_token,
            'token_type': 'bearer',
            'user': {'id': user['id'], 'name': user['name'], 'email': user['email']},
            'expires_in': settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }
    
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Refresh token has expired'
        )
    except jwt.InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid refresh token'
        )
