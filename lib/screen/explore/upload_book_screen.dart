import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../utils/theme.dart';

class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _pdfFilePath;
  String? _imagePath;
  bool _isFavorite = false;

  // Fungsi untuk memilih file PDF
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadBook() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _pdfFilePath == null ||
        _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a PDF file'),
        ),
      );
      return;
    }

    final newBook = Book(
      title: _titleController.text,
      description: _descriptionController.text,
      filePath: _pdfFilePath!,
      imagePath: _imagePath!,
      isFavorite: _isFavorite,
    );

    // Menambahkan buku ke database melalui provider
    await Provider.of<BookProvider>(context, listen: false).addBook(newBook);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book uploaded successfully')));

    // Menghapus input setelah sukses
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _pdfFilePath = null;
      _imagePath = null;
      _isFavorite = false;
    });

    Navigator.pop(context);
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
          'Upload Book',
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
                decoration: const InputDecoration(labelText: 'Book Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Book Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _pickPdfFile,
                child: Text(
                  'Pick PDF File',
                  style: blackRegulerTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_pdfFilePath != null) Text('Selected File: $_pdfFilePath'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _pickImage, // Tombol untuk memilih gambar
                child: Text(
                  'Pick Cover Image',
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
                onPressed: _uploadBook,
                child: Text(
                  'Upload Book',
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
