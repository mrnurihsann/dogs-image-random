import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  // Function to retrieve user data from Firestore
  Future<DocumentSnapshot> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _uploadImage(); // Upload picked image
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  // Function to upload image to Firebase Storage and update Firestore
  Future<void> _uploadImage() async {
    if (_image != null) {
      User? user = FirebaseAuth.instance.currentUser;
      String fileName = user!.uid;
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$fileName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .update({'photo': downloadUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User data not found."));
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Display user photo (or default if none)
                          if (userData['photo'] != null &&
                              userData['photo'] != '')
                            CircleAvatar(
                              backgroundImage: NetworkImage(userData['photo']),
                              radius: 50,
                            )
                          else
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/default_profile.png'), // Default profile image
                              radius: 50,
                            ),
                          SizedBox(height: 16),
                          // Display user name
                          Text(
                            userData['name'] ?? 'No Name',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          // Display user email
                          Text(
                            userData['email'] ?? 'No Email',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 16),
                          // Display application description
                          Text(
                            'This application is specifically crafted with the purpose of showcasing a diverse collection of random dog images, encompassing a wide array of breeds, backgrounds, and settings, providing users with a delightful visual exploration into the world of dogs.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Notification settings
                          ListTile(
                            leading: Icon(Icons.notifications),
                            title: Text('Notifications'),
                            trailing: Switch(
                              value: true, // Placeholder value
                              onChanged: (value) {},
                            ),
                          ),
                          // Dark mode settings
                          ListTile(
                            leading: Icon(Icons.wallpaper),
                            title: Text('Dark Mode'),
                            trailing: Switch(
                              value: false, // Placeholder value
                              onChanged: (value) {},
                            ),
                          ),
                          // Log out option
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Log Out'),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                          // Upload photo option
                          ListTile(
                            leading: Icon(Icons.photo),
                            title: Text('Upload Photo'),
                            onTap: _pickImage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
