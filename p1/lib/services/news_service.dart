import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsService {
  final String _token = "76a6a927c695731b344ad7ade2ca32d9";

  Future<Map> getNews(String query, int offset) async {
    http.Response response;

    if (query.isEmpty) {
      response = await http.get(
        Uri.parse(
          "https://gnews.io/api/v4/top-headlines?category=general&apikey=${_token}",
        ),
      );
    } else {
      response = await http.get(
        Uri.parse("https://gnews.io/api/v4/search?q=example&apikey=${_token}"),
      );
    }

    return json.decode(response.body);
  }
}
