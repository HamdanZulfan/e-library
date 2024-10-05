import 'package:flutter/foundation.dart';

import '../models/book_model.dart';
import '../services/database_helper.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    _books = await DatabaseHelper.instance.getBooks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await DatabaseHelper.instance.addBook(book);
    await fetchBooks(); // Refresh data setelah buku ditambahkan
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance
        .updateBook(book); // Panggil update di database
    await fetchBooks(); // Refresh data setelah memperbarui buku
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    await fetchBooks(); // Refresh data setelah menghapus buku
  }

  void toggleFavorite(Book book) {
    book.isFavorite = !book.isFavorite;
    DatabaseHelper.instance.updateBook(book);
    notifyListeners();
  }
}
