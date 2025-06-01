import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/db_service.dart';
import '../../widgets/book_list_item.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final DBService _dbService = DBService();
  List<Book> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    final favs = await _dbService.getFavorites();
    setState(() {
      _favorites = favs.cast<Book>();
      _isLoading = false;
    });
  }

  void _navigateToDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(book: book)),
    ).then((_) => _loadFavorites()); // Refresh favorites on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku Favorit'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? Center(child: Text('Belum ada buku favorit'))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final book = _favorites[index];
                    return BookListItem(
                      book: book,
                      onTap: () => _navigateToDetail(book),
                    );
                  },
                ),
    );
  }
}
