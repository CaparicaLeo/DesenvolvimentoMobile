int execute(int numero) {
  return numero <= 1 ? 1 : numero * execute(numero - 1);
}
