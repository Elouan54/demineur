import 'package:flutter/material.dart';

class ValueSelector extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const ValueSelector({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        Text(
          '$value',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),

        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          label: '$value',
          onChanged: (newValue) {
            onChanged(newValue.toInt());
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle),
            ),

            const SizedBox(width: 20),

            IconButton(
              iconSize: 40,
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
      ],
    );
  }
}
