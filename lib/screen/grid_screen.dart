import 'package:flutter/material.dart';
import 'package:project_akhir/api/dog_api.dart';
import 'package:project_akhir/components/dog.dart';
import 'detail_screen.dart';
import 'profile.dart';

class DogGridScreen extends StatefulWidget {
  @override
  _DogGridScreenState createState() => _DogGridScreenState();
}

class _DogGridScreenState extends State<DogGridScreen> {
  late Future<List<Dog>> futureDogs;
  int _selectedIndex = 0;
  List<Dog> _allDogs = [];
  List<Dog> _filteredDogs = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureDogs = fetchDogs();
    _searchController.addListener(_filterDogs);
  }

  // Function to fetch random dogs from API
  Future<List<Dog>> fetchDogs() async {
    List<Dog> dogs = [];
    for (int i = 0; i < 10; i++) {
      Dog dog = await DogService.fetchRandomDog();
      dogs.add(dog);
    }
    _allDogs = dogs;
    _filteredDogs = dogs;
    return dogs;
  }

  // Function to filter dogs based on search input
  void _filterDogs() {
    List<Dog> results = [];
    if (_searchController.text.isEmpty) {
      results = _allDogs;
    } else {
      results = _allDogs
          .where((dog) => dog.imageUrl
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredDogs = results;
    });
  }

  // Function to handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Dog Picture'),
        backgroundColor: Color.fromARGB(255, 50, 80, 101),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: SizedBox(
              height: 30.0,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(8.0),
                  prefixIcon: Icon(Icons.search, size: 20.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 15, 54, 80),
        child: Center(
          child: FutureBuilder<List<Dog>>(
            future: futureDogs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _filteredDogs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DogDetailScreen(
                              imageUrl: _filteredDogs[index].imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'dogImage${index}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    _filteredDogs[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Dog Archie ${index + 1}',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text('No data available');
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Bottom navigation bar item for home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Bottom navigation bar item for profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Color.fromARGB(255, 50, 80, 101),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DogGridScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
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
