import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../services/firebase_service.dart';
import '../services/memory_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<MessageModel> _messages = [];
  MessageMode _currentMode = MessageMode.message;
  bool _isTyping = false;

  @override
  void dispose() {
    // Ao sair da tela, chamar FirebaseService para salvar conversa
    if (_messages.isNotEmpty) {
      FirebaseService.salvarConversa(_currentMode.toString().split('.').last, _messages);
      MemoryService.consolidarMemoria(_messages);
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final isNarrative = text.startsWith('*') && text.endsWith('*');
    
    // Detecta o modo a partir das palavras-chave
    final detectedMode = MessageModel.detectMode(text);
    final explicitMessage = [
      'te mando', 'mensagem', 'whatsapp', 'pelo celular'
    ].any((k) => text.toLowerCase().contains(k));

    setState(() {
      if (detectedMode == MessageMode.presencial) {
        _currentMode = MessageMode.presencial;
      } else if (explicitMessage) {
        _currentMode = MessageMode.message;
      }
      // Caso contrário, mantém o modo atual
    });

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
      mode: _currentMode,
      isNarrative: isNarrative,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _isTyping = true; // Mostra o indicador "Luna está digitando..."
    });

    _scrollToBottom();

    // Simula tempo de resposta da API
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        
        final lunaContent = _currentMode == MessageMode.presencial 
            ? '*sorrio suavemente te observando*' 
            : 'Acabei de ver sua mensagem!';
            
        _messages.add(MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: 'assistant',
          content: lunaContent,
          timestamp: DateTime.now(),
          mode: _currentMode,
          isNarrative: _currentMode == MessageMode.presencial && lunaContent.startsWith('*'),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Fundo chat
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF2D2D44),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 20,
                color: Colors.white54,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Luna',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                color: Color(0xFFE8A0BF),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner animado de modo de conversa
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFF2D2D44),
            child: Text(
              _currentMode == MessageMode.presencial
                  ? '*Encontro presencial*'
                  : '*Conversa por mensagem*',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Indicador Luna digitando
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Luna está digitando...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            
          // Campo de texto
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    // Texto narrativo (isNarrative: true) - Sem balão, centralizado e itálico
    if (message.isNarrative) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              message.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      );
    }

    final isUser = message.role == 'user';
    
    // Balão de texto normal
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF4A90D9) : const Color(0xFF2D2D44),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('HH:mm').format(message.timestamp),
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      color: const Color(0xFF1A1A2E),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE8A0BF), width: 1),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Digite ou use *asteriscos* para ações...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D44),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Color(0xFFE8A0BF)),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
