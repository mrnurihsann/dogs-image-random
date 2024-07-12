// Definisi kelas Dog yang merepresentasikan data dog dari API
class Dog {
  // Properti untuk menyimpan URL gambar dog
  String imageUrl;

  // Konstruktor dengan parameter wajib 'imageUrl'
  Dog({required this.imageUrl});

  // Factory constructor untuk membuat objek Dog dari data JSON
  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      // Mengambil nilai 'message' dari JSON dan menginisialisasi 'imageUrl'
      imageUrl: json['message'],
    );
  }
}
