import 'package:flutter/material.dart';

class TrendPage extends StatelessWidget {
  const TrendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Trending",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTrendItem(
              context,
              'T-Shirt Terbaru',
              'lib/images/kp2.png', // Ganti dengan nama file gambar Anda
              'T-Shirt yang sedang hits, nyaman dan stylish.',
            ),
            const SizedBox(height: 16),
            _buildTrendItem(
              context,
              'Hoodie Terbaru',
              'lib/images/cwe5.png', // Ganti dengan nama file gambar Anda
              'Hoodie Stylish, cocok untuk segala acara.',
            ),
            const SizedBox(height: 16),
            _buildTrendItem(
              context,
              'Tracksuit Terbaru',
              'lib/images/cwo6.png', // Ganti dengan nama file gambar Anda
              'Jaket Parasut Elegan, selalu modis.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(
      BuildContext context, String title, String imagePath, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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
