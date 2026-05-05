import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type; // appointment, reminder, health_alert, etc.
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data; // Additional data like appointment_id

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
        'data': data,
      };
}

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _unreadNotifications = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  int get unreadCount => _unreadNotifications.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch notifications
  Future<void> fetchNotifications({int page = 1, int limit = 20}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getNotifications(
        page: page,
        limit: limit,
      );

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch notifications';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final notificationList = (response['notifications'] as List?)
              ?.map((notif) =>
                  NotificationModel.fromJson(notif as Map<String, dynamic>))
              .toList() ??
          [];

      _notifications = notificationList;
      _updateUnreadNotifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add local notification (for push notifications)
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _updateUnreadNotifications();
    notifyListeners();
  }

  // Mark as read
  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // Create new instance with isRead = true
      final notification = _notifications[index];
      _notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        isRead: true,
        createdAt: notification.createdAt,
        data: notification.data,
      );
      _updateUnreadNotifications();
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    _notifications = _notifications
        .map((notif) => NotificationModel(
              id: notif.id,
              title: notif.title,
              message: notif.message,
              type: notif.type,
              isRead: true,
              createdAt: notif.createdAt,
              data: notif.data,
            ))
        .toList();
    _updateUnreadNotifications();
    notifyListeners();
  }

  // Clear notification
  void clearNotification(int notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadNotifications();
    notifyListeners();
  }

  // Update unread notifications
  void _updateUnreadNotifications() {
    _unreadNotifications = _notifications.where((n) => !n.isRead).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
