import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final TextEditingController searchController;
  final List<String> filterOptions;
  final String? selectedFilter;
  final Function(String) onSearchChanged;
  final Function(String?) onFilterChanged;
  final String hintText;
  final String? filterLabel;

  const SearchFilterWidget({
    Key? key,
    required this.searchController,
    required this.filterOptions,
    this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
    this.hintText = 'Search...',
    this.filterLabel,
  }) : super(key: key);

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: widget.searchController,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        widget.searchController.clear();
                        widget.onSearchChanged('');
                      },
                      child: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        // Filter options
        if (widget.filterOptions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.filterLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.filterLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // All option
                      GestureDetector(
                        onTap: () => widget.onFilterChanged(null),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: widget.selectedFilter == null
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'All',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.selectedFilter == null
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      // Filter options
                      ...widget.filterOptions.map((option) {
                        final isSelected = widget.selectedFilter == option;
                        return GestureDetector(
                          onTap: () => widget.onFilterChanged(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.blue : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
