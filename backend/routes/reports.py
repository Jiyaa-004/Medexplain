from fastapi import APIRouter, UploadFile, File, HTTPException
import uuid

router = APIRouter()

@router.post('/reports/upload')
async def upload_report(file: UploadFile = File(...)):
    if not file.filename.endswith(('.png', '.jpg', '.jpeg', '.pdf')):
        raise HTTPException(status_code=400, detail='Invalid file type')
    
    report_id = str(uuid.uuid4())
    
    return {
        'success': True,
        'report_id': report_id,
        'filename': file.filename,
        'message': 'Report uploaded successfully'
    }

@router.get('/reports')
async def get_reports():
    return {
        'reports': [
            {'id': 1, 'name': 'Blood Test', 'date': '2024-05-01', 'status': 'completed'}
        ]
    }

@router.get('/reports/{report_id}')
async def get_report(report_id: str):
    return {
        'id': report_id,
        'name': 'Blood Test',
        'date': '2024-05-01',
        'status': 'completed'
    }
