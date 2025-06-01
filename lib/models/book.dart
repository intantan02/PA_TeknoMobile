class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
  });

  // Konversi Map ke objek Book
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['bookId'] ?? 0,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
    );
  }

  // Konversi objek Book ke Map untuk disimpan di DB
  Map<String, dynamic> toMap() {
    return {
      'bookId': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    };
  }
}
