class Card {
  Card({required this.value, required this.suit});

  final Values value;
  final Suits suit;

  @override
  String toString() {
    return '${value.name} of ${suit.name}';
  }
}

enum Suits { spades, hearts, diamonds, golds }

enum Values {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  valentine,
  queen,
  king,
}
