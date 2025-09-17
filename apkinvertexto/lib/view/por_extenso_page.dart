import 'package:apkinvertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class PorExtensoPage extends StatefulWidget {
  const PorExtensoPage({super.key});

  @override
  State<PorExtensoPage> createState() => _PorExtensoPageState();
}

class _PorExtensoPageState extends State<PorExtensoPage> {
  final _numeroController = TextEditingController();
  final _apiService = InvertextoService();
  Future<Map<String, dynamic>>? _porExtensoFuture;

  // Variável para guardar a moeda selecionada
  String? _moedaSelecionada;
  String _textoBotaoMoeda = "Sem Moeda";

  // Mapa de moedas disponíveis para o seletor
  final Map<String, String> _moedas = {
    'BRL': 'Real (BRL)',
    'USD': 'Dólar (USD)',
    'EUR': 'Euro (EUR)',
  };

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _converterNumero() {
    final numero = _numeroController.text;

    if (numero.isEmpty) {
      _showErrorSnackBar('O campo não pode estar vazio.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      // Passa a moeda selecionada para o serviço
      _porExtensoFuture =
          _apiService.convertePorExtenso(numero, currency: _moedaSelecionada);
    });
  }

  void _abrirSeletorDeMoeda() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Selecione uma Moeda',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              // Adiciona a opção "Sem Moeda"
              ListTile(
                title: const Text('Nenhuma (apenas o número)',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _moedaSelecionada = null;
                    _textoBotaoMoeda = "Sem Moeda";
                  });
                  Navigator.pop(context);
                },
              ),
              // Mapeia as moedas para a lista de opções
              ..._moedas.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      _moedaSelecionada = entry.key;
                      _textoBotaoMoeda = entry.key;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _numeroController,
                    decoration: const InputDecoration(
                      labelText: 'Digite um número',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 10),
                // Botão para selecionar a moeda
                TextButton(
                  onPressed: _abrirSeletorDeMoeda,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 58) // Alinha altura com TextField
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(_textoBotaoMoeda,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botão principal de conversão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.transform, color: Colors.white),
                label: const Text('Converter por Extenso'),
                onPressed: _converterNumero,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildFutureBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureBuilder() {
    if (_porExtensoFuture == null) {
      return const Center(
        child: Text(
          'Digite um número para converter.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _porExtensoFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 5.0,
              ),
            );
          default:
            if (snapshot.hasError) {
              final error = snapshot.error;
              String errorMessage = "Ocorreu um erro desconhecido.";
              if (error is ApiException) {
                errorMessage = error.message;
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!['extenso'] == null) {
              return const Center(
                child: Text(
                  'Não foi possível converter este número.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              return _buildResultadoWidget(snapshot.data!);
            }
        }
      },
    );
  }

  Widget _buildResultadoWidget(Map<String, dynamic> data) {
    final resultadoPorExtenso = data['extenso'] ?? 'Resultado não encontrado.';

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(
          resultadoPorExtenso,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}