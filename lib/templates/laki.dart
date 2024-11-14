import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rown/templates/laki_detail.dart'; // Pastikan ini sesuai dengan path file detail

class LakiPage extends StatelessWidget {
  const LakiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produk Laki-laki')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('produk').where('kategori', isEqualTo: 'Laki-laki').snapshots(),
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                final produk = produkList[index].data() as Map<String, dynamic>;

                return _buildProductBox(
                  context,
                  produk['gambar'] ?? 'lib/images/default.png', // Gambar default jika null
                  produk['nama'] ?? 'Nama Tidak Tersedia', 
                  produk['harga'] != null ? 'Rp ${produk['harga'].toInt()}' : 'Harga Tidak Tersedia',
                  produk['deskripsi'] ?? 'Deskripsi Tidak Tersedia',
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductBox(BuildContext context, String imagePath, String name, String price, String description) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                imagePath, // Ini harus URL gambar yang valid dari Firestore
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LakiDetailPage(
                          name: name,
                          price: price,
                          imagePath: imagePath,
                          description: description,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat Rincian',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
