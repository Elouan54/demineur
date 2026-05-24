import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../widgets/value_selector.dart';
import '../widgets/xp_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int gridSize = 8;
  int mineCount = 10;

  @override
  Widget build(BuildContext context) {
    int maxMines = (gridSize * gridSize) - 1;

    if (mineCount > maxMines) {
      mineCount = maxMines;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Démineur'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              ValueSelector(
                title: 'Taille de la grille',
                value: gridSize,
                min: 5,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    gridSize = value;
                  });
                },
              ),

              const SizedBox(height: 40),

              ValueSelector(
                title: 'Nombre de bombes',
                value: mineCount,
                min: 1,
                max: maxMines,
                onChanged: (value) {
                  setState(() {
                    mineCount = value;
                  });
                },
              ),

              const SizedBox(height: 60),

              XPButton(
                text: "JOUER",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GameScreen(gridSize: gridSize, mineCount: mineCount),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
