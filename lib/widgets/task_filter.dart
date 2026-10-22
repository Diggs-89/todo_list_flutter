import 'package:flutter/material.dart';

class TaskFilter extends StatelessWidget{
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const TaskFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),

      child: Row(
        children: [
          Expanded(child: _buildChip('all', 'Todas')),
          const SizedBox(width: 8),
          Expanded(child: _buildChip('pending', 'Pendentes')),
          const SizedBox(width: 8),
          Expanded(child: _buildChip('completed', 'Concluidas')),
        ],
      ),
    );
  }

  Widget _buildChip(String value, String label){
    final IsSelected = selectedFilter == value;

    return FilterChip(
      selected: IsSelected,
      label: Center(child: Text(label)),
      showCheckmark: false,
      onSelected: (_) => onChanged(value) ,
     ); 
  } 
}