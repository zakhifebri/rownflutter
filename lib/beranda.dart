import 'package:flutter/material.dart';
import 'templates/laki.dart'; // Pastikan ini sesuai dengan path file
import 'templates/perempuan.dart';
import 'templates/kaos_pendek.dart';
import 'templates/kaos_panjang.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 134, 134, 134).withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 19 / 9,
                    child: Image.asset(
                      'lib/images/potosatu.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pilih Kategori:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryBox(context, 'Laki-Laki', 'lib/images/laki.png', const LakiPage()),
                _buildCategoryBox(context, 'Perempuan', 'lib/images/cewe.png', const PerempuanPage()),
                _buildCategoryBox(context, 'Kaos Panjang', 'lib/images/kaos panjang.png', const KaosPanjangPage()),
                _buildCategoryBox(context, 'Kaos Pendek', 'lib/images/kaos pendek.png', const KaosPendekPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBox(BuildContext context, String title, String imagePath, Widget page) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8.0), // Menambahkan padding
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 150, // Menentukan tinggi gambar agar seragam
                  fit: BoxFit.cover, // Memastikan gambar terisi dengan baik
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 7, right: 10, left: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 100, 91),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {
                // Menambahkan print untuk debug
                print("Navigating to $title");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
