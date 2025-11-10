import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsService {
  final String _token = "76a6a927c695731b344ad7ade2ca32d9";
  final int _maxItems = 7; // Define o número de itens por página

  Future<Map> getNews(String query, int offset) async {
    http.Response response;

    // 1. CALCULA A PÁGINA ATUAL
    // GNews usa "page", não "offset".
    // Se offset=0, page=1. Se offset=7, page=2. Se offset=14, page=3.
    int page = (offset / _maxItems).floor() + 1;

    if (query.isEmpty) {
      // 2. CORRIGE A URL DE "top-headlines"
      // Adiciona os parâmetros 'max' e 'page'
      response = await http.get(
        Uri.parse(
          "https://gnews.io/api/v4/top-headlines?category=general&country=br&max=$_maxItems&page=$page&apikey=$_token",
        ),
      );
    } else {
      // 3. CORRIGE A URL DE "search"
      // Usa a variável 'query', e adiciona 'max', 'page' e 'country'
      response = await http.get(
        Uri.parse(
          "https://gnews.io/api/v4/search?q=$query&country=br&max=$_maxItems&page=$page&apikey=$_token",
        ),
      );
    }

    return json.decode(response.body);
  }
}
