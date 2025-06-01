import 'package:flutter/material.dart';
import '../models/book.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookListItem({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: onTap,
    );
  }
}