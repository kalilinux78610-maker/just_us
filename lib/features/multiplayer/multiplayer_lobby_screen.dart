import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/multiplayer_service.dart';
import '../../shared/widgets/premium_widgets.dart'; // Corrected import for SpicyBackground

class MultiplayerLobbyScreen extends ConsumerStatefulWidget {
  const MultiplayerLobbyScreen({super.key});

  @override
  ConsumerState<MultiplayerLobbyScreen> createState() => _MultiplayerLobbyScreenState();
}

class _MultiplayerLobbyScreenState extends ConsumerState<MultiplayerLobbyScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _hostRoom() async {
    setState(() => _isLoading = true);
    final service = ref.read(multiplayerServiceProvider);
    final roomCode = await service.createRoom();
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (roomCode != null) {
        context.push('/chat/$roomCode');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create a room. Check connection.')),
        );
      }
    }
  }

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room code must be 6 characters.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final service = ref.read(multiplayerServiceProvider);
    final success = await service.joinRoom(code);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.push('/chat/$code');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid code or room is inactive.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Chat & Play'),
      ),
      body: SpicyBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_rounded, size: 80, color: AppTheme.primaryPink),
                const SizedBox(height: 24),
                const Text(
                  'Connect with your partner',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Host a secure private room and share the 6-digit code, or join their room.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 48),
                if (_isLoading)
                  const CircularProgressIndicator(color: AppTheme.primaryPink)
                else ...[
                  ElevatedButton(
                    onPressed: _hostRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('HOST A ROOM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  const Text('OR JOIN ROOM', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                    style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      counterText: '',
                      hintText: '6-DIGIT CODE',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _joinRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('JOIN ROOM', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
