from fastapi import APIRouter, HTTPException
from datetime import datetime, timedelta

router = APIRouter()

# Mock doctors database
doctors_db = [
    {
        'id': 1,
        'name': 'Dr. Sarah Johnson',
        'specialization': 'Hematology',
        'experience': 15,
        'rating': 4.8,
        'patients': 450,
        'phone': '+1-234-567-8900',
        'email': 'sarah@hospital.com',
        'location': 'New York Medical Center',
        'consultationFee': 100,
        'availability': {
            'monday': ['09:00', '10:00', '14:00', '15:00'],
            'tuesday': ['10:00', '11:00', '15:00', '16:00'],
            'wednesday': ['09:00', '14:00']
        },
        'image': 'https://via.placeholder.com/200'
    },
    {
        'id': 2,
        'name': 'Dr. Michael Chen',
        'specialization': 'Endocrinology',
        'experience': 12,
        'rating': 4.7,
        'patients': 380,
        'phone': '+1-234-567-8901',
        'email': 'michael@hospital.com',
        'location': 'Boston Health Institute',
        'consultationFee': 120,
        'availability': {
            'monday': ['09:00', '10:00', '14:00'],
            'wednesday': ['09:00', '10:00', '14:00', '15:00'],
        },
        'image': 'https://via.placeholder.com/200'
    },
    {
        'id': 3,
        'name': 'Dr. Emily Rodriguez',
        'specialization': 'Nephrology',
        'experience': 18,
        'rating': 4.9,
        'patients': 520,
        'phone': '+1-234-567-8902',
        'email': 'emily@hospital.com',
        'location': 'LA Kidney Center',
        'consultationFee': 150,
        'availability': {
            'monday': ['09:00', '14:00', '15:00'],
            'tuesday': ['10:00', '11:00', '14:00', '15:00'],
        },
        'image': 'https://via.placeholder.com/200'
    }
]

CONDITION_TO_SPECIALIZATION = {
    'anemia': 'Hematology',
    'diabetes': 'Endocrinology',
    'glucose': 'Endocrinology',
    'kidney': 'Nephrology',
    'liver': 'Hepatology',
    'heart': 'Cardiology',
}

@router.get('/doctors/recommendations')
async def get_recommendations(conditions: str = None):
    if not conditions:
        return {'success': True, 'doctors': doctors_db[:2]}
    
    condition_list = [c.strip().lower() for c in conditions.split(',')]
    specializations_needed = set()
    
    for condition in condition_list:
        for key, spec in CONDITION_TO_SPECIALIZATION.items():
            if key in condition.lower():
                specializations_needed.add(spec)
    
    recommended = [doc for doc in doctors_db if doc['specialization'] in specializations_needed]
    
    return {
        'success': True,
        'conditions': condition_list,
        'specializations': list(specializations_needed),
        'doctors': recommended,
        'total': len(recommended)
    }

@router.get('/doctors')
async def get_all_doctors(specialization: str = None):
    if specialization:
        filtered = [d for d in doctors_db if d['specialization'].lower() == specialization.lower()]
        return {'success': True, 'doctors': filtered}
    
    return {'success': True, 'doctors': doctors_db}

@router.get('/doctors/{doctor_id}')
async def get_doctor_detail(doctor_id: int):
    doctor = next((d for d in doctors_db if d['id'] == doctor_id), None)
    if not doctor:
        raise HTTPException(status_code=404, detail='Doctor not found')
    
    return {'success': True, 'doctor': doctor}

@router.get('/doctors/{doctor_id}/availability')
async def get_availability(doctor_id: int):
    doctor = next((d for d in doctors_db if d['id'] == doctor_id), None)
    if not doctor:
        raise HTTPException(status_code=404, detail='Doctor not found')
    
    return {
        'success': True,
        'doctor_id': doctor_id,
        'availability': doctor['availability'],
        'consultationFee': doctor['consultationFee']
    }

@router.get('/specializations')
async def get_specializations():
    specs = list(set([d['specialization'] for d in doctors_db]))
    return {'success': True, 'specializations': sorted(specs)}
