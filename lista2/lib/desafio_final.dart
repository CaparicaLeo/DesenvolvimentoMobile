void execute() {
  print('DESAFIO FINAL');

  print('Pessoas: ');
  for (PessoasIdade pessoa in PessoasIdade.values) {
    print(pessoa.nome);
  }
  print('Pessoas Maiores de idade: ');
  for (PessoasIdade pessoa in PessoasIdade.values) {
    if(pessoa.idade >= 18){
      print(pessoa.nome);
    }
  }
}

enum PessoasIdade {
  carlos('Carlos', 29),
  leo('Leo', 19),
  gustavo('Gustavo', 8),
  maite('Maite', 11),
  sophia('Sophia', 17),
  joao('Joao', 18);

  final String nome;
  final int idade;

  const PessoasIdade(this.nome, this.idade);
}
