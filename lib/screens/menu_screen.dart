import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../widgets/xp_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int gridSize = 8;
  int mineCount = 10;

  String mode = "easy";
  bool isCustom = false;

  void setMode(String newMode) {
    setState(() {
      mode = newMode;

      switch (newMode) {
        case "easy":
          isCustom = false;
          gridSize = 8;
          mineCount = 10;
          break;

        case "medium":
          isCustom = false;
          gridSize = 12;
          mineCount = 25;
          break;

        case "hard":
          isCustom = false;
          gridSize = 16;
          mineCount = 50;
          break;

        case "expert":
          isCustom = false;
          gridSize = 20;
          mineCount = 80;
          break;

        case "custom":
          isCustom = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxMines = (gridSize * gridSize) - 1;

    if (mineCount > maxMines) {
      mineCount = maxMines;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC0C0C0),
      appBar: AppBar(
        title: const Text("Démineur"),
        centerTitle: true,
        backgroundColor: const Color(0xFF000080),
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFC0C0C0),
            border: Border(
              top: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.grey.shade700),
              bottom: BorderSide(color: Colors.grey.shade700),
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "💣 DÉMINEUR",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // =====================
              // DIFFICULTÉS
              // =====================
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _modeButton("Facile", "easy"),
                  _modeButton("Moyen", "medium"),
                  _modeButton("Difficile", "hard"),
                  _modeButton("Expert 💀", "expert"),
                  _modeButton("Custom", "custom"),
                ],
              ),

              const SizedBox(height: 20),

              // =====================
              // SLIDERS CUSTOM
              // =====================
              if (isCustom) ...[
                _xpPanel(
                  child: Column(
                    children: [
                      const Text("Taille de la grille"),
                      Text(
                        "$gridSize x $gridSize",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Slider(
                        value: gridSize.toDouble(),
                        min: 5,
                        max: 25,
                        divisions: 20,
                        label: "$gridSize",
                        onChanged: (value) {
                          setState(() {
                            gridSize = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                _xpPanel(
                  child: Column(
                    children: [
                      const Text("Nombre de bombes"),
                      Text("$mineCount", style: const TextStyle(fontSize: 18)),
                      Slider(
                        value: mineCount.toDouble(),
                        min: 1,
                        max: maxMines.toDouble(),
                        divisions: maxMines,
                        label: "$mineCount",
                        onChanged: (value) {
                          setState(() {
                            mineCount = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],

              const SizedBox(height: 30),

              // =====================
              // START
              // =====================
              XPButton(
                text: "▶ JOUER",
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
            ],
          ),
        ),
      ),
    );
  }

  // =====================
  // MODE BUTTON XP STYLE
  // =====================
  Widget _modeButton(String label, String value) {
    final selected = mode == value;

    return GestureDetector(
      onTap: () => setMode(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFC0C0C0),
          border: Border(
            top: BorderSide(color: selected ? Colors.black : Colors.white),
            left: BorderSide(color: selected ? Colors.black : Colors.white),
            right: BorderSide(color: Colors.grey.shade700),
            bottom: BorderSide(color: Colors.grey.shade700),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  // =====================
  // XP PANEL
  // =====================
  Widget _xpPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0),
        border: Border(
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
          right: BorderSide(color: Colors.grey.shade700),
          bottom: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: child,
    );
  }
}
