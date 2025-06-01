
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final String category;
  final double rating;
  final bool isFavorite;
  final String coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    required this.category,
    required this.rating,
    this.isFavorite = false,
    required this.coverUrl,
  });

  // Convert Book object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'category': category,
      'rating': rating,
      'isFavorite': isFavorite,
      'coverUrl': coverUrl,
    };
  }

  // Create Book object from JSON map
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverImageUrl: json['coverImageUrl'],
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
      coverUrl: json['coverUrl'] ?? '', 
    );
  }

  // Copy with method to update isFavorite or other fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImageUrl,
    String? category,
    double? rating,
    bool? isFavorite,
    String? coverUrl,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}
