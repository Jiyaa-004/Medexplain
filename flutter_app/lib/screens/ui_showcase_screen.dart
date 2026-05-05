import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import '../widgets/animated_stat_card.dart';
import '../widgets/modern_button.dart';
import '../widgets/premium_offer_card.dart';
import '../widgets/enhanced_notification_card.dart';
import '../widgets/modern_profile_header.dart';

/// Showcase screen to display all new UI components
/// This screen demonstrates all the creative UI enhancements
/// To view this, navigate to it from settings or add a route in HomeScreen

class UIShowcaseScreen extends StatefulWidget {
  const UIShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<UIShowcaseScreen> createState() => _UIShowcaseScreenState();
}

class _UIShowcaseScreenState extends State<UIShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components Showcase'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Modern Profile Header
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modern Profile Header',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ModernProfileHeader(
                    name: 'Sarah Anderson',
                    email: 'sarah@medexplain.com',
                    phone: '+1 (555) 123-4567',
                    appointmentCount: 8,
                    rating: 4.9,
                    onEditTap: () => _showMessage('Edit profile'),
                  ),
                ],
              ),
            ),

            // Section 2: Animated Stat Cards
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Animated Stat Cards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedStatCard(
                          title: 'Appointments',
                          value: '12',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedStatCard(
                          title: 'Doctors',
                          value: '8',
                          icon: Icons.person,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedStatCard(
                          title: 'Reviews',
                          value: '24',
                          icon: Icons.star,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section 3: Gradient Cards
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gradient Cards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GradientCard(
                    gradientColors: AppTheme.primaryGradient,
                    onTap: () => _showMessage('Primary Gradient Card tapped'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.health_and_safety,
                            color: Colors.white, size: 32),
                        const SizedBox(height: 12),
                        const Text(
                          'Premium Healthcare',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Get exclusive access to premium doctors',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GradientCard(
                    gradientColors: [
                      Colors.orange[400]!,
                      Colors.red[500]!,
                    ],
                    onTap: () => _showMessage('Accent Gradient Card tapped'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.white, size: 32),
                        const SizedBox(height: 12),
                        const Text(
                          'Hot Offers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Limited time special discounts available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section 4: Modern Buttons
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modern Buttons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ModernButton(
                    text: 'Primary Button',
                    onPressed: () => _showMessage('Primary button pressed'),
                    gradientColors: AppTheme.primaryGradient,
                  ),
                  const SizedBox(height: 12),
                  ModernButton(
                    text: 'Secondary Button',
                    onPressed: () => _showMessage('Secondary button pressed'),
                    gradientColors: [
                      Colors.green[400]!,
                      Colors.green[600]!,
                    ],
                  ),
                  const SizedBox(height: 12),
                  ModernButton(
                    text: 'With Icon',
                    onPressed: () => _showMessage('Icon button pressed'),
                    icon: Icons.check_circle,
                    gradientColors: AppTheme.primaryGradient,
                  ),
                ],
              ),
            ),

            // Section 5: Premium Offer Cards
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Premium Offer Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PremiumOfferCard(
                    title: '50% Off',
                    description: 'Get special discount on first consultation',
                    badgeText: 'Limited Time',
                    gradientColors: const [
                      Color(0xFFFF6B6B),
                      Color(0xFFEE5A6F),
                    ],
                    icon: Icons.local_offer_rounded,
                    buttonText: 'Claim Offer',
                    onTap: () => _showMessage('Offer card tapped'),
                  ),
                  const SizedBox(height: 12),
                  PremiumOfferCard(
                    title: 'Premium Plan',
                    description: 'Unlimited doctor consultations',
                    badgeText: 'New Feature',
                    gradientColors: const [
                      Color(0xFF4ECDC4),
                      Color(0xFF44A08D),
                    ],
                    icon: Icons.star_rounded,
                    buttonText: 'Upgrade Now',
                    onTap: () => _showMessage('Premium plan tapped'),
                  ),
                ],
              ),
            ),

            // Section 6: Enhanced Notification Cards
            Padding(
              padding: const EdgeInsets.only(top: 28, left: 0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Enhanced Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  EnhancedNotificationCard(
                    title: 'Appointment Confirmed',
                    message:
                        'Your appointment with Dr. Smith is confirmed for tomorrow at 2:00 PM',
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    timestamp: '2 minutes ago',
                    isRead: false,
                    onTap: () => _showMessage('Notification tapped'),
                  ),
                  EnhancedNotificationCard(
                    title: 'Prescription Ready',
                    message:
                        'Your prescription has been uploaded to your account',
                    icon: Icons.description,
                    color: Colors.blue,
                    timestamp: '1 hour ago',
                    isRead: true,
                    onTap: () => _showMessage('Notification tapped'),
                  ),
                  EnhancedNotificationCard(
                    title: 'Special Discount',
                    message: 'Get 30% off on your next consultation!',
                    icon: Icons.local_offer,
                    color: Colors.orange,
                    timestamp: '3 hours ago',
                    isRead: true,
                    onTap: () => _showMessage('Notification tapped'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                '✨ All components are fully responsive and animated',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
