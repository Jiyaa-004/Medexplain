class Appointment {
  final int id;
  final int doctorId;
  final String doctorName;
  final String specialization;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status; // scheduled, completed, cancelled, rescheduled
  final double fees;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.fees,
    this.notes,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      doctorName: json['doctor_name'] as String? ?? 'Unknown',
      specialization: json['specialization'] as String? ?? 'General',
      appointmentDate: json['appointment_date'] is String
          ? DateTime.parse(json['appointment_date'] as String)
          : DateTime.now(),
      appointmentTime: json['appointment_time'] as String? ?? '10:00',
      status: json['status'] as String? ?? 'scheduled',
      fees: (json['fees'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'specialization': specialization,
        'appointment_date': appointmentDate.toIso8601String(),
        'appointment_time': appointmentTime,
        'status': status,
        'fees': fees,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  Appointment copyWith({
    int? id,
    int? doctorId,
    String? doctorName,
    String? specialization,
    DateTime? appointmentDate,
    String? appointmentTime,
    String? status,
    double? fees,
    String? notes,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      fees: fees ?? this.fees,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isPast {
    return appointmentDate.isBefore(DateTime.now());
  }

  bool get isCompleted {
    return status == 'completed';
  }

  bool get isCancelled {
    return status == 'cancelled';
  }

  bool get isUpcoming {
    return !isPast && !isCancelled;
  }
}

class AppointmentResponse {
  final List<Appointment> appointments;

  AppointmentResponse({required this.appointments});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    var list =
        (json['appointments'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return AppointmentResponse(
      appointments: list.map((e) => Appointment.fromJson(e)).toList(),
    );
  }
}

class BookAppointmentRequest {
  final int doctorId;
  final String appointmentDate;
  final String appointmentTime;

  BookAppointmentRequest({
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  Map<String, dynamic> toJson() => {
        'doctor_id': doctorId,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
      };
}
