from fastapi import APIRouter

router = APIRouter()

@router.get('/users/profile')
async def get_profile():
    return {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'age': 30
    }

@router.put('/users/profile')
async def update_profile(name: str = None, phone: str = None):
    return {'success': True, 'message': 'Profile updated'}
