import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/db_service.dart';

class DetailPage extends StatefulWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DBService _dbService = DBService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await _dbService.isFavorite(widget.book.id as int);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _dbService.removeFavorite(widget.book.id as int);
    } else {
      await _dbService.addFavorite(widget.book as Map<String, dynamic>);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (book.coverUrl.isNotEmpty)
              Image.network(book.coverUrl, height: 250, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              book.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Penulis: ${book.author}',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              book.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
