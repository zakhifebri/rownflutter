import 'package:flutter/material.dart';
import 'tambah_produk.dart';
import 'hapus_produk.dart';
import 'edit_produk.dart';
import 'package:rown/login.dart'; // Import halaman login

class BerandaAdmin extends StatelessWidget {
  const BerandaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 74, 64),
        title: const Text(
          'Beranda Admin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0), // Tambahkan padding di bawah
                child: GridView.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3,
                  children: [
                    _buildFeatureBox(
                      context,
                      title: 'Tambah Produk',
                      icon: Icons.add,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TambahProdukPage()),
                        );
                      },
                    ),
                    _buildFeatureBox(
                      context,
                      title: 'Hapus Produk',
                      icon: Icons.delete,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HapusProdukPage()),
                        );
                      },
                    ),
                    _buildFeatureBox(
                      context,
                      title: 'Edit Produk',
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProdukPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Tambahkan tombol kembali ke halaman login
            Padding(
  padding: const EdgeInsets.only(bottom: 40.0), // Margin bottom
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: const Text(
      'Kembali ke Login',
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBox(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
