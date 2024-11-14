import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProdukPage extends StatelessWidget {
  const EditProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('produk').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan saat mengambil data.'));
          }

          final produkList = snapshot.data?.docs ?? [];

          if (produkList.isEmpty) {
            return const Center(child: Text('Tidak ada produk tersedia.'));
          }

          return ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final produk = produkList[index].data() as Map<String, dynamic>;
              final productId = produkList[index].id;

              return ListTile(
                leading: produk['gambar'] != null
                    ? Image.network(
                        produk['gambar'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),
                title: Text(produk['nama'] ?? 'Nama tidak tersedia'),
                subtitle: Text(produk['harga'] != null ? 'Rp ${produk['harga'] is double ? produk['harga'].toInt() : produk['harga']}' : 'Harga tidak tersedia'),

                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDetailPage(
                          productId: productId,
                          currentData: produk,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditDetailPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> currentData;

  const EditDetailPage({super.key, required this.productId, required this.currentData});

  @override
  EditDetailPageState createState() => EditDetailPageState();
}

class EditDetailPageState extends State<EditDetailPage> {
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.currentData['nama']);
    _hargaController = TextEditingController(text: widget.currentData['harga']?.toString());
    _deskripsiController = TextEditingController(text: widget.currentData['deskripsi']);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    await FirebaseFirestore.instance.collection('produk').doc(widget.productId).update({
      'nama': _namaController.text,
      'harga': int.tryParse(_hargaController.text) ?? 0,
      'deskripsi': _deskripsiController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil diperbarui')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Detail Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
