import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';
import '../../models/book.dart';

class RekomendasiPage extends StatefulWidget {
  @override
  _RekomendasiPageState createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  final Color primaryColor = Colors.blue;

  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  List<String> _favoriteIds = [];
  String _searchText = '';
  String _selectedGenre = 'All';
  final List<String> _genres = ['All', 'Fiction', 'Technology', 'Science', 'Business'];

  late Box _favBox;

  @override
  void initState() {
    super.initState();
    _openHiveAndLoad();
  }

  Future<void> _openHiveAndLoad() async {
    _favBox = await Hive.openBox('favoriteBooks');
    await _loadBooks();
    _loadFavorites();
  }

  Future<void> _loadBooks() async {
    final response = await http.get(Uri.parse('https://api.itbook.store/1.0/new'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List booksJson = data['books'];
      List<Book> books = booksJson.map((json) => Book.fromJson(json)).toList();

      setState(() {
        _books = books;
        _applyFilters();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data buku')),
      );
    }
  }

  void _loadFavorites() {
    setState(() {
      _favoriteIds = _favBox.keys.cast<String>().toList();
    });
  }

  Future<void> _toggleFavorite(String bookId) async {
    setState(() {
      if (_favoriteIds.contains(bookId)) {
        _favBox.delete(bookId);
        _favoriteIds.remove(bookId);
      } else {
        _favBox.put(bookId, true);
        _favoriteIds.add(bookId);
      }
    });
  }

  void _applyFilters() {
    List<Book> filtered = _books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_searchText.toLowerCase());
      final matchesGenre = _selectedGenre == 'All' || book.genres.contains(_selectedGenre);
      return matchesSearch && matchesGenre;
    }).toList();

    setState(() {
      _filteredBooks = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Rekomendasi Buku'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            color: primaryColor,
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    labelText: 'Cari judul buku',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  onChanged: (value) {
                    _searchText = value;
                    _applyFilters();
                  },
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGenre,
                      isExpanded: true,
                      items: _genres.map((genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _selectedGenre = value;
                          _applyFilters();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(child: Text('Tidak ada buku ditemukan'))
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      final isFavorite = _favoriteIds.contains(book.id);

                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.image,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.book),
                            ),
                          ),
                          title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${book.subtitle}\n${book.price}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(book.id),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(book: book),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}