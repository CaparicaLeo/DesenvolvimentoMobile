void execute(int a, int b, int c) {
  int soma = a + b;
  print(
    soma >= c
        ? 'A soma de $a + $b é maior ou igual a $c'
        : 'A soma de $a + $b é menor que $c',
  );
}
