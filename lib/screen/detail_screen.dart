import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'grid_screen.dart'; // Import DogGridScreen
import 'profile.dart'; // Import ProfileScreen

class DogDetailScreen extends StatelessWidget {
  final String imageUrl;

  DogDetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Dog Picture Detail'),
        backgroundColor: Color.fromARGB(255, 50, 80, 101),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 0, 34, 62),
              Color.fromARGB(255, 49, 0, 0),
            ],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hero animation for the dog image
                Hero(
                  tag: 'dogImage',
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Dog Archie',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'This is Dog Archie, a playful and energetic dog that loves to run around and have fun.',
                    textAlign: TextAlign.center,
                  ),
                ),
                // Button bar for favorite, rating, and share buttons
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to favorites')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rated')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share('Check out this cute dog! $imageUrl');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Comments',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                // List of comments
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Robert Van Jaya'),
                        subtitle: Text('This dog is so cute!'),
                      ),
                      ListTile(
                        title: Text('Jane Smith'),
                        subtitle: Text('I love this dog!'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Color.fromARGB(255, 50, 80, 101),
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 0) {
            // Navigate to DogGridScreen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DogGridScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            // Navigate to ProfileScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
