import 'package:chatterly/domain/chat_model.dart';
import 'package:chatterly/domain/message_model.dart';
import 'package:chatterly/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Register user
  Future<void> registerUser(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
    });
  }

  // Login user
  Future<void> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Sing Out
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  // Search users by name or email
  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  // Create a new chat
  Future<void> createChat(String userId1, String userId2) async {
    final chatId = '${userId1}_$userId2';
    await _firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'participants': [userId1, userId2],
      'createdAt': DateTime.now(),
      'lastMessage': '',
    });
  }

  // Send a message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'messageId': DateTime.now().millisecondsSinceEpoch.toString(),
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': DateTime.now(),
    });

    // Update last message in the chat document
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
    });
  }

  // Get all chats for the current user
  Stream<List<ChatModel>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }

  // Get chat messages
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }
}
