import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../utils/theme.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _pdfFilePath;
  String? _imagePath;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book.title;
    _descriptionController.text = widget.book.description;
    _isFavorite = widget.book.isFavorite;
    _pdfFilePath = widget.book.filePath; // Set file PDF yang sudah ada
    _imagePath = widget.book.imagePath; // Set image yang sudah ada
  }

  // Fungsi untuk memilih file PDF baru
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFilePath = result.files.single.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
    }
  }

  // Fungsi untuk memilih gambar baru
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

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
          'Edit Book',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _pickPdfFile, // Tombol untuk memilih PDF baru
                child: Text(
                  'Pick New PDF File',
                  style: blackRegulerTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_pdfFilePath != null) Text('Selected File: $_pdfFilePath'),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _pickImage, // Tombol untuk memilih gambar baru
                child: Text(
                  'Pick New Cover Image',
                  style: blackRegulerTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_imagePath != null)
                Image.file(File(_imagePath!), height: 150),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final updatedBook = Book(
                    id: widget.book.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    filePath:
                        _pdfFilePath!, // File PDF baru atau yang sudah ada
                    imagePath: _imagePath!, // Gambar baru atau yang sudah ada
                    isFavorite: _isFavorite,
                  );
                  await Provider.of<BookProvider>(context, listen: false)
                      .updateBook(updatedBook);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Book updated successfully'),
                    ),
                  );
                },
                child: Text(
                  'Update Book',
                  style: blackRegulerTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
