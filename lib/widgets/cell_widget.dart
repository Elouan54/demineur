import 'package:flutter/material.dart';
import '../models/cell.dart';

class CellWidget extends StatelessWidget {
  final Cell cell;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    this.onLongPress,
  });

  Color _numberColor(int n) {
    switch (n) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: cell.revealed
              ? const Color(0xFFC0C0C0)
              : const Color(0xFFE4E4E4),

          // 👇 effet 3D Windows XP
          border: Border(
            top: BorderSide(color: Colors.white, width: cell.revealed ? 1 : 2),
            left: BorderSide(color: Colors.white, width: cell.revealed ? 1 : 2),
            right: BorderSide(color: Colors.grey.shade700, width: 1),
            bottom: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
        ),
        child: Center(child: buildContent()),
      ),
    );
  }

  Widget buildContent() {
    if (cell.flagged && !cell.revealed) {
      return const Text("🚩", style: TextStyle(fontSize: 18));
    }

    if (!cell.revealed) {
      return const SizedBox();
    }

    if (cell.hasMine) {
      return const Text(
        "💣",
        style: TextStyle(fontSize: 18, color: Colors.black),
      );
    }

    if (cell.nearbyMines > 0) {
      return Text(
        "${cell.nearbyMines}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: _numberColor(cell.nearbyMines),
        ),
      );
    }

    return const SizedBox();
  }
}
