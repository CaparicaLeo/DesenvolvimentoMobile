import 'package:apkgiphy/service/giphy_service.dart';
import 'package:apkgiphy/view/giphy_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  bool _loadingMore = false;
  bool _isSearching = false;
  List _gifData = [];
  final GiphyService giphyService = GiphyService();

  @override
  void initState() {
    super.initState();
    _loadGifs();
  }

  void _loadGifs() async {
    setState(() {
      _loadingMore = true;
    });

    var newGifs = await giphyService.getGifs(_search, _offset);
    setState(() {
      _loadingMore = false;
      _gifData.addAll((newGifs["data"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
          "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offset = 0;
                  _gifData.clear();
                  _isSearching = true;
                });
                _loadGifs();
              },
            ),
          ),
          Expanded(
            child: _gifData.isEmpty && !_loadingMore && !_isSearching
                ? _gifLoadingIndicator()
                : _createGifTable(),
          ),
        ],
      ),
    );
  }

  Widget _gifLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 5.0,
      ),
    );
  }

  Widget _createGifTable() {
    bool hasMoreGifs = _gifData.length < 25;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _gifData.length + 1,
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        if (index < _gifData.length) {
          var gif = _gifData[index];
          var gifUrl = gif["images"]["original"]["url"];
          return GestureDetector(
            child: Image.network(gifUrl, height: 300, fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GiphyPage(gif)),
              );
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: !_loadingMore ? (){
                setState(() {
                  _loadingMore = true;
                  _offset += 25;
                });
                _loadGifs();
              }:null
            ),
          );
        }
      },
    );
  }
}
