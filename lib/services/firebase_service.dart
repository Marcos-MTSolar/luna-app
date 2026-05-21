import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> buscarMemoria() async {
    try {
      final doc = await _firestore.collection('memoria').doc('luna').get();
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Erro ao buscar memória: $e');
    }
    return {
      'resumo': '',
      'fatos': [],
      'ultima_conversa': '',
    };
  }

  static Future<void> salvarConversa(
      String modo, List<MessageModel> mensagens) async {
    try {
      final docRef = _firestore.collection('conversas').doc();

      final mensagensJson = mensagens.map((m) => {
            'id': m.id,
            'role': m.role,
            'content': m.content,
            'timestamp': Timestamp.fromDate(m.timestamp),
            'mode': m.mode.toString().split('.').last, // 'message' ou 'presencial'
            'isNarrative': m.isNarrative,
          }).toList();

      await docRef.set({
        'modo': modo,
        'data': FieldValue.serverTimestamp(),
        'mensagens': mensagensJson,
      });

      // Atualiza a data da última conversa na memória base
      await _firestore.collection('memoria').doc('luna').set({
        'ultima_conversa': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao salvar conversa: $e');
    }
  }

  static Future<void> atualizarResumo(
      String novoResumo, List<String> novosFatos) async {
    try {
      await _firestore.collection('memoria').doc('luna').set({
        'resumo': novoResumo,
        'fatos': FieldValue.arrayUnion(novosFatos),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao atualizar resumo: $e');
    }
  }
}
