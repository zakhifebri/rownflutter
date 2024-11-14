import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _imageFile;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          addressController.text = userData['address'] ?? '';
          phoneController.text = userData['phone'] ?? '';
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (user != null) {
      String? imageUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user!.uid}');
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await _firestore.collection('users').doc(user!.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'profileImage': imageUrl,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('lib/images/default_avatar.png') as ImageProvider,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Nama"),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Nama',
              ),
            ),
            const SizedBox(height: 10),
            const Text("Email"),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            const Text("Alamat"),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Alamat',
              ),
            ),
            const SizedBox(height: 10),
            const Text("No Telepon"),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan No Telepon',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
