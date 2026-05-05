import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'doctors_list_screen.dart';
import 'appointments_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late List<Animation<double>> _scaleAnimations;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DoctorsListScreen(),
    const AppointmentsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home', 'color': Color(0xFF6366F1)},
    {
      'icon': Icons.medical_services_outlined,
      'label': 'Doctors',
      'color': Color(0xFF8B5CF6)
    },
    {
      'icon': Icons.calendar_today_rounded,
      'label': 'Appointments',
      'color': Color(0xFF06B6D4)
    },
    {
      'icon': Icons.notifications_rounded,
      'label': 'Notifications',
      'color': Color(0xFFF59E0B)
    },
    {
      'icon': Icons.person_rounded,
      'label': 'Profile',
      'color': Color(0xFF10B981)
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimations = List.generate(
      _navItems.length,
      (index) => Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 0,
          notchMargin: 8,
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;
    final color = item['color'] as Color;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: isSelected
                    ? _scaleAnimations[index]
                    : const AlwaysStoppedAnimation(1.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              color,
                              color.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.white : AppTheme.lightTextColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: isSelected ? color : AppTheme.lightTextColor,
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                child: Text(item['label'] as String),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
