import 'package:firebase_database/firebase_database.dart';

class ChatService {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');

  Stream<DatabaseEvent> getMessages() {
    return _messagesRef.onValue;
  }

  Future<void> sendMessage(String sender, String text) async {
    await _messagesRef.push().set({
      'sender': sender,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> sendLocation(String sender, double latitude, double longitude) async {
    await _messagesRef.push().set({
      'sender': sender,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
