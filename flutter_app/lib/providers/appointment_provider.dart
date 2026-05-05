import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Appointment> get appointments => _appointments;
  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Appointment> get pastAppointments => _pastAppointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all appointments
  Future<void> fetchAppointments({int page = 1, int limit = 20}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getAppointments(
        page: page,
        limit: limit,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch appointments';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final appointmentList = (response['appointments'] as List?)
              ?.map((apt) => Appointment.fromJson(apt as Map<String, dynamic>))
              .toList() ??
          [];

      _appointments = appointmentList;
      _separateAppointments();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Separate upcoming and past appointments
  void _separateAppointments() {
    final now = DateTime.now();
    _upcomingAppointments = _appointments
        .where((apt) => apt.appointmentDate.isAfter(now) && !apt.isCancelled)
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    _pastAppointments = _appointments
        .where((apt) => apt.appointmentDate.isBefore(now) || apt.isCancelled)
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  // Book appointment
  Future<bool> bookAppointment({
    required int doctorId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.bookAppointment(
        doctorId: doctorId,
        date: appointmentDate,
        time: appointmentTime,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to book appointment';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Add new appointment to list
      final newAppointment = Appointment.fromJson(
        response,
      );
      _appointments.add(newAppointment);
      _separateAppointments();
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cancel appointment
  Future<bool> cancelAppointment(int appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.cancelAppointment(appointmentId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to cancel appointment';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update appointment status
      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _appointments[index] =
            _appointments[index].copyWith(status: 'cancelled');
        _separateAppointments();
      }

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reschedule appointment
  Future<bool> rescheduleAppointment({
    required int appointmentId,
    required String newDate,
    required String newTime,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.rescheduleAppointment(
        appointmentId,
        newDate,
        newTime,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to reschedule appointment';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update appointment
      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          appointmentDate: DateTime.parse(newDate),
          appointmentTime: newTime,
        );
        _separateAppointments();
      }

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
