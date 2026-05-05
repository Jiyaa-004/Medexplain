from fastapi import APIRouter, HTTPException
from typing import List, Optional
from datetime import datetime
from models.reviews_records_prescriptions import Review, MedicalRecord, Prescription

router = APIRouter(prefix="/api/v1", tags=["reviews_records_prescriptions"])

# In-memory storage (replace with database in production)
reviews_db = {}
records_db = {}
prescriptions_db = {}

# ==================== REVIEWS ====================

@router.post("/reviews")
async def create_review(
    doctor_id: int,
    rating: float,
    title: str,
    comment: str,
    patient_id: int = 1,
):
    """Create a doctor review"""
    if rating < 1 or rating > 5:
        raise HTTPException(status_code=422, detail="Rating must be between 1 and 5")
    
    if not title or not comment:
        raise HTTPException(status_code=422, detail="Title and comment are required")
    
    review_id = len(reviews_db) + 1
    review = Review(
        id=review_id,
        doctor_id=doctor_id,
        patient_id=patient_id,
        rating=rating,
        title=title,
        comment=comment,
    )
    reviews_db[review_id] = review
    
    return {
        'success': True,
        'message': 'Review created successfully',
        'review': review.to_dict(),
    }


@router.get("/doctors/{doctor_id}/reviews")
async def get_doctor_reviews(doctor_id: int):
    """Get all reviews for a doctor"""
    doctor_reviews = [
        review.to_dict() 
        for review in reviews_db.values() 
        if review.doctor_id == doctor_id
    ]
    
    if not doctor_reviews:
        return {
            'success': True,
            'reviews': [],
            'average_rating': 0,
            'total_reviews': 0,
        }
    
    avg_rating = sum(r['rating'] for r in doctor_reviews) / len(doctor_reviews)
    
    return {
        'success': True,
        'reviews': sorted(doctor_reviews, key=lambda x: x['created_at'], reverse=True),
        'average_rating': round(avg_rating, 1),
        'total_reviews': len(doctor_reviews),
    }


@router.put("/reviews/{review_id}")
async def update_review(
    review_id: int,
    rating: Optional[float] = None,
    title: Optional[str] = None,
    comment: Optional[str] = None,
    patient_id: int = 1,
):
    """Update a review"""
    review = reviews_db.get(review_id)
    if not review:
        raise HTTPException(status_code=404, detail="Review not found")
    
    if review.patient_id != patient_id:
        raise HTTPException(status_code=403, detail="You can only update your own reviews")
    
    if rating is not None:
        if rating < 1 or rating > 5:
            raise HTTPException(status_code=422, detail="Rating must be between 1 and 5")
        review.rating = rating
    
    if title:
        review.title = title
    if comment:
        review.comment = comment
    
    review.updated_at = datetime.now()
    
    return {
        'success': True,
        'message': 'Review updated successfully',
        'review': review.to_dict(),
    }


@router.delete("/reviews/{review_id}")
async def delete_review(review_id: int, patient_id: int = 1):
    """Delete a review"""
    review = reviews_db.get(review_id)
    if not review:
        raise HTTPException(status_code=404, detail="Review not found")
    
    if review.patient_id != patient_id:
        raise HTTPException(status_code=403, detail="You can only delete your own reviews")
    
    del reviews_db[review_id]
    
    return {
        'success': True,
        'message': 'Review deleted successfully',
    }


# ==================== MEDICAL RECORDS ====================

@router.post("/medical-records")
async def create_medical_record(
    title: str,
    description: str,
    record_type: str,
    file_url: Optional[str] = None,
    doctor_id: Optional[int] = None,
    patient_id: int = 1,
):
    """Create a medical record"""
    valid_types = ['lab_report', 'x_ray', 'prescription', 'general']
    if record_type not in valid_types:
        raise HTTPException(status_code=422, detail=f"Record type must be one of {valid_types}")
    
    record_id = len(records_db) + 1
    record = MedicalRecord(
        id=record_id,
        patient_id=patient_id,
        doctor_id=doctor_id,
        title=title,
        description=description,
        record_type=record_type,
        file_url=file_url,
    )
    records_db[record_id] = record
    
    return {
        'success': True,
        'message': 'Medical record created successfully',
        'record': record.to_dict(),
    }


