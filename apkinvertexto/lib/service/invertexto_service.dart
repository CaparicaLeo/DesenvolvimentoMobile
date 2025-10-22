import 'dart:convert';
import 'dart.io';
import 'dart:async'; // Para o TimeoutException

import 'package:http/http.dart' as http;

// Classe de exceção personalizada para erros da API
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class InvertextoService {
  // ATENÇÃO: Lembre-se de proteger este token no futuro, antes de publicar o app.
  final String _token = "21540|kTJAl6y2M7qoTwGjBKpjZThB6TrgLW5N";
  final String _baseUrl = "https://api.invertexto.com/v1";

  Future<Map<String, dynamic>> convertePorExtenso(
    String valor, {
    String? moeda,
  }) async {
    try {
      var uri = Uri.parse(
        "$_baseUrl/number-to-words?token=$_token&number=$valor&language=pt&currency=$moeda",
      );

      // Adiciona o parâmetro de moeda apenas se ele for fornecido e não estiver vazio
      if (moeda != null && moeda.isNotEmpty) {
        uri += "&currency=$moeda";
      } 
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Verifique seu token da API.');
      } else {
        throw ApiException(
          'Ocorreu um erro no servidor (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder. Tente novamente.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado.');
    }
  }

  Future<Map<String, dynamic>> buscaCEP(String valor) async {
    try {
      final uri = Uri.parse("$_baseUrl/cep/$valor?token=$_token");
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw ApiException('CEP não encontrado.');
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Verifique seu token da API.');
      } else {
        throw ApiException(
          'Ocorreu um erro no servidor (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder. Tente novamente.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado.');
    }
  }

  Future<Map<String, dynamic>> buscaCNPJ(String valor) async {
    try {
      final uri = Uri.parse("$_baseUrl/cnpj/$valor?token=$_token");
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw ApiException('CNPJ não encontrado.');
      } else if (response.statusCode == 401) {
        throw ApiException('Erro de autenticação. Verifique seu token da API.');
      } else {
        throw ApiException(
          'Ocorreu um erro no servidor (código ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Sem conexão com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw ApiException('O servidor demorou para responder. Tente novamente.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ocorreu um erro inesperado.');
    }
  }
}
