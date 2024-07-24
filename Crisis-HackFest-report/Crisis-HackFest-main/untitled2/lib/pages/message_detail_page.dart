import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'message_category.dart';

class MessageDetailPage extends StatefulWidget {
  final String victimId; // Add victimId as a parameter
  final Message message;
  final List<Message> categoryMessages;
  final String victimName;

  const MessageDetailPage({
    Key? key,
    required this.victimId,
    required this.message,
    required this.categoryMessages,
    required this.victimName,
  }) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  List<Message> messages = [];
  TextEditingController _controller = TextEditingController();
  String? volunteerId;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      volunteerId = user.uid;
      _fetchMessages();
    } else {
      print('Invalid volunteer ID');
    }
  }

  void _fetchMessages() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(volunteerId)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null && data.containsKey('chats')) {
          List<dynamic> chatArray = data['chats'];
          for (var chat in chatArray) {
            if (chat is Map<String, dynamic> && chat['victimId'] == widget.victimId) {
              setState(() {

                messages = (chat['messages'] as List<dynamic>).map((messageData) {
                  return Message(
                    sender: messageData['sender'],
                    content: messageData['content'],
                    unreadCount: 0,
                    type: messageData['type'],
                    victimId: widget.victimId, // Add victimId
                  );
                }).toList();
              });
              return;
            }
          }
        }
      }
    });
  }

  void _sendImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    try {
      String fileName = Uuid().v1();
      var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
      var uploadTask = await ref.putFile(imageFile!);
      String imageUrl = await uploadTask.ref.getDownloadURL();
      _sendImageMessage(imageUrl: imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _sendImageMessage({required String imageUrl}) async {
    final message = Message(
      sender: 'Volunteer',
      content: imageUrl,
      unreadCount: 0,
      type: 'image',
      victimId: widget.victimId, // Add victimId
    );

    setState(() {
      messages.add(message);
    });

    final messageData = {
      'sender': 'Volunteer',
      'content': imageUrl,
      'timestamp': Timestamp.now(),
      'type': 'image',
    };

    await _updateChatMessages(messageData);
  }

  void _sendTextMessage() async {
    final content = _controller.text;

    if (content.isNotEmpty) {
      final message = Message(
        sender: 'Volunteer',
        content: content,
        unreadCount: 0,
        type: 'text',
        victimId: widget.victimId, // Add victimId
      );

      setState(() {
        messages.add(message);
        _controller.clear();
      });

      final messageData = {
        'sender': 'Volunteer',
        'content': content,
        'timestamp': Timestamp.now(),
        'type': 'text',
      };

      await _updateChatMessages(messageData);
    }
  }
  Future<void> _updateChatMessages(Map<String, dynamic> messageData) async {
    if (volunteerId != null && widget.victimId != null) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(volunteerId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey('chats')) {
          List<dynamic> chatArray = data['chats'];
          bool chatFound = false;

          for (var chat in chatArray) {
            if (chat is Map<String, dynamic> && chat['victimId'] == widget.victimId) {
              chatFound = true;
              if (chat.containsKey('messages')) {
                List<dynamic> messages = chat['messages'];
                messages.add(messageData);
                chat['messages'] = messages;
              } else {
                chat['messages'] = [messageData];
              }
              break;
            }
          }

          if (!chatFound) {
            chatArray.add({
              'victimId': widget.victimId,
              'messages': [messageData]
            });
          }

          await FirebaseFirestore.instance
              .collection('chats')
              .doc(volunteerId)
              .update({'chats': chatArray});
        } else {
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(volunteerId)
              .set({
            'chats': [
              {
                'victimId': widget.victimId,
                'messages': [messageData]
              }
            ]
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(volunteerId)
            .set({
          'chats': [
            {
              'victimId': widget.victimId,
              'messages': [messageData]
            }
          ]
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.victimName} Victim'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.sender == 'Volunteer'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: message.sender == 'Volunteer' ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: message.type == 'image'
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(message.content, fit: BoxFit.cover),
                    )
                        : Text(message.content),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: _sendImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendTextMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
