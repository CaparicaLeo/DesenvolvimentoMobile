import 'package:apkinvertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/image.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o CEP",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.buscaCEP(campo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao buscar os dados. ${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String enderecoCompleto = '';
    if (snapshot.data != null) {
      enderecoCompleto += snapshot.data["street"] ?? "Rua não disponivel";
      enderecoCompleto += snapshot.data["\n"];
      enderecoCompleto += snapshot.data["neighborhood"] ?? "Bairro não disponivel";
      enderecoCompleto += snapshot.data["\n"];
      enderecoCompleto += snapshot.data["city"] ?? "Cidade não disponivel";
      enderecoCompleto += snapshot.data["\n"];
      enderecoCompleto += snapshot.data["state"] ?? "State não disponivel";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        enderecoCompleto,
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
