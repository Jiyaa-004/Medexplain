from fastapi import APIRouter, HTTPException
from datetime import datetime, timedelta
from typing import List

router = APIRouter()

# Mock appointments database
appointments_db = {}

@router.post('/appointments/book')
async def book_appointment(doctor_id: int, appointment_date: str, appointment_time: str, user_id: int = 1):
    appointment_id = f'APT_{doctor_id}_{appointment_date}_{appointment_time}'
    
    appointment = {
        'id': appointment_id,
        'doctor_id': doctor_id,
        'user_id': user_id,
        'date': appointment_date,
        'time': appointment_time,
        'status': 'confirmed',
        'created_at': datetime.now().isoformat(),
        'reminder_sent': False,
        'consultation_fee': 100
    }
    
    appointments_db[appointment_id] = appointment
    
    return {
        'success': True,
        'appointment': appointment,
        'message': 'Appointment booked successfully'
    }

@router.get('/appointments')
async def get_appointments(user_id: int = 1):
    user_appointments = [apt for apt in appointments_db.values() if apt['user_id'] == user_id]
    
    return {
        'success': True,
        'appointments': user_appointments,
        'total': len(user_appointments)
    }

@router.get('/appointments/{appointment_id}')
async def get_appointment(appointment_id: str):
    if appointment_id not in appointments_db:
        raise HTTPException(status_code=404, detail='Appointment not found')
    
    return {'success': True, 'appointment': appointments_db[appointment_id]}

@router.put('/appointments/{appointment_id}/reschedule')
async def reschedule_appointment(appointment_id: str, new_date: str, new_time: str):
    if appointment_id not in appointments_db:
        raise HTTPException(status_code=404, detail='Appointment not found')
    
    appointment = appointments_db[appointment_id]
    appointment['date'] = new_date
    appointment['time'] = new_time
    appointment['reminder_sent'] = False
    
    return {
        'success': True,
        'message': 'Appointment rescheduled',
        'appointment': appointment
    }

@router.delete('/appointments/{appointment_id}')
async def cancel_appointment(appointment_id: str):
    if appointment_id not in appointments_db:
        raise HTTPException(status_code=404, detail='Appointment not found')
    
    del appointments_db[appointment_id]
    
    return {'success': True, 'message': 'Appointment cancelled'}

@router.get('/appointments/{appointment_id}/reminder')
async def send_reminder(appointment_id: str):
    if appointment_id not in appointments_db:
        raise HTTPException(status_code=404, detail='Appointment not found')
    
    appointment = appointments_db[appointment_id]
    appointment['reminder_sent'] = True
    
    return {
        'success': True,
        'message': 'Reminder sent to user',
        'appointment_details': {
            'date': appointment['date'],
            'time': appointment['time'],
            'doctor_id': appointment['doctor_id']
        }
    }
