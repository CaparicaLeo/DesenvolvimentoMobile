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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_loadingMore) {
        setState(() {
          _offset += 7;
        });
        _loadNews();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          if (_offset == 0) {
            _newsData.clear();
          }
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
          children: [
            Text('Capa News', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Procure aqui a sua notícia",
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[700],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2.0,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offset = 0;
                });
                _loadNews();
              },
            ),
          ),
          Expanded(
            child: _buildNewsList(),
          ),
        ],
      ),
    );
  }

  Widget newsLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        strokeWidth: 5.0,
      ),
    );
  }

  Widget _buildNewsList() {
    if (_newsData.isEmpty && _loadingMore && _search.isEmpty) {
      return newsLoadingIndicator();
    }

    if (_newsData.isEmpty && !_loadingMore) {
      return const Center(
        child: Text(
          "Nenhuma notícia encontrada.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: _newsData.length + (_loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _newsData.length) {
          var news = _newsData[index];
          return NewsCard(news: news);
        } else {
          return newsLoadingIndicator();
        }
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final dynamic news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final String title = news['title'] ?? 'Notícia sem título';
    final String? imageUrl = news['image'];
    final String? sourceName = news['source']?['name'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsPage(news)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (sourceName != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                child: Text(
                  sourceName,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}