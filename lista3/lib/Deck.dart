import 'package:lista3/Card.dart';
import 'dart:math';

class Deck {
  Deck() {
    for (var value in Values.values) {
      for (var suit in Suits.values) {
        cards.add(Card(value: value, suit: suit));
      }
    }
  }

  final List<Card> cards = [];

  void embaralhar() {
    cards.shuffle(Random());
  }

  Card comprar() {
    if (cards.isEmpty) {
      throw StateError("O baralho está vazio!");
    }
    return cards.removeLast();
  }

  int cartasRestantes() => cards.length;

  @override
  String toString() => cards.toString();
}
