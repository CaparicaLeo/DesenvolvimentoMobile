import 'package:lista3/DEck.dart';

void main(List<String> arguments) {
  Deck baralho = Deck();
  baralho.embaralhar();
  for (int i = 0; i < 5; i++) {
    var carta = baralho.comprar();
    print(carta.toString());
  }
  print('Cartas restantes no baralho: ${baralho.cartasRestantes()}');
}
