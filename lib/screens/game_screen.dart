import 'dart:math';

import 'package:flutter/material.dart';
import '../models/cell.dart';
import '../widgets/cell_widget.dart';

class GameScreen extends StatefulWidget {
  final int gridSize;
  final int mineCount;

  const GameScreen({
    super.key,
    required this.gridSize,
    required this.mineCount,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<Cell>> grid;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    grid = List.generate(
      widget.gridSize,
      (_) => List.generate(widget.gridSize, (_) => Cell()),
    );

    placeMines();
    calculateNumbers();
  }

  void placeMines() {
    final random = Random();
    int placed = 0;

    while (placed < widget.mineCount) {
      int row = random.nextInt(widget.gridSize);
      int col = random.nextInt(widget.gridSize);

      if (!grid[row][col].hasMine) {
        grid[row][col].hasMine = true;
        placed++;
      }
    }
  }

  void calculateNumbers() {
    for (int row = 0; row < widget.gridSize; row++) {
      for (int col = 0; col < widget.gridSize; col++) {
        if (grid[row][col].hasMine) continue;

        int count = 0;

        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int newRow = row + i;
            int newCol = col + j;

            if (newRow >= 0 &&
                newRow < widget.gridSize &&
                newCol >= 0 &&
                newCol < widget.gridSize &&
                grid[newRow][newCol].hasMine) {
              count++;
            }
          }
        }

        grid[row][col].nearbyMines = count;
      }
    }
  }

  void revealCell(int row, int col) {
    if (grid[row][col].flagged) return;
    setState(() {
      grid[row][col].revealed = true;

      if (grid[row][col].hasMine) {
        showGameOver();
      }
    });
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('Tu as touché une mine 💣'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                initGame();
              });
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  void toggleFlag(int row, int col) {
    setState(() {
      final cell = grid[row][col];

      if (cell.revealed) return; // impossible de flag une case déjà ouverte

      cell.flagged = !cell.flagged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Démineur'), centerTitle: true),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: widget.gridSize * widget.gridSize,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.gridSize,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ widget.gridSize;
            int col = index % widget.gridSize;

            return CellWidget(
              cell: grid[row][col],
              onTap: () => revealCell(row, col),
              onLongPress: () => toggleFlag(row, col),
            );
          },
        ),
      ),
    );
  }
}
