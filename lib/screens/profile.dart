import 'package:flutter/material.dart';
import 'package:golddigger/utils/navigation.dart';
import '../services/database_service.dart';
import 'dart:io';
import '../widgets//avatar.dart';
import '../widgets/navbuttons.dart';

//IS THIS USED???

class ProfileScreen extends StatefulWidget {
  final int userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  int totalPoints = 0;
  List<String> libraryPhotos = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final db = await DatabaseService().database;

      // Fetch user data
      final userResult = await db.query(
        'users',
        where: 'user_id = ?',
        whereArgs: [widget.userId],
      );

      print('User result: $userResult'); // Debug: Check user query result

      if (userResult.isNotEmpty) {
        setState(() {
          username = userResult[0]['username'] as String;
          totalPoints = userResult[0]['gold'] as int;
        });
      } else {
        print('No user found for userId: ${widget.userId}');
      }

      // Fetch user's photos
      final photosResult = await db.query(
        'photos',
        where: 'user_id = ?',
        whereArgs: [widget.userId],
        orderBy: 'uploaded_at DESC', // Ensure the photos are sorted by upload date
      );

      print('Photos result: $photosResult'); // Debug: Check photos query result

      setState(() {
        libraryPhotos = photosResult.map((photo) => photo['url'] as String).toList();
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        automaticallyImplyLeading: false, // Disable default back button
        leading: CustomBackButton()
      ),
      body: Container(
        color: const Color(0xFF333333), // Dark gray background
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                AvatarDisplay(size: 80.0),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@$username (User ID: ${widget.userId})',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Total points: $totalPoints',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () async {
                gotoNamed(context, '/editprofile',() => setState(() {}));
              }, // onPressed
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Library Section
            const Text(
              'Library',
              style: TextStyle(
                fontSize: 18,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: libraryPhotos.isEmpty
                  ? Center(
                      child: Text(
                        'No photos available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: libraryPhotos.length,
                      itemBuilder: (context, index) {
                        return _buildImage(libraryPhotos[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1, context: context, selectedcolor: Colors.grey,)// color is gray so that it appears like nothing is selected
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('assets')) {
      // Load from assets
      return Image.asset(url, fit: BoxFit.cover);
    } else {
      // Assume the file is stored locally (internal/external)
      final file = File(url);
      return file.existsSync()
          ? Image.file(file, fit: BoxFit.cover)
          : Icon(Icons.broken_image, color: Colors.grey); // Handle missing file
    }
  }
}
