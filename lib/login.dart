import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rown/base.dart';
import 'package:rown/admin/beranda_admin.dart';
import 'package:rown/daftar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Kredensial khusus untuk admin
  final String adminUsername = "admin";
  final String adminPassword = "admin123";

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("lib/images/bg.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom()),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Rown Division",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selamat Datang",
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildGreyText("Masukkan Akun Anda"),
        const SizedBox(height: 10),
        _buildGreyText("Username"),
        _buildInputField(loginController),
        const SizedBox(height: 10),
        _buildGreyText("Kata Sandi"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 3),
        _buildRememberForgot(),
        const SizedBox(height: 3),
        _buildLoginButton(),
        const SizedBox(height: 3),
        _buildDaftarButton(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberUser,
              onChanged: (value) {
                setState(() {
                  rememberUser = value!;
                });
              },
            ),
            _buildGreyText("Ingatkan Saya"),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: _buildGreyText("Lupa Password"),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        // Cek apakah username dan password sesuai dengan kredensial admin
        if (loginController.text == adminUsername && passwordController.text == adminPassword) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BerandaAdmin()),
          );
          return;
        }

        // Jika bukan admin, lanjutkan proses login menggunakan Firebase Auth
        try {
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: loginController.text,
            password: passwordController.text,
          );

          if (userCredential.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BasePage()),
            );
          }
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        shadowColor: Colors.brown,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text("LOGIN", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildDaftarButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigasi ke halaman pendaftaran (RegisterPage)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: const StadiumBorder(),
        elevation: 0,
        shadowColor: Colors.brown,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text("DAFTAR", style: TextStyle(color: Colors.white)),
    );
  }
}
