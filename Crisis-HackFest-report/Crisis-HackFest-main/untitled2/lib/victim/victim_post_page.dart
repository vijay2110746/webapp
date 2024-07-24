import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/post_component.dart';
import 'package:untitled2/victim/victimpostcomponent.dart'; // Make sure the import path is correct

class VictimPosts extends StatelessWidget {
  const VictimPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return const VictimPostsPage();
  }
}

class VictimPostsPage extends StatefulWidget {
  const VictimPostsPage({super.key});

  @override
  State<VictimPostsPage> createState() => _VictimPostsPageState();
}

class _VictimPostsPageState extends State<VictimPostsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isTranslated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.translate, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isTranslated = !_isTranslated;
                });
              },
            ),
            // const Align(
            //   alignment: Alignment.center,
            //   child: Icon(Icons.translate), // Replace with the desired icon
            // ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('posts-volunteer').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No posts available'),
                    );
                  }

                  // Flatten the array of posts
                  List<Map<String, dynamic>> posts = [];
                  for (var doc in snapshot.data!.docs) {
                    List<dynamic> docPosts = doc['posts'];
                    for (var post in docPosts) {
                      posts.add(post as Map<String, dynamic>);
                    }
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Content(
                          name: post['name'],
                          location: post['area'],
                          content: _isTranslated ? post['translatedpostcontent'] : post['postcontent'],
                          priorityLevel: post['prioritylevel'],
                          mobilenumber: post['phonenumber'],
                          headcount: post['headcount'],
                          item: post['item'],
                          role: post['role'],
                          id: post['uid'],
                          landmark: post['landmark'],
                          medicalsupplies: post['medicalSupplies'],
                          imageUrl: post['mediaUrl'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}