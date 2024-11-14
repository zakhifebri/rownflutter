import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class TambahProdukPage extends StatefulWidget {
  const TambahProdukPage({super.key});

  @override
  _TambahProdukPageState createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _selectedKategori;
  File? _selectedImage;

  final List<String> _kategoriList = [
    'Laki-laki',
    'Perempuan',
    'Kaos Panjang',
    'Kaos Pendek',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _tambahProduk() async {
    final String nama = _namaController.text;
    final String harga = _hargaController.text;
    final String deskripsi = _deskripsiController.text;
    final String? kategori = _selectedKategori;

    if (nama.isNotEmpty && harga.isNotEmpty && kategori != null && _selectedImage != null && deskripsi.isNotEmpty) {
      try {
        String imageUrl = await uploadImage(_selectedImage!);

        await FirebaseFirestore.instance.collection('produk') .add({
          'nama': nama,
          'harga': double.parse(harga),
          'kategori': kategori,
          'gambar': imageUrl,
          'deskripsi': deskripsi,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan!')),
        );
        _namaController.clear();
        _hargaController.clear();
        _deskripsiController.clear();
        setState(() {
          _selectedKategori = null;
          _selectedImage = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua kolom')),
      );
    }
  }

  Future<String> uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('produk/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

    await imageRef.putFile(image);
    final downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                items: _kategoriList.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedKategori = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _tambahProduk,
                child: const Text('Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}
