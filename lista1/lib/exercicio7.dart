void execute(int numero) {
  List<int> tabuada = [];
  for (int i = 1; i <= 10; i++) {
    tabuada.add(numero * i);
  }
  print("Tabuada do numero $numero");
  for (int i = 1; i <= 10; i++) {
    print('$numero X $i = ${tabuada.elementAt(i-1)}');
  }
}
