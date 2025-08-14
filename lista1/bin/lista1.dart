import 'package:lista1/exercicio1.dart' as exercicio1;
import 'package:lista1/exercicio2.dart' as exercicio2;
import 'package:lista1/exercicio3.dart' as exercicio3;
import 'package:lista1/exercicio4.dart' as exercicio4;

void main(List<String> arguments) {
  print('Exercicio 1 :');
  exercicio1.execute(2, 3, 6);
  quebralinha();
  print('Exercicio 2: ');
  exercicio2.execute(5);
  quebralinha();
  print('Exercicio 3: ');
  exercicio3.execute(3, 2);
  quebralinha();
  print("Exercicio 4: ");
  exercicio4.execute([7, 5, 6]);
  quebralinha();
}

void quebralinha() => print('\n');
