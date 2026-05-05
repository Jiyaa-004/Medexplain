from fastapi import APIRouter, HTTPException
from datetime import datetime
from typing import List

router = APIRouter()

# Mock notifications database
notifications_db = {}

@router.post('/notifications/register-device')
async def register_device(user_id: int, device_token: str, platform: str):
    device_id = f'{user_id}_{platform}'
    
    notifications_db[device_id] = {
        'user_id': user_id,
        'device_token': device_token,
        'platform': platform,
        'registered_at': datetime.now().isoformat(),
        'enabled': True
    }
    
    return {
        'success': True,
        'message': 'Device registered for notifications',
        'device_id': device_id
    }

@router.get('/notifications')
async def get_notifications(user_id: int):
    user_notifications = [
        {
            'id': 1,
            'title': 'Appointment Reminder',
            'body': 'You have an appointment with Dr. Sarah Johnson tomorrow at 10:00',
            'timestamp': datetime.now().isoformat(),
            'read': False,
            'type': 'appointment'
        },
        {
            'id': 2,
            'title': 'Report Available',
            'body': 'Your medical report analysis is ready',
            'timestamp': datetime.now().isoformat(),
            'read': True,
            'type': 'report'
        }
    ]
    
    return {
        'success': True,
        'notifications': user_notifications,
        'total': len(user_notifications)
    }

@router.post('/notifications/send')
async def send_notification(user_id: int, title: str, body: str, notification_type: str = 'general'):
    notification = {
        'id': len(notifications_db) + 1,
        'user_id': user_id,
        'title': title,
        'body': body,
        'type': notification_type,
        'timestamp': datetime.now().isoformat(),
        'read': False
    }
    
    return {
        'success': True,
        'message': 'Notification sent',
        'notification': notification
    }

@router.put('/notifications/{notification_id}/read')
async def mark_as_read(notification_id: int):
    return {
        'success': True,
        'message': 'Notification marked as read'
    }

@router.post('/notifications/appointment-reminder')
async def send_appointment_reminder(appointment_id: str, user_id: int, doctor_name: str, appointment_date: str, appointment_time: str):
    reminder = {
        'success': True,
        'message': 'Appointment reminder sent',
        'reminder': {
            'type': 'appointment_reminder',
            'title': f'Appointment with {doctor_name}',
            'body': f'Your appointment is on {appointment_date} at {appointment_time}',
            'appointment_id': appointment_id,
            'sent_at': datetime.now().isoformat()
        }
    }
    
    return reminder

@router.post('/notifications/schedule-reminder')
async def schedule_reminder(appointment_id: str, user_id: int, reminder_time: str):
    return {
        'success': True,
        'message': 'Reminder scheduled',
        'scheduled_for': reminder_time
    }
