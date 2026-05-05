from datetime import datetime
from typing import Optional

class Review:
    """Review model for doctor ratings and feedback"""
    def __init__(
        self,
        id: int,
        doctor_id: int,
        patient_id: int,
        rating: float,
        title: str,
        comment: str,
        created_at: datetime = None,
        updated_at: datetime = None
    ):
        self.id = id
        self.doctor_id = doctor_id
        self.patient_id = patient_id
        self.rating = rating  # 1-5 stars
        self.title = title
        self.comment = comment
        self.created_at = created_at or datetime.now()
        self.updated_at = updated_at or datetime.now()

    def to_dict(self):
        return {
            'id': self.id,
            'doctor_id': self.doctor_id,
            'patient_id': self.patient_id,
            'rating': self.rating,
            'title': self.title,
            'comment': self.comment,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat(),
        }

    @staticmethod
    def from_dict(data):
        return Review(
            id=data.get('id'),
            doctor_id=data.get('doctor_id'),
            patient_id=data.get('patient_id'),
            rating=data.get('rating'),
            title=data.get('title'),
            comment=data.get('comment'),
        )


class MedicalRecord:
    """Medical records and reports model"""
    def __init__(
        self,
        id: int,
        patient_id: int,
        doctor_id: Optional[int],
        title: str,
        description: str,
        record_type: str,  # 'lab_report', 'x_ray', 'prescription', 'general'
        file_url: Optional[str],
        created_at: datetime = None,
    ):
        self.id = id
        self.patient_id = patient_id
        self.doctor_id = doctor_id
        self.title = title
        self.description = description
        self.record_type = record_type
        self.file_url = file_url
        self.created_at = created_at or datetime.now()

    def to_dict(self):
        return {
            'id': self.id,
            'patient_id': self.patient_id,
            'doctor_id': self.doctor_id,
            'title': self.title,
            'description': self.description,
            'record_type': self.record_type,
            'file_url': self.file_url,
            'created_at': self.created_at.isoformat(),
        }

    @staticmethod
    def from_dict(data):
        return MedicalRecord(
            id=data.get('id'),
            patient_id=data.get('patient_id'),
            doctor_id=data.get('doctor_id'),
            title=data.get('title'),
            description=data.get('description'),
            record_type=data.get('record_type'),
            file_url=data.get('file_url'),
        )


class Prescription:
    """Prescription management model"""
    def __init__(
        self,
        id: int,
        appointment_id: int,
        doctor_id: int,
        patient_id: int,
        medications: list,  # [{name, dosage, frequency, duration}]
        notes: str,
        status: str = 'active',  # 'active', 'completed', 'cancelled'
        created_at: datetime = None,
    ):
        self.id = id
        self.appointment_id = appointment_id
        self.doctor_id = doctor_id
        self.patient_id = patient_id
        self.medications = medications
        self.notes = notes
        self.status = status
        self.created_at = created_at or datetime.now()

    def to_dict(self):
        return {
            'id': self.id,
            'appointment_id': self.appointment_id,
            'doctor_id': self.doctor_id,
            'patient_id': self.patient_id,
            'medications': self.medications,
            'notes': self.notes,
            'status': self.status,
            'created_at': self.created_at.isoformat(),
        }

    @staticmethod
    def from_dict(data):
        return Prescription(
            id=data.get('id'),
            appointment_id=data.get('appointment_id'),
            doctor_id=data.get('doctor_id'),
            patient_id=data.get('patient_id'),
            medications=data.get('medications', []),
            notes=data.get('notes'),
            status=data.get('status', 'active'),
        )
