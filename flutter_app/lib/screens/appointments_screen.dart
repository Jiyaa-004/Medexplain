import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<AppointmentProvider>().fetchAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Upcoming appointments
              _buildAppointmentsList(
                appointmentProvider.upcomingAppointments,
                appointmentProvider.isLoading,
                appointmentProvider.error,
                appointmentProvider,
                isUpcoming: true,
              ),
              // Past appointments
              _buildAppointmentsList(
                appointmentProvider.pastAppointments,
                appointmentProvider.isLoading,
                appointmentProvider.error,
                appointmentProvider,
                isUpcoming: false,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsList(
    List<dynamic> appointments,
    bool isLoading,
    String? error,
    AppointmentProvider appointmentProvider, {
    required bool isUpcoming,
  }) {
    if (isLoading && appointments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null && appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today : Icons.history,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No past appointments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return AppointmentCard(
                appointment: appointment,
                onTap: () {
                  // Show appointment details
                  _showAppointmentDetails(context, appointment);
                },
                onCancelTap: isUpcoming
                    ? () => _handleCancelAppointment(
                        context, appointment.id, appointmentProvider)
                    : null,
                onRescheduleTap: isUpcoming
                    ? () => _showRescheduleDialog(
                        context, appointment, appointmentProvider)
                    : null,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, dynamic appointment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Doctor', 'Dr. ${appointment.doctorName}'),
            _buildDetailRow('Specialization', appointment.specialization),
            _buildDetailRow(
              'Date',
              '${appointment.appointmentDate.year}-${appointment.appointmentDate.month.toString().padLeft(2, '0')}-${appointment.appointmentDate.day.toString().padLeft(2, '0')}',
            ),
            _buildDetailRow('Time', appointment.appointmentTime),
            _buildDetailRow(
              'Fee',
              '\$${appointment.fees.toStringAsFixed(2)}',
            ),
            _buildDetailRow('Status', appointment.status.toUpperCase()),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              _buildDetailRow('Notes', appointment.notes!),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCancelAppointment(
    BuildContext context,
    int appointmentId,
    AppointmentProvider appointmentProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await appointmentProvider.cancelAppointment(appointmentId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    dynamic appointment,
    AppointmentProvider appointmentProvider,
  ) {
    // For now, show a placeholder. In a real app, this would open a date/time picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reschedule functionality coming soon.\n\nSelect a new date and time for your appointment.',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Show date picker
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick New Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
