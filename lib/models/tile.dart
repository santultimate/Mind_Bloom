enum TileType {
  flower,
  leaf,
  crystal,
  seed,
  dew,
  sun,
  moon,
  gem,
}

enum TileState {
  normal,
  selected,
  matched,
  special,
  blocked,
  swapping,
}

class Tile {
  final int id;
  TileType type;
  int row;
  int col;
  TileState state;
  bool isSpecial;
  bool isBlocked;

  Tile({
    required this.id,
    required this.type,
    required this.row,
    required this.col,
    this.state = TileState.normal,
    this.isSpecial = false,
    this.isBlocked = false,
  });

  // Créer une tuile spéciale
  Tile.special({
    required this.id,
    required this.type,
    required this.row,
    required this.col,
  })  : state = TileState.special,
        isSpecial = true,
        isBlocked = false;

  // Copier une tuile
  Tile copyWith({
    int? id,
    TileType? type,
    int? row,
    int? col,
    TileState? state,
    bool? isSpecial,
    bool? isBlocked,
  }) {
    return Tile(
      id: id ?? this.id,
      type: type ?? this.type,
      row: row ?? this.row,
      col: col ?? this.col,
      state: state ?? this.state,
      isSpecial: isSpecial ?? this.isSpecial,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  // Vérifier si deux tuiles sont du même type
  bool isSameType(Tile other) {
    return type == other.type;
  }

  // Vérifier si la tuile est adjacente à une autre
  bool isAdjacent(Tile other) {
    return (row == other.row &&
            (col == other.col - 1 || col == other.col + 1)) ||
        (col == other.col && (row == other.row - 1 || row == other.row + 1));
  }

  // Obtenir la couleur de la tuile
  int get color {
    switch (type) {
      case TileType.flower:
        return 0xFFFF6FA3;
      case TileType.leaf:
        return 0xFF48BB78;
      case TileType.crystal:
        return 0xFF4299E1;
      case TileType.seed:
        return 0xFF8B4513;
      case TileType.dew:
        return 0xFF00CED1;
      case TileType.sun:
        return 0xFFFFD700;
      case TileType.moon:
        return 0xFF9370DB;
      case TileType.gem:
        return 0xFF6CC6B6;
    }
  }

  // Obtenir le nom de la tuile
  String get name {
    switch (type) {
      case TileType.flower:
        return 'Fleur';
      case TileType.leaf:
        return 'Feuille';
      case TileType.crystal:
        return 'Cristal';
      case TileType.seed:
        return 'Graine';
      case TileType.dew:
        return 'Rosée';
      case TileType.sun:
        return 'Soleil';
      case TileType.moon:
        return 'Lune';
      case TileType.gem:
        return 'Gemme';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Tile(id: $id, type: $type, row: $row, col: $col, state: $state)';
  }
}
