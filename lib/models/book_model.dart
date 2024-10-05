class Book {
  int? id;
  String title;
  String description;
  String filePath;
  String imagePath;
  bool isFavorite;

  Book({
    this.id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filePath': filePath,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      filePath: map['filePath'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
