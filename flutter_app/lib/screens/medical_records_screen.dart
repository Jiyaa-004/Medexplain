import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reviews_records_prescriptions_model.dart';
import '../providers/reviews_records_prescriptions_provider.dart';
import '../theme/app_theme.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String? _selectedRecordType;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MedicalRecordsProvider>().fetchMedicalRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 2,
        shadowColor: AppTheme.primaryColor.withOpacity(0.5),
      ),
      body: Consumer<MedicalRecordsProvider>(
        builder: (context, provider, _) {
          final filteredRecords = _selectedRecordType == null
              ? provider.records
              : provider.records
                  .where((r) => r.recordType == _selectedRecordType)
                  .toList();

          return Column(
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'All',
                      selected: _selectedRecordType == null,
                      onTap: () => setState(() => _selectedRecordType = null),
                    ),
                    const SizedBox(width: 10),
                    _buildFilterChip(
                      label: 'Lab Reports',
                      selected: _selectedRecordType == 'lab_report',
                      onTap: () =>
                          setState(() => _selectedRecordType = 'lab_report'),
                    ),
                    const SizedBox(width: 10),
                    _buildFilterChip(
                      label: 'X-Rays',
                      selected: _selectedRecordType == 'x_ray',
                      onTap: () =>
                          setState(() => _selectedRecordType = 'x_ray'),
                    ),
                    const SizedBox(width: 10),
                    _buildFilterChip(
                      label: 'Prescriptions',
                      selected: _selectedRecordType == 'prescription',
                      onTap: () =>
                          setState(() => _selectedRecordType = 'prescription'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    AppTheme.primaryColor),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Loading records...',
                              style: TextStyle(
                                color: AppTheme.lightTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : filteredRecords.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.description_outlined,
                                    size: 56,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'No medical records',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Your medical records will appear here',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: AppTheme.lightTextColor),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddRecordDialog(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Record'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                )
                              ],
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              ...filteredRecords.asMap().entries.map(
                                    (entry) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: _buildRecordCard(
                                          context, entry.value, entry.key),
                                    ),
                                  ),
                            ],
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecordDialog(context),
        backgroundColor: AppTheme.primaryColor,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
                                  style: ElevatedButton.styleFrom(
                                    shape = RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Add Record'),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            padding = const EdgeInsets.all(16),
                            children = [
                              ...filteredRecords.map(
                                (record) => _buildRecordCard(context, record),
                              ),
                            ],
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed = () => _showAddRecordDialog(context),
        backgroundColor = AppTheme.primaryColor,
        child = const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.withOpacity(0.1),
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.textColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: selected ? AppTheme.primaryColor : Colors.grey.withOpacity(0.2),
        width: 1,
      ),
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    MedicalRecord record,
    int index,
  ) {
    IconData typeIcon;
    Color typeColor;

    switch (record.recordType) {
      case 'lab_report':
        typeIcon = Icons.science;
        typeColor = Colors.blue;
        break;
      case 'x_ray':
        typeIcon = Icons.image;
        typeColor = Colors.purple;
        break;
      case 'prescription':
        typeIcon = Icons.medication;
        typeColor = Colors.green;
        break;
      default:
        typeIcon = Icons.description;
        typeColor = Colors.orange;
    }

    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 500 + (index * 100)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.recordTypeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.visibility, size: 18),
                            SizedBox(width: 8),
                            Text('View'),
                          ],
                        ),
                        onTap: () => _showRecordDetails(context, record),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () => _showDeleteConfirmation(context, record.id),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                record.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.lightTextColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: AppTheme.lightTextColor),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(record.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder = (context) => [
                    PopupMenuItem(
                      child: const Text('View'),
                      onTap: () => _showRecordDetails(context, record),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () => _showDeleteConfirmation(context, record.id),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height = 12),
            Text(
              record.description,
              maxLines = 2,
              overflow = TextOverflow.ellipsis,
              style = const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height = 12),
            Row(
              children = [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(record.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRecordDialog(BuildContext context) {
    String recordType = 'general';
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Medical Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  initialValue: recordType,
                  items: const [
                    DropdownMenuItem(
                      value: 'lab_report',
                      child: Text('Lab Report'),
                    ),
                    DropdownMenuItem(
                      value: 'x_ray',
                      child: Text('X-Ray'),
                    ),
                    DropdownMenuItem(
                      value: 'prescription',
                      child: Text('Prescription'),
                    ),
                    DropdownMenuItem(
                      value: 'general',
                      child: Text('General'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => recordType = value ?? 'general'),
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                    ),
                  );
                  return;
                }

                final success = await context
                    .read<MedicalRecordsProvider>()
                    .createMedicalRecord(
                      title: titleController.text,
                      description: descriptionController.text,
                      recordType: recordType,
                    );

                if (!mounted) return;
                Navigator.pop(context);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Record added successfully'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecordDetails(BuildContext context, MedicalRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Type: ${record.recordTypeLabel}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(record.description),
              const SizedBox(height: 12),
              Text(
                'Date: ${_formatDate(record.createdAt)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
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

  void _showDeleteConfirmation(BuildContext context, int recordId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context
                  .read<MedicalRecordsProvider>()
                  .deleteMedicalRecord(recordId);

              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Record deleted successfully'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
