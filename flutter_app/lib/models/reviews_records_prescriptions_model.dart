class Review {
  final int id;
  final int doctorId;
  final int patientId;
  final double rating;
  final String title;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.rating,
    required this.title,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'rating': rating,
      'title': title,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Review copyWith({
    int? id,
    int? doctorId,
    int? patientId,
    double? rating,
    String? title,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DoctorReviewsResponse {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;

  DoctorReviewsResponse({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  factory DoctorReviewsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorReviewsResponse(
      reviews: (json['reviews'] as List?)
              ?.map((r) => Review.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
    );
  }
}

class MedicalRecord {
  final int id;
  final int patientId;
  final int? doctorId;
  final String title;
  final String description;
  final String recordType; // 'lab_report', 'x_ray', 'prescription', 'general'
  final String? fileUrl;
  final DateTime createdAt;

  MedicalRecord({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.title,
    required this.description,
    required this.recordType,
    this.fileUrl,
    required this.createdAt,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      doctorId: json['doctor_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      recordType: json['record_type'] as String,
      fileUrl: json['file_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'title': title,
      'description': description,
      'record_type': recordType,
      'file_url': fileUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get recordTypeLabel {
    switch (recordType) {
      case 'lab_report':
        return 'Lab Report';
      case 'x_ray':
        return 'X-Ray';
      case 'prescription':
        return 'Prescription';
      default:
        return 'General Record';
    }
  }
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      duration: json['duration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
    };
  }
}

class Prescription {
  final int id;
  final int appointmentId;
  final int doctorId;
  final int patientId;
  final List<Medication> medications;
  final String notes;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;

  Prescription({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.medications,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as int,
      appointmentId: json['appointment_id'] as int,
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      medications: (json['medications'] as List?)
              ?.map((m) => Medication.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'medications': medications.map((m) => m.toJson()).toList(),
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  String get statusLabel {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Active';
    }
  }
}
