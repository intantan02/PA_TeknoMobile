import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Book extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String coverUrl;

  @HiveField(4)
  String price;

  @HiveField(5)
  String description;

  @HiveField(6)
  List<String> genres;

  @HiveField(7)
  String image;

  @HiveField(8)
  String subtitle;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    this.price = '',
    this.description = '',
    this.genres = const [],
    this.image = '',
    this.subtitle = '',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Dummy genres jika tidak ada di API
    List<String> dummyGenres = ['Fiction', 'Technology', 'Science', 'Business'];
    return Book(
      id: json['isbn13'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['image'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      description: json['subtitle'] ?? '',
      subtitle: json['subtitle'] ?? '',
      genres: [dummyGenres[(json['title'] ?? '').length % dummyGenres.length]],
    );
  }
}