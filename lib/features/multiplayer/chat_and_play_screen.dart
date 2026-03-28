import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/multiplayer_service.dart';
import '../../data/repositories/truth_or_dare_data.dart';
import '../../data/models/truth_or_dare_item.dart';
import '../../shared/widgets/premium_widgets.dart'; // Corrected import for SpicyBackground

class ChatAndPlayScreen extends ConsumerStatefulWidget {
  final String roomCode;
  const ChatAndPlayScreen({super.key, required this.roomCode});

  @override
  ConsumerState<ChatAndPlayScreen> createState() => _ChatAndPlayScreenState();
}

class _ChatAndPlayScreenState extends ConsumerState<ChatAndPlayScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(multiplayerServiceProvider).sendMessage(widget.roomCode, text);
    _messageController.clear();
  }

  void _sendRandomDare() {
    final items = TruthOrDareData.items.where((i) => 
      i.category == TodCategory.longDistance || 
      i.category == TodCategory.spicyDare
    ).toList();
    
    if (items.isEmpty) return;
    
    final random = Random();
    final randomDare = items[random.nextInt(items.length)];
    
    ref.read(multiplayerServiceProvider).sendMessage(
      widget.roomCode, 
      "I dare you: ${randomDare.content}", 
      isDare: true,
      dareId: randomDare.id
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(multiplayerServiceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Room: ${widget.roomCode}', style: const TextStyle(letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // Share room code logic
            },
          ),
        ],
      ),
      body: SpicyBackground(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: service.getMessagesStream(widget.roomCode),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading messages', style: TextStyle(color: Colors.white)));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.primaryPink));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final isMe = data['senderId'] == service.currentUserUid(); // Need to add this helper
                      final isDare = data['isDare'] ?? false;

                      return _ChatBubble(
                        text: data['text'] ?? '',
                        isMe: isMe,
                        isDare: isDare,
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Colors.orangeAccent),
            onPressed: _sendRandomDare,
            tooltip: 'Send Random Dare',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.primaryPink,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isDare;

  const _ChatBubble({
    required this.text,
    required this.isMe,
    required this.isDare,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDare 
            ? Colors.orangeAccent.withOpacity(0.8) 
            : (isMe ? AppTheme.primaryPink.withOpacity(0.8) : Colors.white10),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          border: isDare ? Border.all(color: Colors.white30, width: 1) : null,
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDare)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text('DARE CHALLENGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                ],
              ),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
