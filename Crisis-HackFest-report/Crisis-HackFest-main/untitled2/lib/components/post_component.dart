import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:untitled2/pages/content_state.dart';

class Content extends StatefulWidget {
  final String? profilePicUrl;
  final String name;
  final String? priorityLevel;
  final String? mobilenumber;
  final String item;
  final String? headcount;
  final String? location;
  final String content;
  final String? imageUrl;
  final String? role;
  final String? landmark;
  final String id;
  final String? medicalsupplies;
  final Timestamp? time;

  Content({
    this.profilePicUrl,
    required this.name,
    this.priorityLevel,
    this.mobilenumber,
    required this.item,
    this.headcount,
    this.location,
    required this.content,
    this.imageUrl,
    this.landmark,
    this.role,
    required this.id,
    this.medicalsupplies,
    this.time,
  });

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  bool isExpanded = false;
  User? user;
  String? userId;
  String? volunteerName;
  bool isLiked = false;
  DateTime? dateTime;

  void shareText() {
    Share.share('Check out this cool content: ${widget.content}', subject: 'Look what I found!');
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user!.uid;
    } else {
      print('User is not logged in');
    }
    print(widget.time);
    if (widget.time != null) {
      dateTime = widget.time!.toDate();
      print('date $dateTime');
    }
  }

  Future<void> _createChat() async {
    user = FirebaseAuth.instance.currentUser;
    if (userId == null) {
      print('User ID is null');
      return;
    }

    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if(data!=null){
          volunteerName = data['name'];
        }
      }
      }


    Map<String,dynamic> newPost = {
      'volunteerId': userId,
      'volunteerName':volunteerName,
      'victimId': widget.id,
      'victimName': widget.name,
      'victimLocation': widget.location,
      'message': widget.content,
      'priorityLevel': widget.priorityLevel,
      'victimMobileNumber': widget.mobilenumber,
      'item': widget.item,
      'headcount': widget.headcount,
      'timestamp': Timestamp.now(),
    };
    // newPost['timestamp'] = FieldValue.serverTimestamp();



    try {
      await FirebaseFirestore.instance.collection('chats').doc(userId).set({
        'chats':FieldValue.arrayUnion([newPost])},SetOptions(merge: true)
      );

      await FirebaseFirestore.instance
          .collection('victims')
          .doc(widget.id)
          .set({
        'volunteerId': userId,
        'chatAccepted': true,
      });
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.id)
          .update({
        'posts': FieldValue.arrayRemove([
          {
            'name': widget.name,
            'area': widget.location,
            'postcontent': widget.content,
            'prioritylevel': widget.priorityLevel,
            'phonenumber': widget.mobilenumber,
            'headcount': widget.headcount,
            'item': widget.item,
            'role': widget.role,
            'uid': widget.id
          }
        ])
      });

      print('Chat created successfully');
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = '';
    String date = '';
    String time = '';

    if (dateTime != null) {
      formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime!);
      print('Formatted Date and Time: $formattedDateTime');
      date = formattedDateTime.split(' ')[0];
      time = formattedDateTime.split(' ')[1];
    }
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: widget.profilePicUrl != null &&
                        widget.profilePicUrl!.isNotEmpty
                        ? NetworkImage(widget.profilePicUrl!)
                        : AssetImage('assets/images/default_profile.jpg')
                    as ImageProvider,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.location!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (widget.role == 'victim') ...[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.cancel_outlined, color: Colors.red[700]),
                    ),
                    IconButton(
                      onPressed: _createChat,
                      icon: Icon(Icons.check_circle_outline,
                          color: Colors.green[700]),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 30,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(218, 159, 7, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        widget.role!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  if (widget.priorityLevel != null &&
                      widget.priorityLevel!.isNotEmpty)
                    Container(
                      height: 30,
                      width: 85,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(166, 83, 230, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          widget.priorityLevel!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  SizedBox(width: 5),
                  Container(
                      height: 30,
                      // width: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Center(
                          child: Text(
                            widget.item,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.mobilenumber != null) ...[
                    Text(
                      'Mobile Number : ' + widget.mobilenumber!,
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  SizedBox(height: 10,),
                  if (widget.landmark != null) ...[
                    Text(
                      'Landmark of the charging station : ' + widget.landmark!,
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 10,),
                  ],
                  if(widget.item == 'boat') ...[
                    Text(
                      'My Boat can carry ${widget.headcount} people',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  if(widget.item == 'food') ...[
                    Text(
                      'I have food for ${widget.headcount} people',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  if(widget.medicalsupplies != null) ...[
                    Text(
                      'Medical Suppies have : "${widget.medicalsupplies}"',
                      maxLines: isExpanded ? null : 4,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                  if(widget.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.imageUrl!,
                        loadingBuilder: (context, child, progress) {
                          return progress == null ? child : CircularProgressIndicator();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Error loading image');
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 20,),
                  Text(
                    widget.content,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Read less' : 'Read more',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 8.0)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: shareText,
                    icon: Icon(Icons.share, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.messenger_outline_rounded,
                        color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(height: 20),
                  if (widget.time != null) ...[
                    Text(
                      '$date',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600],),
                    ),
                  ],
                  Spacer(),
                  if (widget.time != null) ...[
                    Text(
                      '$time',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600],),
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}