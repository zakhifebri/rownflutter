import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pembayaran.dart';

class PemesananPage extends StatelessWidget {
  final String paymentMethod;
  final String orderSummary;
  final int quantity;
  final double price;

  const PemesananPage({
    super.key,
    required this.paymentMethod,
    required this.orderSummary,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double subtotalProduk = quantity * price;
    double subtotalPengiriman = 10000;
    double totalPembayaran = subtotalProduk + subtotalPengiriman;

    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan')),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data pengguna tidak ditemukan."));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String name = userData['name'] ?? 'Nama tidak tersedia';
          final String phoneNumber = userData['phone'] ?? 'Nomor telepon tidak tersedia';
          final String address = userData['address'] ?? 'Alamat tidak tersedia';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(phoneNumber),
                            Text(address),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Metode Pembayaran:", style: TextStyle(fontSize: 16)),
                ListTile(
                  title: const Text('COD'),
                  leading: Radio<String>(
                    value: 'COD',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      // Logika untuk memilih metode pembayaran
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Ringkasan Pesanan:", style: TextStyle(fontSize: 16)),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harga Satuan: Rp${price.toInt()}'),
                      Text('Jumlah: $quantity'),
                      Text('Subtotal Produk: Rp${subtotalProduk.toInt()}'),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text('Subtotal Pengiriman: Rp${subtotalPengiriman.toInt()}'),
                      Text('Total Pembayaran: Rp${totalPembayaran.toInt()}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Simpan pesanan ke Firestore
                      await _saveOrderToFirestore(name, orderSummary, subtotalProduk, subtotalPengiriman, totalPembayaran);

                      // Tampilkan popup transaksi berhasil
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context).pop(); // Tutup dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PembayaranPage(
                                  name: name,
                                  orderSummary: orderSummary,
                                  subtotalProduk: subtotalProduk,
                                  subtotalPengiriman: subtotalPengiriman,
                                  totalPembayaran: totalPembayaran,
                                ),
                              ),
                            );
                          });

                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/images/checkmark.gif',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Transaksi Berhasil",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Konfirmasi",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveOrderToFirestore(String name, String orderSummary, double subtotalProduk, double subtotalPengiriman, double totalPembayaran) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'name': name,
        'orderSummary': orderSummary,
        'subtotalProduk': subtotalProduk,
        'subtotalPengiriman': subtotalPengiriman,
        'totalPembayaran': totalPembayaran,
        'status': "Sedang Diproses",
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception("Pengguna tidak ditemukan");
    }
  }

  Future<DocumentSnapshot> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    throw Exception('Pengguna tidak ditemukan');
  }
}
