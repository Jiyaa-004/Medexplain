import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../widgets/doctor_card.dart';
import '../widgets/search_filter_widget.dart';
import 'doctor_detail_screen.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final searchController = TextEditingController();
  String? selectedSpecialization;
  List<String> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final doctorProvider = context.read<DoctorProvider>();
      doctorProvider.fetchDoctors();
    });
    searchController.addListener(_filterDoctors);
  }

  void _filterDoctors() {
    // Filtering logic would be implemented in real scenario
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors'),
        elevation: 0,
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, doctorProvider, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search and filter
                SearchFilterWidget(
                  searchController: searchController,
                  filterOptions: doctorProvider.specializations,
                  selectedFilter: selectedSpecialization,
                  onSearchChanged: (value) {
                    setState(() {});
                  },
                  onFilterChanged: (spec) {
                    setState(() {
                      selectedSpecialization = spec;
                    });
                    if (spec != null) {
                      doctorProvider.fetchDoctors(specialization: spec);
                    } else {
                      doctorProvider.fetchDoctors();
                    }
                  },
                  hintText: 'Search doctors...',
                  filterLabel: 'Specialization',
                ),
                const SizedBox(height: 16),
                // Error handling
                if (doctorProvider.error != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            doctorProvider.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Loading state
                if (doctorProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                // Doctors list
                if (!doctorProvider.isLoading && doctorProvider.doctors.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No doctors found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!doctorProvider.isLoading)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctorProvider.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorProvider.doctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          doctorProvider.setSelectedDoctor(doctor);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailScreen(doctor: doctor),
                            ),
                          );
                        },
                        onBookTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailScreen(doctor: doctor),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