@router.get("/medical-records")
async def get_medical_records(
    record_type: Optional[str] = None,
    patient_id: int = 1,
):
    """Get user's medical records"""
    records = [
        record.to_dict()
        for record in records_db.values()
        if record.patient_id == patient_id
    ]
    
    if record_type:
        records = [r for r in records if r['record_type'] == record_type]
    
    return {
        'success': True,
        'records': sorted(records, key=lambda x: x['created_at'], reverse=True),
    }


@router.get("/medical-records/{record_id}")
async def get_medical_record(record_id: int, patient_id: int = 1):
    """Get a specific medical record"""
    record = records_db.get(record_id)
    if not record:
        raise HTTPException(status_code=404, detail="Medical record not found")
    
    if record.patient_id != patient_id:
        raise HTTPException(status_code=403, detail="Access denied")
    
    return {
        'success': True,
        'record': record.to_dict(),
    }


@router.delete("/medical-records/{record_id}")
async def delete_medical_record(record_id: int, patient_id: int = 1):
    """Delete a medical record"""
    record = records_db.get(record_id)
    if not record:
        raise HTTPException(status_code=404, detail="Medical record not found")
    
    if record.patient_id != patient_id:
        raise HTTPException(status_code=403, detail="Access denied")
    
    del records_db[record_id]
    
    return {
        'success': True,
        'message': 'Medical record deleted successfully',
    }


# ==================== PRESCRIPTIONS ====================

@router.post("/prescriptions")
async def create_prescription(
    appointment_id: int,
    medications: list,
    notes: str,
    doctor_id: int = 1,
    patient_id: int = 1,
):
    """Create a prescription"""
    prescription_id = len(prescriptions_db) + 1
    prescription = Prescription(
        id=prescription_id,
        appointment_id=appointment_id,
        doctor_id=doctor_id,
        patient_id=patient_id,  # Would be retrieved from appointment
        medications=medications,
        notes=notes,
        status='active',
    )
    prescriptions_db[prescription_id] = prescription
    
    return {
        'success': True,
        'message': 'Prescription created successfully',
        'prescription': prescription.to_dict(),
    }


@router.get("/prescriptions")
async def get_prescriptions(
    status: Optional[str] = None,
    patient_id: int = 1,
):
    """Get user's prescriptions"""
    prescriptions = [
        prescription.to_dict()
        for prescription in prescriptions_db.values()
        if prescription.patient_id == patient_id
    ]
    
    if status:
        prescriptions = [p for p in prescriptions if p['status'] == status]
    
    return {
        'success': True,
        'prescriptions': sorted(prescriptions, key=lambda x: x['created_at'], reverse=True),
    }


@router.get("/prescriptions/{prescription_id}")
async def get_prescription(prescription_id: int, patient_id: int = 1):
    """Get a specific prescription"""
    prescription = prescriptions_db.get(prescription_id)
    if not prescription:
        raise HTTPException(status_code=404, detail="Prescription not found")
    
    if prescription.patient_id != patient_id:
        raise HTTPException(status_code=403, detail="Access denied")
    
    return {
        'success': True,
        'prescription': prescription.to_dict(),
    }


@router.put("/prescriptions/{prescription_id}")
async def update_prescription(
    prescription_id: int,
    status: Optional[str] = None,
    notes: Optional[str] = None,
    doctor_id: int = 1,
):
    """Update prescription status or notes"""
    prescription = prescriptions_db.get(prescription_id)
    if not prescription:
        raise HTTPException(status_code=404, detail="Prescription not found")
    
    if prescription.doctor_id != doctor_id:
        raise HTTPException(status_code=403, detail="Access denied")
    
    if status:
        valid_statuses = ['active', 'completed', 'cancelled']
        if status not in valid_statuses:
            raise HTTPException(status_code=422, detail=f"Status must be one of {valid_statuses}")
        prescription.status = status
    
    if notes:
        prescription.notes = notes
    
    return {
        'success': True,
        'message': 'Prescription updated successfully',
        'prescription': prescription.to_dict(),
    }


@router.delete("/prescriptions/{prescription_id}")
async def delete_prescription(prescription_id: int, doctor_id: int = 1):
    """Delete a prescription"""
    prescription = prescriptions_db.get(prescription_id)
    if not prescription:
        raise HTTPException(status_code=404, detail="Prescription not found")
    
    if prescription.doctor_id != doctor_id:
        raise HTTPException(status_code=403, detail="Access denied")
    
    del prescriptions_db[prescription_id]
    
    return {
        'success': True,
        'message': 'Prescription deleted successfully',
    }
