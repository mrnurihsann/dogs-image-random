import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/login.dart';

void main() async {
  // Menjamin bahwa binding widget telah diinisialisasi sebelum memulai Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase sebelum menjalankan aplikasi
  await Firebase.initializeApp();

  // Menjalankan aplikasi Flutter
  runApp(MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi yang akan muncul di task manager
      title: 'Flutter Firebase Auth',

      // Tema dasar aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Skema warna utama aplikasi
      ),

      // Layar utama yang akan ditampilkan saat aplikasi dibuka
      home: LoginScreen(),
    );
  }
}
