import 'package:flutter/material.dart';
import 'package:p1/services/news_service.dart';
import 'package:p1/views/news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = '';
  int _offset = 0;
  bool _loadingMore = false;
  bool _isSearching = false;
  List _newsData = [];

  final NewsService newsService = NewsService();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() async {
    setState(() {
      _loadingMore = true;
    });
    var newNews = await newsService.getNews(_search, _offset);
    setState(() {
      _loadingMore = false;
      _newsData.addAll(newNews["data"]); //conferir na response
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Capa News')],
        ),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Procure aqui a sua notícia",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offset = 0;
                  _newsData.clear();
                  _isSearching = true;
                });
                _loadNews();
              },
            ),
          ),
          Expanded(
            child: _newsData.isEmpty && !_loadingMore && _isSearching
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent,
                      ),
                    ),
                  )
                : _createNewsTable(),
          ),
        ],
      ),
    );
  }

  Widget newsLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        strokeWidth: 5.0,
      ),
    );
  }

  Widget _createNewsTable() {
    bool hasMoreNews = _newsData.length < 7;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _newsData.length + 1,
      itemBuilder: (context, index) {
        if (index < _newsData.length) {
          var news = _newsData[index];
          var newsUrl = news["images"]["original"]["url"];
          return GestureDetector(
            child: Image.network(newsUrl, height: 300, fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsPage(news)),
              );
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              onTap: !_loadingMore
                  ? () {
                      setState(() {
                        _loadingMore = true;
                        _offset += 7;
                      });
                      _loadNews();
                    }
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.black, size: 70),
                  Text(
                    'Chegou ao fim? Veja mais!',
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
