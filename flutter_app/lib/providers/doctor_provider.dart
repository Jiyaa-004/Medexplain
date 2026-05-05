import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _error;
  Doctor? _selectedDoctor;
  List<String> _specializations = [];

  // Getters
  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Doctor? get selectedDoctor => _selectedDoctor;
  List<String> get specializations => _specializations;

  // Fetch all doctors
  Future<void> fetchDoctors({String? specialization}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getDoctors(
        specialization: specialization,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch doctors';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final doctorList = (response['doctors'] as List?)
              ?.map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
              .toList() ??
          [];

      _doctors = doctorList;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get doctor by ID
  Future<void> fetchDoctorById(int doctorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getDoctorDetails(doctorId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch doctor details';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _selectedDoctor = Doctor.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch recommended doctors
  Future<void> fetchRecommendedDoctors(List<String> conditions) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getRecommendedDoctors(
        conditions.join(','),
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch recommendations';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final doctorList = (response['doctors'] as List?)
              ?.map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
              .toList() ??
          [];

      _doctors = doctorList;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get specializations (extracted from doctors)
  void extractSpecializations() {
    _specializations = _doctors.map((d) => d.specialization).toSet().toList();
  }

  void setSelectedDoctor(Doctor doctor) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedDoctor() {
    _selectedDoctor = null;
    notifyListeners();
  }
}
