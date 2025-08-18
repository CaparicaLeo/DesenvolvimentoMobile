import 'dart:math';

void execute() {
  List<String> frutas = ['abacaxi', 'banana', 'maçã', 'abacate', 'morango'];
  print("Exercicio 1: $frutas");
  print('Exercicio 2: ${frutas[2]}');
  frutas.add('laranja');
  print('Exercicio 3 (adicionando laranja): $frutas');
  frutas.remove('maça');
  print('Exercicio 3 (removendo maça): $frutas');
  print('Exercicio 4: ');
  for (int i = 0; i < frutas.length; i++) {
    print(frutas[i].toUpperCase());
  }
  print("Exercicio 5");
  // ignore: avoid_function_literals_in_foreach_calls
  frutas.forEach((fruta) {
    print(fruta.toUpperCase());
  });

  print('Exercicio 6:');
  List<String> frutasA = [];
  for (String fruta in frutas) {
    if (fruta[0] == 'a' || fruta[0] == 'A') {
      frutasA.add(fruta);
    }
  }
  print(frutasA);

  print('Exercicio 7: ');
  Map<String, double> precosFrutas = {};

  for (String fruta in frutas) {
    Random random = Random();

    double min = 2;
    double max = 20;

    precosFrutas[fruta] = ((min + random.nextDouble() * (max - min)) * 100).round() / 100;
  }
  print(precosFrutas);

  print('Exercicio 8: ');
  for (String fruta in frutas) {
    print('A fruta $fruta custa ${precosFrutas[fruta]}');
  }

  exercicio9();
}

void exercicio9() {
  print('Exercicio 9: ');
  List<int> numeros = [9, 8, 0, 3, 4, 7];

  // Função anônima que recebe uma lista e retorna outra lista
  // ignore: prefer_function_declarations_over_variables
  List<int> Function(List<int>) filtrarPares = (List<int> lista) {
    return lista.where((n) => n % 2 == 0).toList();
  };

  List<int> pares = filtrarPares(numeros);

  print("Originais: $numeros");
  print("Pares: $pares");
}
