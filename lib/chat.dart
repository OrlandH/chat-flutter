import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import '../services/chat_service.dart';
import '../provider/user_provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final String currentUserName = Provider.of<UserProvider>(context).userName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _chatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                if (messages == null || messages.isEmpty) {
                  return const Center(child: Text('Aún no se han escrito mensajes.'));
                }

                final List<Widget> messageWidgets = [];
                messages.forEach((key, value) {
                  final message = value as Map<dynamic, dynamic>;
                  final sender = message['sender'];
                  final text = message['text'];
                  final location = message['location'];

                  if (location != null) {
                    final latitude = location['latitude'];
                    final longitude = location['longitude'];
                    messageWidgets.add(ListTile(
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$sender: ',
                              style: DefaultTextStyle.of(context).style,
                            ),
                            TextSpan(
                              text: 'Mi Ubicación',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch $url')),
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ));
                  } else {
                    messageWidgets.add(ListTile(
                      title: Text('$sender: $text'),
                    ));
                  }
                });

                return ListView(
                  children: messageWidgets,
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Ingrese su mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _chatService.sendMessage(currentUserName, _messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    _chatService.sendLocation(currentUserName, position.latitude, position.longitude);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
