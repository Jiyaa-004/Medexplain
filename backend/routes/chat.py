from fastapi import APIRouter

router = APIRouter()

@router.post('/chat/send')
async def send_message(message: str):
    return {
        'success': True,
        'user_message': message,
        'ai_response': 'I understand. How can I help you?'
    }

@router.get('/chat/history')
async def get_chat_history():
    return {'messages': []}
