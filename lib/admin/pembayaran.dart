import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rown/base.dart';

class PembayaranPage extends StatelessWidget {
  final String name;
  final String orderSummary;
  final double subtotalProduk;
  final double subtotalPengiriman;
  final double totalPembayaran;

  const PembayaranPage({
    super.key,
    required this.name,
    required this.orderSummary,
    required this.subtotalProduk,
    required this.subtotalPengiriman,
    required this.totalPembayaran,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terima Kasih telah Berbelanja Di Rowndivision",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Anda telah berhasil melakukan pembayaran menggunakan COD"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Rincian Pembayaran:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Subtotal Produk: Rp${subtotalProduk.toInt()}"),
                  Text("Subtotal Pengiriman: Rp${subtotalPengiriman.toInt()}"),
                  const Divider(),
                  Text(
                    "Total Pembayaran: Rp${totalPembayaran.toInt()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const BasePage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Kembali Ke Beranda",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan pesanan ke Firestore
  Future<void> _saveOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final orderData = {
        'userId': user.uid,
        'name': name,
        'orderSummary': orderSummary,
        'subtotalProduk': subtotalProduk,
        'subtotalPengiriman': subtotalPengiriman,
        'totalPembayaran': totalPembayaran,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);
    }
  }
}
