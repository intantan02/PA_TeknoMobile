import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Book {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String image;
  final List<String> genres;

  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.genres,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Tambah genre dummy karena API itbook.store ga ada genre
    List<String> dummyGenres = ['Fiction', 'Technology', 'Science', 'Business'];

    return Book(
      id: json['isbn13'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      genres: [dummyGenres[json['title'].length % dummyGenres.length]], // dummy genre dari panjang judul
    );
  }
}

class RekomendasiPage extends StatefulWidget {
  @override
  _RekomendasiPageState createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  List<String> _favoriteIds = [];
  String _searchText = '';
  String _selectedGenre = 'All';
  final List<String> _genres = ['All', 'Fiction', 'Technology', 'Science', 'Business'];

  @override
  void initState() {
    super.initState();
    _loadBooks();
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
      // error handle
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat data buku')));
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favoriteBooks') ?? [];
    });
  }

  Future<void> _toggleFavorite(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(bookId)) {
        _favoriteIds.remove(bookId);
      } else {
        _favoriteIds.add(bookId);
      }
      prefs.setStringList('favoriteBooks', _favoriteIds);
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
      appBar: AppBar(
        title: Text('Rekomendasi Buku'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari judul buku',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchText = value;
                _applyFilters();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
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
          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(child: Text('Tidak ada buku ditemukan'))
                : ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      final isFavorite = _favoriteIds.contains(book.id);

                      return ListTile(
                        leading: Image.network(
                          book.image,
                          width: 50,
                          errorBuilder: (_, __, ___) => Icon(Icons.book),
                        ),
                        title: Text(book.title),
                        subtitle: Text('${book.subtitle}\n${book.price}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(book.id),
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
