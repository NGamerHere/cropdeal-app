// lib/widgets/custom_dropdown.dart
import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final Widget? prefixIcon;
  final InputDecoration? decoration;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.prefixIcon,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: decoration ?? InputDecoration(
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      dropdownColor: Colors.white,
    );
  }
}