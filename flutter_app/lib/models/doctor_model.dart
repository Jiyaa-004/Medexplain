class Doctor {
  final int id;
  final String name;
  final String specialization;
  final String bio;
  final double rating;
  final int reviewsCount;
  final double consultationFee;
  final String experience;
  final String? imageUrl;
  final List<String> availableDays;
  final List<String> availableTimeSlots;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.rating,
    required this.reviewsCount,
    required this.consultationFee,
    required this.experience,
    this.imageUrl,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.isAvailable,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      bio: json['bio'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 0.0,
      experience: json['experience'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      availableDays: List<String>.from(json['available_days'] as List? ?? []),
      availableTimeSlots:
          List<String>.from(json['available_time_slots'] as List? ?? []),
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialization': specialization,
        'bio': bio,
        'rating': rating,
        'reviews_count': reviewsCount,
        'consultation_fee': consultationFee,
        'experience': experience,
        'image_url': imageUrl,
        'available_days': availableDays,
        'available_time_slots': availableTimeSlots,
        'is_available': isAvailable,
      };

  Doctor copyWith({
    int? id,
    String? name,
    String? specialization,
    String? bio,
    double? rating,
    int? reviewsCount,
    double? consultationFee,
    String? experience,
    String? imageUrl,
    List<String>? availableDays,
    List<String>? availableTimeSlots,
    bool? isAvailable,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      consultationFee: consultationFee ?? this.consultationFee,
      experience: experience ?? this.experience,
      imageUrl: imageUrl ?? this.imageUrl,
      availableDays: availableDays ?? this.availableDays,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class DoctorResponse {
  final List<Doctor> doctors;

  DoctorResponse({required this.doctors});

  factory DoctorResponse.fromJson(Map<String, dynamic> json) {
    var list = (json['doctors'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return DoctorResponse(
      doctors: list.map((e) => Doctor.fromJson(e)).toList(),
    );
  }
}
