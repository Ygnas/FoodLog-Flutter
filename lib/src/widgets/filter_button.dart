import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  const FilterButton({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        selectDate(context);
      },
      icon: const Icon(Icons.filter_list),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2111));
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.onDateSelected(picked);
      });
    }
  }
}
