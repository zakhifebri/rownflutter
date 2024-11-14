import 'package:flutter/material.dart';
import 'package:rown/login.dart';
import 'templates/edit_profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>( // FutureBuilder to handle user data
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profileImage = snapshot.data?['profileImage'];

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (profileImage != null && profileImage.startsWith('http'))
                    ? NetworkImage(profileImage)
                    : const AssetImage('lib/images/default_avatar.png') as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.dstATop),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (snapshot.data?['profileImage'] != null && snapshot.data!['profileImage'].startsWith('http'))
                          ? NetworkImage(snapshot.data!['profileImage'])
                          : const AssetImage('lib/images/default_avatar.png') as ImageProvider,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.data?['name'] ?? 'Nama tidak tersedia',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.data?['email'] ?? 'Email tidak tersedia',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 71, 71, 71),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.data?['phone'] ?? 'Phone tidak tersedia',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 71, 71, 71),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 150, // Width for Edit Profil button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Edit Profil",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Adjusted spacing
                    SizedBox(
                      width: 150, // Set same width for Keluar button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        child: const Text(
                          "Keluar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Keluar"),
          content: const Text("Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}
