import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final multiplayerServiceProvider = Provider<MultiplayerService>((ref) {
  return MultiplayerService();
});

class MultiplayerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserUid() => _auth.currentUser?.uid;

  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      // Log error (consider using a proper logger)
      return null;
    }
  }

  // Create a new room and return its code (random or custom)
  Future<String?> createRoom({String? customCode}) async {
    final user = await signInAnonymously();
    if (user == null) return null;

    final roomCode = (customCode != null && customCode.isNotEmpty) 
        ? customCode.toUpperCase() 
        : _generateRoomCode();
        
    // Check if room already exists and is active
    final existing = await _firestore.collection('rooms').doc(roomCode).get();
    if (existing.exists && (existing.data()?['isActive'] ?? false)) {
      // If custom code is taken, return null to show error (or handle differently)
      if (customCode != null) throw Exception('Room code already in use');
    }

    await _firestore.collection('rooms').doc(roomCode).set({
      'hostId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'players': [user.uid],
    });
    return roomCode;
  }

  // Join an existing room
  Future<bool> joinRoom(String roomCode) async {
    final user = await signInAnonymously();
    if (user == null) return false;

    final roomDoc = await _firestore.collection('rooms').doc(roomCode).get();
    if (roomDoc.exists && roomDoc.data()?['isActive'] == true) {
      await _firestore.collection('rooms').doc(roomCode).update({
        'players': FieldValue.arrayUnion([user.uid]),
      });
      return true;
    }
    return false;
  }

  // Send a message or a dare to the room
  Future<void> sendMessage(String roomCode, String text, {bool isDare = false, String? dareId}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('rooms').doc(roomCode).collection('messages').add({
      'senderId': user.uid,
      'text': text,
      'isDare': isDare,
      'dareId': dareId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Listen to messages in a room
  Stream<QuerySnapshot> getMessagesStream(String roomCode) {
    return _firestore
        .collection('rooms')
        .doc(roomCode)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _generateRoomCode() {
    // Generate a random 6-character alphanumeric code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
