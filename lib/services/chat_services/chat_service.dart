import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_chat_app/models/message.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // get instance of fireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //_auth this is used to get the the user ID if you didn't want to use the getCurrentUser mehtod in AuthService

  // GET ALL USER STREAM
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // get all users except current user
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
      // return snapshot.docs.map((doc) {
      //   // go through each individual user
      //   final user = doc.data();
      //   // return user
      //   return user;
      // }).toList();
    });
  }

  // GET ALL USERS STREAM EXCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getUsersExcludingBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      // get all users
      final userSnapshot = await _firestore.collection('Users').get();

      // returns as stream list, excluding current user and blocked users
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // SEND MESSAGE
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

  // GET MESSAGE
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

  // REPORT USER
  Future<void> reportUser(String message, String userID) async {
    String currentUser = _authService.getCurrentUser()!.uid;
    final report = {
      'reportedBy': currentUser,
      'message': message,
      'userID': userID,
      'timeStamp': Timestamp.now(),
    };

    await _firestore.collection('Reports').add(report);
  }

  // BLOCK USER
  Future<void> blockUser(String userID) async {
    final currentUserID =
        _auth.currentUser!.uid; // _authService.getCurrentUser()!.uid;
    _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});

    notifyListeners();
  }

  // UNBLOCK USER
  Future<void> unblockUser(String blockedUserID) async {
    final currentUserID = _authService.getCurrentUser()!.uid;

    _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('BlockedUsers')
        .doc(blockedUserID)
        .delete();
  }

  // GET BLOCKED USERS STREAM
  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userID) {
    // final currentUserID = _auth.currentUser!.uid;

    return _firestore
        .collection('Users')
        .doc(userID)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('Users').doc(id).get()),
      );

      // return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
