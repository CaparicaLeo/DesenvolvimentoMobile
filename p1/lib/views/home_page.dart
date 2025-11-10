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
  final List _newsData = [];

  final NewsService newsService = NewsService();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() async {
    if (_loadingMore) return;

    setState(() {
      _loadingMore = true;
    });

    try {
      var newNews = await newsService.getNews(_search, _offset);

      if (mounted) {
        setState(() {
          _newsData.addAll(newNews["articles"]);
        });
      }
    } catch (e) {
      print("Erro ao carregar notícias: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao carregar notícias.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Capa News')],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Procure aqui a sua notícia",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offset = 0;
                  _newsData.clear();
                });
                _loadNews();
              },
            ),
          ),
          Expanded(
            child: _newsData.isEmpty && _loadingMore
                ? newsLoadingIndicator()
                : _createNewsTable(),
          ),
        ],
      ),
    );
  }

  /// Retorna um indicador de progresso centralizado
  Widget newsLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        strokeWidth: 5.0,
      ),
    );
  }

  /// Cria a grade de notícias (SOMENTE TEXTO)
  /// Cria a lista de notícias (SOMENTE TEXTO)
  Widget _createNewsTable() {
    // Trocamos GridView.builder por ListView.builder
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      // O 'gridDelegate' não é mais necessário
      itemCount: _newsData.length + 1,
      itemBuilder: (context, index) {
        // --- Item de Notícia (Card de Texto) ---
        if (index < _newsData.length) {
          var news = _newsData[index];
          var newsTitle = news["title"];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsPage(news)),
              );
            },
            // Adicionamos um Margin para o Card "respirar"
            child: Card(
              margin: const EdgeInsets.only(
                bottom: 10,
              ), // Espaçamento SÓ em baixo
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                // Diminuí o padding vertical para o card ficar menos "alto"
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Text(
                  newsTitle ?? "Notícia sem título",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }
        // --- Botão "Carregar Mais" ---
        else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GestureDetector(
              onTap: !_loadingMore
                  ? () {
                      setState(() {
                        _offset += 7;
                      });
                      _loadNews();
                    }
                  : null,
              child: _loadingMore
                  ? newsLoadingIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.black, size: 50),
                        Text(
                          _newsData.isNotEmpty
                              ? 'Carregar mais...'
                              : 'Tente novamente',
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
