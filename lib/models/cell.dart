class Cell {
  bool hasMine;
  bool revealed;
  bool flagged;
  int nearbyMines;

  Cell({
    this.hasMine = false,
    this.revealed = false,
    this.flagged = false,
    this.nearbyMines = 0,
  });
}
