import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../providers/book_provider.dart';
import '../../utils/theme.dart';
import '../explore/edit_book_screen.dart';
import '../explore/pdf_view_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //  final tryoutProvider =
      //     Provider.of<TryoutProvider>(context, listen: false);
      // if (tryoutProvider.myState != MyState.loaded) {
      //   tryoutProvider.fetchKategori();
      // }
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });
  }

  String _searchQuery = ''; // Variabel untuk menyimpan input pencarian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navyColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          'Search Book',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // Simpan input pencarian
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                // Filter buku berdasarkan input pencarian
                final searchResults = bookProvider.books
                    .where((book) =>
                        book.title.toLowerCase().contains(_searchQuery))
                    .toList();

                if (searchResults.isEmpty) {
                  return const Center(
                    child: Text('No books found'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    children: List.generate(
                      searchResults.length,
                      (index) {
                        final book = searchResults[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewerScreen(
                                  filePath: book.filePath,
                                  title: book.title,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.file(
                                    File(book.imagePath),
                                    width: double.infinity,
                                    height: 120, // Sesuaikan tinggi gambar
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: navyTextStyle.copyWith(
                                          fontWeight: semiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        book.description,
                                        style: blackTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              bookProvider.toggleFavorite(book);
                                            },
                                            child: Icon(
                                              book.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: book.isFavorite
                                                  ? Colors.red
                                                  : null,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_horiz),
                                            onSelected: (String result) async {
                                              if (result == 'edit') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditBookScreen(
                                                            book: book),
                                                  ),
                                                );
                                              } else if (result == 'delete') {
                                                bool confirmDelete =
                                                    await _showDeleteConfirmationDialog(
                                                        context);
                                                if (confirmDelete) {
                                                  await bookProvider
                                                      .deleteBook(book.id!);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            '${book.title} deleted')),
                                                  );
                                                }
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );

                // return ListView.builder(
                //   itemCount: searchResults.length,
                //   itemBuilder: (context, index) {
                //     final book = searchResults[index];
                //     return ListTile(
                //       title: Text(book.title),
                //       subtitle: Text(book.description),
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => PdfViewerScreen(
                //               filePath: book.filePath,
                //               title: book.title,
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   },
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this book?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
