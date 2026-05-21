enum MessageMode {
  message,
  presencial,
}

class MessageModel {
  final String id;
  final String role; // "user" ou "assistant"
  final String content;
  final DateTime timestamp;
  final MessageMode mode;
  final bool isNarrative; // true se começa com *

  MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    required this.mode,
    required this.isNarrative,
  });

  /// Analisa o texto e retorna o modo correspondente baseado em palavras-chave.
  static MessageMode detectMode(String text) {
    final lowerText = text.toLowerCase();

    final presencialKeywords = [
      'elevador',
      'porta',
      'corredor',
      'pessoalmente',
      'estou indo',
      'abro a porta',
    ];

    final mensagemKeywords = [
      'te mando',
      'mensagem',
      'whatsapp',
      'pelo celular',
    ];

    // Verifica palavras-chave para o modo presencial
    for (final keyword in presencialKeywords) {
      if (lowerText.contains(keyword)) {
        return MessageMode.presencial;
      }
    }

    // Verifica palavras-chave para o modo mensagem (texto)
    for (final keyword in mensagemKeywords) {
      if (lowerText.contains(keyword)) {
        return MessageMode.message;
      }
    }

    // Modo padrão se não houver palavras-chave, 
    // a aplicação pode preferir usar o estado anterior.
    return MessageMode.message;
  }
}
