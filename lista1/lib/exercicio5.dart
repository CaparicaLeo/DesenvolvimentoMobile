void execute() {
  int soma = 0;
  for (int i = 1; i <= 500; i++) {
    soma += i % 2 != 0 && i % 3 == 0 ? i : 0;
  }
  print(
    "A soma de todos os numeros de 1 até 500 impares e multiplos de três é: $soma",
  );
}
