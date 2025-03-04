import 'package:chatterly/domain/chat_model.dart';
import 'package:chatterly/domain/message_model.dart';
import 'package:chatterly/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // monitor authentication status
  Stream<User?> get authStateChanges => _auth.authStateChanges();

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
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //Sing Out
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  // get user data
  Future<UserModel> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    } else {
      throw Exception('User not found');
    }
  }

  // Get all users except the current user
  Stream<List<UserModel>> getAllUsersExceptCurrent(String currentUserId) {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => UserModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Search users by name or email
  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => UserModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Get all messages for a chat
  Future<bool> doesChatExist(String chatId) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    return chatDoc.exists;
  }

  // Create a new chat
  Future<void> createChat(String userId1, String userId2) async {
    final chatId = '${userId1}_$userId2';
    final chatExists = await doesChatExist(chatId);
    if (!chatExists) {
      await _firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'participants': [userId1, userId2],
        'createdAt': DateTime.now(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
      });
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final chatExists = await doesChatExist(chatId);
    if (!chatExists) {
      final participants = chatId.split('_');
      await createChat(participants[0], participants[1]);
    }

    // Add the message to the chat's messages collection
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
      'lastMessageTime': DateTime.now(),
    });

    // Send notification to the other user
    await _sendNotification(chatId, text);
  }

  // Get all chats for the current user
  Stream<List<ChatModel>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = <ChatModel>[];
          for (final doc in snapshot.docs) {
            final chatId = doc.id;
            final messagesSnapshot =
                await _firestore
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .get();
            if (messagesSnapshot.docs.isNotEmpty) {
              chats.add(ChatModel.fromMap(doc.data()));
            }
          }
          return chats;
        });
  }

  // Get chat messages
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Send notification using FCM
  Future<void> _sendNotification(String chatId, String message) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final participants = chatDoc['participants'] as List<dynamic>;
    final receiverId =
        participants.firstWhere((id) => id != currentUser!.uid) as String;

    final receiverDoc =
        await _firestore.collection('users').doc(receiverId).get();
    final receiverToken = receiverDoc['fcmToken'] as String?;

    if (receiverToken != null) {
      await _messaging.sendMessage(
        to: receiverToken,
        data: {'chatId': chatId, 'title': 'New Message', 'body': message},
      );
    }
  }

  // Save FCM token for the current user
  Future<void> saveFCMToken(String userId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  // Get user name
  Future<String> getUserName(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc['name'] as String;
  }

  // Get chat document
  Future<DocumentSnapshot<Map<String, dynamic>>> getChatDocument(
    String chatId,
  ) async {
    return await _firestore.collection('chats').doc(chatId).get();
  }

  // Get other user's name in a chat
  Future<String> getOtherUserName(String chatId, String currentUserId) async {
    try {
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      if (!chatDoc.exists) {
        return 'Unknown';
      }
      final participants = chatDoc['participants'] as List<dynamic>;
      final otherUserId =
          participants.firstWhere((id) => id != currentUserId) as String;
      final userDoc =
          await _firestore.collection('users').doc(otherUserId).get();
      if (!userDoc.exists) {
        return 'Unknown';
      }
      return userDoc['name'] as String;
    } catch (e) {
      print('Error getting other user name: $e');
      return 'Unknown';
    }
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    try {
      final messagesSnapshot =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat: $e');
      throw e;
    }
  }
}
