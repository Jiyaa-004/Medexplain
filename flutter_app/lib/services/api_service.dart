import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class ApiService {
  // Default base URL - CHANGE THIS TO YOUR DEVELOPMENT MACHINE IP
  // Replace 'localhost' with your machine's IP address (e.g., http://192.168.x.x:8000/api/v1)
  static String baseUrl = 'http://localhost:8000/api/v1';
  static const Duration timeout = Duration(seconds: 30);

  static String? _accessToken;

  /// Set the base URL dynamically for different environments
  /// Usage: ApiService.setBaseUrl('http://192.168.x.x:8000/api/v1')
  static void setBaseUrl(String url) {
    baseUrl = url;
    print('[ApiService] Base URL changed to: $url');
  }

  /// Get the current base URL
  static String getBaseUrl() => baseUrl;

  // Set access token
  static void setAccessToken(String? token) {
    _accessToken = token;
  }

  // Get headers with authorization
  static Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // Handle response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          ...jsonDecode(response.body),
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Unauthorized. Please login again.',
          'statusCode': 401,
        };
      } else if (response.statusCode == 422) {
        final body = jsonDecode(response.body);
        return {
          'success': false,
          'error': body['detail'] ?? 'Invalid request data',
          'statusCode': 422,
        };
      } else if (response.statusCode >= 500) {
        return {
          'success': false,
          'error': 'Server error. Please try again later.',
          'statusCode': response.statusCode,
        };
      } else {
        final body = jsonDecode(response.body);
        return {
          'success': false,
          'error': body['detail'] ?? 'Request failed',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error parsing response: $e',
        'statusCode': response.statusCode,
      };
    }
  }

  // Handle exceptions
  static Map<String, dynamic> _handleException(dynamic e) {
    String error = 'Unknown error occurred';

    if (e is SocketException) {
      error = 'Network error. Please check your connection.';
    } else if (e is TimeoutException || e is http.ClientException) {
      error = 'Request timeout. Please try again.';
    } else if (e is FormatException) {
      error = 'Invalid response format.';
    } else {
      error = e.toString();
    }

    return {
      'success': false,
      'error': error,
    };
  }

  // AUTH ENDPOINTS

  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> refreshAccessToken(
      String refreshToken) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // DOCTORS ENDPOINTS

  static Future<Map<String, dynamic>> getRecommendedDoctors(
      String conditions) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/doctors/recommendations')
                .replace(queryParameters: {'conditions': conditions}),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> getDoctorDetails(int doctorId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/doctors/$doctorId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> getDoctors({
    String? specialization,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (specialization != null) {
        queryParams['specialization'] = specialization;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/doctors').replace(queryParameters: queryParams),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // APPOINTMENTS ENDPOINTS

  static Future<Map<String, dynamic>> bookAppointment({
    required int doctorId,
    required String date,
    required String time,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/appointments/book'),
            headers: _getHeaders(),
            body: jsonEncode({
              'doctor_id': doctorId,
              'appointment_date': date,
              'appointment_time': time,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> getAppointments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/appointments').replace(queryParameters: {
              'page': page.toString(),
              'limit': limit.toString(),
            }),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> getAppointmentDetails(
      int appointmentId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/appointments/$appointmentId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> rescheduleAppointment(
    int appointmentId,
    String newDate,
    String newTime,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/appointments/$appointmentId/reschedule'),
            headers: _getHeaders(),
            body: jsonEncode({
              'new_date': newDate,
              'new_time': newTime,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> cancelAppointment(
      int appointmentId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/appointments/$appointmentId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // NOTIFICATIONS ENDPOINTS

  static Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/notifications').replace(queryParameters: {
              'page': page.toString(),
              'limit': limit.toString(),
            }),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> registerDeviceToken(String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/notifications/register'),
            headers: _getHeaders(),
            body: jsonEncode({'device_token': token}),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // REPORTS ENDPOINTS

  static Future<Map<String, dynamic>> uploadReport(
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/reports/upload'),
      );

      request.headers.addAll(_getHeaders());
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      final response = await request.send().timeout(timeout);
      final responseBody = await response.stream.bytesToString();

      final httpResponse = http.Response(
        responseBody,
        response.statusCode,
        headers: response.headers,
      );

      return _handleResponse(httpResponse);
    } catch (e) {
      return _handleException(e);
    }
  }

  // USERS ENDPOINTS

  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users/profile'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // REVIEWS ENDPOINTS

  static Future<Map<String, dynamic>> getDoctorReviews(int doctorId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/doctors/$doctorId/reviews'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> createReview({
    required int doctorId,
    required double rating,
    required String title,
    required String comment,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/reviews'),
            headers: _getHeaders(),
            body: jsonEncode({
              'doctor_id': doctorId,
              'rating': rating,
              'title': title,
              'comment': comment,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> updateReview({
    required int reviewId,
    required double rating,
    required String title,
    required String comment,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/reviews/$reviewId'),
            headers: _getHeaders(),
            body: jsonEncode({
              'rating': rating,
              'title': title,
              'comment': comment,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> deleteReview(int reviewId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/reviews/$reviewId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // MEDICAL RECORDS ENDPOINTS

  static Future<Map<String, dynamic>> getMedicalRecords({
    String? recordType,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (recordType != null) {
        queryParams['record_type'] = recordType;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/medical-records')
                .replace(queryParameters: queryParams),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> createMedicalRecord({
    required String title,
    required String description,
    required String recordType,
    String? fileUrl,
    int? doctorId,
  }) async {
    try {
      final body = {
        'title': title,
        'description': description,
        'record_type': recordType,
      };

      if (fileUrl != null) {
        body['file_url'] = fileUrl;
      }

      if (doctorId != null) {
        body['doctor_id'] = doctorId.toString();
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/medical-records'),
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> deleteMedicalRecord(int recordId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/medical-records/$recordId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // PRESCRIPTIONS ENDPOINTS

  static Future<Map<String, dynamic>> getPrescriptions({
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/prescriptions')
                .replace(queryParameters: queryParams),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> createPrescription({
    required int appointmentId,
    required List<dynamic> medications,
    required String notes,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/prescriptions'),
            headers: _getHeaders(),
            body: jsonEncode({
              'appointment_id': appointmentId,
              'medications': medications,
              'notes': notes,
            }),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> updatePrescription({
    required int prescriptionId,
    String? status,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) {
        body['status'] = status;
      }
      if (notes != null) {
        body['notes'] = notes;
      }

      final response = await http
          .put(
            Uri.parse('$baseUrl/prescriptions/$prescriptionId'),
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> deletePrescription(
      int prescriptionId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/prescriptions/$prescriptionId'),
            headers: _getHeaders(),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/users/profile'),
            headers: _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // CHAT ENDPOINTS

  static Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/chat/send'),
            headers: _getHeaders(),
            body: jsonEncode({'message': message}),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  // ANALYSIS ENDPOINTS

  static Future<Map<String, dynamic>> analyzeSymptoms(
      List<String> symptoms) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/analysis/symptoms'),
            headers: _getHeaders(),
            body: jsonEncode({'symptoms': symptoms}),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }
}
