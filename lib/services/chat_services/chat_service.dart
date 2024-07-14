import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_chat_app/models/message.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';

class ChatService {
  // get instance of fireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    // you can also call the firebase auth instance to get the current user details
    final String currentUserID = _authService.getCurrentUser()!.uid;
    final String currentUserEmail = _authService.getCurrentUser()!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID fot the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatroomID is the same fot any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID fot the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
