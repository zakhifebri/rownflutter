import 'package:flutter/material.dart';
import 'package:rown/admin/pemesanan.dart';

class KaosPendekDetailPage extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final String description;

  const KaosPendekDetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
    this.description = "Deskripsi produk ini belum tersedia.",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar produk
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Nama barang
                Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Harga barang
                Text(price, style: const TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 20),
                // Pilihan pengiriman
                const Text('Pilihan Pengiriman:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Expanded(child: Text('Instan Delivery')),
                    SizedBox(width: 10),
                    Expanded(child: Text('COD')),
                  ],
                ),
                const SizedBox(height: 20),
                // Box deskripsi barang
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(description),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
          // Tombol "Beli Sekarang" tetap di bawah
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPurchaseOptions(context);
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  'Beli Sekarang',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseOptions(BuildContext context) {
    String? selectedSize;
    int quantity = 1;
    String paymentMethod = 'COD';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Ukuran dan Jumlah",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Pilihan ukuran
                  const Text("Ukuran:", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: selectedSize,
                    items: <String>['S', 'M', 'L', 'XL'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue;
                      });
                    },
                    hint: const Text("Pilih Ukuran"),
                  ),
                  const SizedBox(height: 20),
                  // Jumlah
                  const Text("Jumlah:", style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tombol Konfirmasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Konversi harga menjadi double untuk perhitungan
                        double parsedPrice = double.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));

                        // Pindah ke halaman Pemesanan
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PemesananPage(
                             // Ganti dengan data yang sesuai
                              paymentMethod: paymentMethod,
                              orderSummary: "Ringkasan Pesanan: $selectedSize x$quantity",
                              quantity: quantity,
                              price: parsedPrice,
                            ),
                          ),
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
        );
      },
    );
  }
}
