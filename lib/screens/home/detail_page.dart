import 'package:flutter/material.dart';
import 'package:rekomendasi_buku/models/book.dart';
import 'rekomendasi_page.dart'; // Import agar class Book dikenali

class DetailPage extends StatelessWidget {
  final Book book;

  const DetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.image.isNotEmpty)
              Image.network(
                book.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (book.subtitle.isNotEmpty)
              Text(
                book.subtitle,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 12),
            if (book.price.isNotEmpty)
              Text(
                'Harga: ${book.price}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),
            if (book.genres.isNotEmpty)
              Text(
                'Genre: ${book.genres.join(", ")}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}