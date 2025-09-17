import 'dart:convert';

import 'package:http/http.dart' as http;

String _key = "21liHACJxFrL6VWM2eOLdDg6vn3lRVhh";

class GiphyService {
  Future<Map> getGifs(String _search, int _offset) async {
    http.Response response;
    if (_search == null || _search.isEmpty) {
      response = await http.get(
        Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api=$_key&q=$_search&limit=25&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips",
        ),
      );
    } else {
      response = await http.get(
        Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api=$_key&limit=25&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips",
        ),
      );
    }

    return json.decode(response.body);
  }
}
