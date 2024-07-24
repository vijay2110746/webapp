import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/pages/role_selection.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  // String? userId;
  User? user;
  String? victimId;
  String? volunteerId;



  @override
  Size get preferredSize => Size.fromHeight(60.0);

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RoleSelection()));
  }

  void checkTruth(String username) async{

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Got the victim ID');
      victimId = user!.uid;

      DocumentSnapshot<Map<String, dynamic>> victimDoc = await FirebaseFirestore.instance
          .collection('victims')
          .doc(victimId) // Assuming sender is the victimId
          .get();
      if (victimDoc.exists) {
        volunteerId = victimDoc.data()?['volunteerId'];
        if (volunteerId != null) {
          // Listen for real-time updates
          FirebaseFirestore.instance
              .collection('chats')
              .doc(volunteerId)
              .snapshots()
              .listen((documentSnapshot) async {
          if (documentSnapshot.exists) {
            final data = documentSnapshot.data();
            if (data != null && data.containsKey('chats')) {
              List<dynamic> chatArray = data['chats'];
              for (var chat in chatArray){
                if (chat is Map<String,dynamic> && chat.containsKey('messages') && chat['victimId']==victimId){
                  print('namma inga irukom');

                }else{
                  print("we are here");
                  DocumentSnapshot<Map<String,dynamic>> snap =  await FirebaseFirestore.instance.collection('accepted-posts').doc(victimId).get();
                  if (snap.exists) {
                    print('Accepted post found');
                    Map<String, dynamic>? postData = snap.data();
                    print(snap);
                    print(postData);
                    await FirebaseFirestore.instance.collection('posts').doc(victimId).set({
                      'posts':FieldValue.arrayUnion([postData])
                    });
                  }




                }
              }
              }}});
        }}
    } else {
      print("Didn't get the victim ID");
    }

  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedReason;
        final TextEditingController reportController = TextEditingController();

        return AlertDialog(
          title: Text('Report User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reportController,
                decoration: InputDecoration(
                  labelText: 'Who do you want to report?',
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedReason,
                items: [
                  DropdownMenuItem(
                    child: Text('No response'),
                    value: 'No response',
                  ),
                  DropdownMenuItem(
                    child: Text('Abusive'),
                    value: 'Abusive',
                  ),
                ],
                onChanged: (value) {
                  selectedReason = value;
                },
                decoration: InputDecoration(
                  labelText: 'Reason',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle report submission logic here
                String reportText = reportController.text;
                if (reportText.isNotEmpty && selectedReason != null) {
                  // Logic to handle the report
                  print('Reported user: $reportText');
                  print('Reason: $selectedReason');
                  checkTruth(reportText);
                }
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('LogOut?'),
          content: Text('Are you sure, you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RoleSelection()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.report,
          color: const Color.fromARGB(255, 0, 0, 0),
          size: 30,
        ),
        onPressed: () => _showReportDialog(context),
      ),
      title: Text(
        'Crisis.',
        style: TextStyle(
          fontFamily: 'Inter',
          color: const Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.logout_rounded,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 30,
          ),
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0, // Remove shadow/elevation
    );
  }
}
