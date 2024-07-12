// Mengimpor pustaka untuk mengonversi JSON dan melakukan permintaan HTTP
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_akhir/components/dog.dart';

// Definisi kelas DogService yang menyediakan metode untuk mengambil data dog dari API
class DogService {
  // Metode statis untuk mengambil data dog acak dari API
  static Future<Dog> fetchRandomDog() async {
    // Melakukan permintaan GET ke API dog.ceo untuk mendapatkan gambar dog acak
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    // Memeriksa status respons
    if (response.statusCode == 200) {
      // Jika status 200 (OK), parsing JSON dan membuat objek Dog
      return Dog.fromJson(jsonDecode(response.body));
    } else {
      // Jika status bukan 200, lemparkan pengecualian
      throw Exception('Failed to load random dog');
    }
  }
}
