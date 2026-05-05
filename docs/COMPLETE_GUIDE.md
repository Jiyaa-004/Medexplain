# 📱 MedExplain Mobile - Complete Setup Guide

## Project Overview

Complete healthcare mobile app with:
- ✅ Beautiful Modern UI
- ✅ User Authentication
- ✅ Medical Report Analysis
- ✅ Doctor Recommendations
- ✅ Appointment Booking with Calendar
- ✅ Push Notifications
- ✅ Appointment Reminders
- ✅ Complete Backend API

## Features Implemented

### 1. Authentication
- Login/Signup
- JWT Token Management

### 2. Doctor Module
- View all doctors
- Get recommendations based on analysis
- View doctor profiles
- Book appointments

### 3. Appointments
- Booking system
- Calendar integration
- Date & time selection
- Appointment confirmation

### 4. Notifications
- Push notifications
- Appointment reminders
- Real-time updates

### 5. Dashboard
- Health score display
- Recent reports
- Quick access to features

## Backend API Endpoints

### Authentication
- POST /api/v1/auth/signup
- POST /api/v1/auth/login

### Doctors
- GET /api/v1/doctors
- GET /api/v1/doctors/{id}
- GET /api/v1/doctors/recommendations?conditions=...
- GET /api/v1/specializations

### Appointments
- POST /api/v1/appointments/book
- GET /api/v1/appointments
- GET /api/v1/appointments/{id}
- PUT /api/v1/appointments/{id}/reschedule
- DELETE /api/v1/appointments/{id}
- GET /api/v1/appointments/{id}/reminder

### Notifications
- POST /api/v1/notifications/register-device
- GET /api/v1/notifications
- POST /api/v1/notifications/send
- PUT /api/v1/notifications/{id}/read
- POST /api/v1/notifications/appointment-reminder
- POST /api/v1/notifications/schedule-reminder

## Setup Instructions

See SETUP_GUIDE.md for complete setup instructions.

---

Made with ❤️ for Healthcare
