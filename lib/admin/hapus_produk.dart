import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HapusProdukPage extends StatelessWidget {
  const HapusProdukPage({super.key});

  Future<void> _deleteProduct(BuildContext context, String productId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus produk ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      await FirebaseFirestore.instance.collection('produk').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hapus Produk'),
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(context, productId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
