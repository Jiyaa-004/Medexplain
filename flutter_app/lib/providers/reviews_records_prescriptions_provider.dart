import 'package:flutter/material.dart';
import '../models/reviews_records_prescriptions_model.dart';
import '../services/api_service.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _reviews = [];
  double _averageRating = 0.0;
  int _totalReviews = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Review> get reviews => _reviews;
  double get averageRating => _averageRating;
  int get totalReviews => _totalReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch doctor reviews
  Future<void> fetchDoctorReviews(int doctorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getDoctorReviews(doctorId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch reviews';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final reviewsResponse = DoctorReviewsResponse.fromJson(response);
      _reviews = reviewsResponse.reviews;
      _averageRating = reviewsResponse.averageRating;
      _totalReviews = reviewsResponse.totalReviews;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create review
  Future<bool> createReview({
    required int doctorId,
    required double rating,
    required String title,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createReview(
        doctorId: doctorId,
        rating: rating,
        title: title,
        comment: comment,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to create review';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newReview = Review.fromJson(response['review']);
      _reviews.insert(0, newReview);

      // Recalculate average rating
      if (_reviews.isNotEmpty) {
        _averageRating = _reviews.fold<double>(0, (sum, r) => sum + r.rating) /
            _reviews.length;
        _totalReviews = _reviews.length;
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

  // Update review
  Future<bool> updateReview({
    required int reviewId,
    required double rating,
    required String title,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updateReview(
        reviewId: reviewId,
        rating: rating,
        title: title,
        comment: comment,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to update review';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedReview = Review.fromJson(response['review']);
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        _reviews[index] = updatedReview;
        // Recalculate average rating
        _averageRating = _reviews.fold<double>(0, (sum, r) => sum + r.rating) /
            _reviews.length;
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

  // Delete review
  Future<bool> deleteReview(int reviewId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.deleteReview(reviewId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to delete review';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _reviews.removeWhere((r) => r.id == reviewId);

      // Recalculate average rating
      if (_reviews.isNotEmpty) {
        _averageRating = _reviews.fold<double>(0, (sum, r) => sum + r.rating) /
            _reviews.length;
        _totalReviews = _reviews.length;
      } else {
        _averageRating = 0.0;
        _totalReviews = 0;
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

class MedicalRecordsProvider extends ChangeNotifier {
  List<MedicalRecord> _records = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MedicalRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch medical records
  Future<void> fetchMedicalRecords({String? recordType}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response =
          await ApiService.getMedicalRecords(recordType: recordType);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch records';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _records = (response['records'] as List?)
              ?.map((r) => MedicalRecord.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create medical record
  Future<bool> createMedicalRecord({
    required String title,
    required String description,
    required String recordType,
    String? fileUrl,
    int? doctorId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createMedicalRecord(
        title: title,
        description: description,
        recordType: recordType,
        fileUrl: fileUrl,
        doctorId: doctorId,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to create record';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newRecord = MedicalRecord.fromJson(response['record']);
      _records.insert(0, newRecord);
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

  // Delete medical record
  Future<bool> deleteMedicalRecord(int recordId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.deleteMedicalRecord(recordId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to delete record';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _records.removeWhere((r) => r.id == recordId);
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

class PrescriptionProvider extends ChangeNotifier {
  List<Prescription> _prescriptions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Prescription> get prescriptions => _prescriptions;
  List<Prescription> get activePrescriptions =>
      _prescriptions.where((p) => p.isActive).toList();
  List<Prescription> get completedPrescriptions =>
      _prescriptions.where((p) => p.isCompleted).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch prescriptions
  Future<void> fetchPrescriptions({String? status}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getPrescriptions(status: status);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch prescriptions';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _prescriptions = (response['prescriptions'] as List?)
              ?.map((p) => Prescription.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create prescription
  Future<bool> createPrescription({
    required int appointmentId,
    required List<Medication> medications,
    required String notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createPrescription(
        appointmentId: appointmentId,
        medications: medications.map((m) => m.toJson()).toList(),
        notes: notes,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to create prescription';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newPrescription = Prescription.fromJson(response['prescription']);
      _prescriptions.insert(0, newPrescription);
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

  // Update prescription status
  Future<bool> updatePrescriptionStatus({
    required int prescriptionId,
    required String status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updatePrescription(
        prescriptionId: prescriptionId,
        status: status,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to update prescription';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedPrescription =
          Prescription.fromJson(response['prescription']);
      final index = _prescriptions.indexWhere((p) => p.id == prescriptionId);
      if (index != -1) {
        _prescriptions[index] = updatedPrescription;
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

  // Delete prescription
  Future<bool> deletePrescription(int prescriptionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.deletePrescription(prescriptionId);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to delete prescription';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _prescriptions.removeWhere((p) => p.id == prescriptionId);
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
