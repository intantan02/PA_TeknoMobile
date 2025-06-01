import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/api_service.dart';
import '../../widgets/book_list_item.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
  setState(() {
    _isLoading = true;
  });
  try {
    final booksJson = await _apiService.fetchBooks();
    final books = booksJson.map<Book>((json) => Book.fromJson(json)).toList();
    setState(() {
      _books = books;
      _filteredBooks = books;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal memuat data buku')),
    );
  }
}

  void _filterBooks(String query) {
    final filtered = _books.where((book) {
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) || authorLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredBooks = filtered;
    });
  }

  void _navigateToDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(book: book)),
    );
  }

  void _navigateToFavorite() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekomendasi Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: _navigateToFavorite,
            tooltip: 'Favorit',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari buku atau penulis',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterBooks,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? Center(child: Text('Tidak ada buku ditemukan'))
                    : ListView.builder(
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return BookListItem(
                            book: book,
                            onTap: () => _navigateToDetail(book),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
