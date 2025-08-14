void execute() {
  List<int> numeros = [0];
  for (int i = 100; i <= 200; i++) {
    numeros.add(i % 2 != 0 ? i : 0);
  }

  numeros.removeWhere((n) => n == 0);

  print('Os numeros impares entre o intervalo de [100,200] é: $numeros');
}
