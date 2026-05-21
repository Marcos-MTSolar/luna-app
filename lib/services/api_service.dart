import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  static const String API_URL = "http://100.127.52.14:11434/api/chat";

  static Future<String> enviarMensagem({
    required List<Map<String, dynamic>> historico,
    required String systemPrompt,
    required String mensagemAtual,
    required String modo,
  }) async {
    try {
      String finalSystemPrompt = systemPrompt;
      
      if (modo == "presencial") {
        finalSystemPrompt += "\nVocê está fisicamente presente com Marcos agora. Reaja com linguagem corporal e sensações físicas.";
      } else if (modo == "message") {
        finalSystemPrompt += "\nVocê está trocando mensagens com Marcos pelo celular. Seja mais informal e use emojis ocasionalmente.";
      }

      final List<Map<String, dynamic>> messages = [
        {"role": "system", "content": finalSystemPrompt},
        ...historico,
        {"role": "user", "content": mensagemAtual},
      ];

      final response = await http.post(
        Uri.parse(API_URL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "dolphin-llama3:8b",
          "messages": messages,
          "stream": false
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final reply = data["message"]["content"];
          return reply;
        } catch (_) {
          // Se não for JSON (ex: retorno em plain text), retorna o corpo da resposta
          return response.body;
        }
      } else {
        return "*Luna parece distraída no momento...*\nTenta de novo daqui a pouco?";
      }
    } on TimeoutException {
      return "*Luna parece distraída no momento...*\nTenta de novo daqui a pouco?";
    } catch (e) {
      return "*Luna parece distraída no momento...*\nTenta de novo daqui a pouco?";
    }
  }
}
