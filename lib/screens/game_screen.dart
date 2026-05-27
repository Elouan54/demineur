import 'dart:async';
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
  late Timer timer;

  bool firstClick = true;

  int seconds = 0;
  int flagsPlaced = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void initGame() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
      });
    });

    firstClick = true;

    seconds = 0;
    flagsPlaced = 0;
    gameOver = false;

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

  void resetMines(int safeRow, int safeCol) {
    // reset grille
    for (var row in grid) {
      for (var cell in row) {
        cell.hasMine = false;
        cell.nearbyMines = 0;
      }
    }

    final random = Random();
    int placed = 0;

    while (placed < widget.mineCount) {
      int row = random.nextInt(widget.gridSize);
      int col = random.nextInt(widget.gridSize);

      // interdit sur la case du premier clic
      if ((row == safeRow && col == safeCol) || grid[row][col].hasMine) {
        continue;
      }

      grid[row][col].hasMine = true;
      placed++;
    }

    calculateNumbers();
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
    final cell = grid[row][col];

    if (firstClick) {
      firstClick = false;

      // si mine au premier clic
      if (cell.hasMine) {
        resetMines(row, col);
      }
    }

    if (cell.revealed || cell.flagged || gameOver) return;

    setState(() {
      cell.revealed = true;

      // 💣 Mine touchée
      if (cell.hasMine) {
        revealAllMines();
        gameOver = true;
        showGameOver();
        return;
      }

      // 🔄 propagation des cases vides
      if (cell.nearbyMines == 0) {
        revealEmptyCells(row, col);
      }

      checkWin();
    });
  }

  void revealEmptyCells(int row, int col) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;

        if (newRow < 0 ||
            newRow >= widget.gridSize ||
            newCol < 0 ||
            newCol >= widget.gridSize) {
          continue;
        }

        final neighbor = grid[newRow][newCol];

        if (neighbor.revealed || neighbor.flagged) {
          continue;
        }

        neighbor.revealed = true;

        if (neighbor.nearbyMines == 0 && !neighbor.hasMine) {
          revealEmptyCells(newRow, newCol);
        }
      }
    }
  }

  void revealAllMines() {
    for (var row in grid) {
      for (var cell in row) {
        if (cell.hasMine) {
          cell.revealed = true;
        }
      }
    }
  }

  void checkWin() {
    int revealedCount = 0;

    for (var row in grid) {
      for (var cell in row) {
        if (cell.revealed) {
          revealedCount++;
        }
      }
    }

    int totalSafeCells = (widget.gridSize * widget.gridSize) - widget.mineCount;

    if (revealedCount == totalSafeCells) {
      gameOver = true;
      showWinDialog();
    }
  }

  void showWinDialog() {
    timer.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Victoire 🎉"),
        content: const Text("Tu as gagné !"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                initGame();
              });
            },
            child: const Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  void showGameOver() {
    timer.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: const Text("Tu as touché une mine 💣"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                initGame();
              });
            },
            child: const Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  void toggleFlag(int row, int col) {
    if (gameOver) return;

    setState(() {
      final cell = grid[row][col];

      if (cell.revealed) return;

      cell.flagged = !cell.flagged;

      if (cell.flagged) {
        flagsPlaced++;
      } else {
        flagsPlaced--;
      }
    });
  }

  Widget buildXPDisplay(int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Text(
        value.toString().padLeft(3, '0'),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Démineur'), centerTitle: true),
      body: Column(
        children: [
          // 🪟 Barre XP
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildXPDisplay(widget.mineCount - flagsPlaced),

                GestureDetector(
                  onTap: () {
                    timer.cancel();

                    setState(() {
                      initGame();
                    });
                  },
                  child: const Text("🙂", style: TextStyle(fontSize: 30)),
                ),

                buildXPDisplay(seconds),
              ],
            ),
          ),

          // 🎮 Grille du jeu
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
            ),
          ),
        ],
      ),
    );
  }
}
