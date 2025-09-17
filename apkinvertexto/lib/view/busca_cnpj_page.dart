import 'package:apkinvertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCNPJPage extends StatefulWidget {
  const BuscaCNPJPage({super.key});

  @override
  State<BuscaCNPJPage> createState() => _BuscaCNPJPageState();
}

class _BuscaCNPJPageState extends State<BuscaCNPJPage> {
  final _cnpjController = TextEditingController();
  final _apiService = InvertextoService();
  Future<Map<String, dynamic>>? _cnpjFuture;

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _buscarCNPJ() {
    final cnpjLimpo = _cnpjController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cnpjLimpo.isEmpty) {
      _showErrorSnackBar('O campo CNPJ não pode estar vazio.');
      return;
    }
    if (cnpjLimpo.length != 14) {
      _showErrorSnackBar('CNPJ inválido. Um CNPJ deve conter 14 dígitos.');
      return;
    }
    
    FocusScope.of(context).unfocus();

    setState(() {
      _cnpjFuture = _apiService.buscaCNPJ(cnpjLimpo);
    });
  }

  @override
  void dispose() {
    _cnpjController.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cnpjController,
                    decoration: const InputDecoration(
                      labelText: "Digite o CNPJ",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    onSubmitted: (_) => _buscarCNPJ(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 30),
                  onPressed: _buscarCNPJ,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
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
    // ... (código já mostrado acima, com o tratamento de erro)
    if (_cnpjFuture == null) {
      return const Center(
        child: Text(
          'Digite um CNPJ e pressione buscar.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _cnpjFuture,
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
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum dado encontrado para este CNPJ.',
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
    // ... (widget de resultado continua o mesmo)
    Widget infoTile(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }

    final endereco = data['endereco'];
    final enderecoCompleto =
        '${endereco['logradouro'] ?? ''}, ${endereco['numero'] ?? 'S/N'}\n'
        '${endereco['bairro'] ?? ''} - ${endereco['municipio'] ?? ''}/${endereco['uf'] ?? ''}\n'
        'CEP: ${endereco['cep'] ?? ''}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          infoTile('Razão Social', data['razao_social'] ?? 'Não informado'),
          infoTile('Nome Fantasia', data['nome_fantasia'] ?? 'Não informado'),
          const Divider(color: Colors.white24),
          infoTile('CNPJ', data['cnpj'] ?? 'Não informado'),
          infoTile('Situação', data['situacao']?['nome'] ?? 'Não informado'),
          const Divider(color: Colors.white24),
          infoTile('Endereço', enderecoCompleto),
          const Divider(color: Colors.white24),
          infoTile('Atividade Principal', data['atividade_principal']?['descricao'] ?? 'Não informado'),
          const Divider(color: Colors.white24),
          infoTile('Telefone', data['telefone1'] ?? 'Não informado'),
          infoTile('E-mail', data['email'] ?? 'Não informado'),
        ],
      ),
    );
  }
}