import '../models/message_model.dart';
import 'firebase_service.dart';

const String SYSTEM_PROMPT_BASE = """
Você é Luna, mulher brasileira de 40 anos.
Mora no mesmo prédio que Marcos (o usuário).
Se conheceram no elevador há algumas semanas.
Mora com a amiga Clara, também 40 anos.

IDENTIDADE — nunca esqueça:
- Você é Luna. Apenas Luna. Sempre.
- Marcos é o vizinho. O que ele escrever
  é fala ou ação dele, nunca sua.
- Nunca fale inglês ou use expressões formais.
- Nunca repita frases sem sentido.
- Nunca quebre o personagem.

MEMÓRIA:
{RESUMO}

FATOS CONHECIDOS SOBRE MARCOS:
{FATOS}

REGRAS DE CONVERSA:
- Leia todo o histórico antes de responder.
- Nunca repita perguntas já feitas.
- Use informações anteriores naturalmente.
- Se errar, reaja com constrangimento natural
  e siga em frente.

MODO MENSAGEM:
- Mais informal, pode usar emojis
- Respostas mais curtas
- Pode demorar a responder às vezes

MODO PRESENCIAL:
- Descreva linguagem corporal com *asteriscos*
- Reaja a cheiros, toques, olhares
- Tensão crescente e natural

COMO FALAR:
- Linguagem brasileira: tô, tá, pra, né
- *Asteriscos* para ações e pensamentos
- Texto normal para falas
- Tímida por fora, carinhosa, misteriosa
""";

class MemoryService {
  /// 1. Busca memoria do Firebase
  /// 2. Injeta no template do system prompt
  /// 3. Retorna prompt completo
  static Future<String> montarSystemPrompt() async {
    final memoria = await FirebaseService.buscarMemoria();
    
    final resumo = memoria['resumo'] ?? 'Nenhum resumo anterior.';
    final List<dynamic> fatosList = memoria['fatos'] ?? [];
    final fatosFormatados = fatosList.map((f) => '- $f').join('\n');

    final systemPrompt = SYSTEM_PROMPT_BASE
        .replaceAll('{RESUMO}', resumo)
        .replaceAll('{FATOS}', fatosFormatados.isNotEmpty ? fatosFormatados : 'Ainda não há fatos definidos.');

    return systemPrompt;
  }

  /// Analisa conversa e extrai fatos novos como: preferências, eventos, datas
  /// Na prática, idealmente isso enviaria a conversa para a API extrair em JSON ou via LLM.
  static String extrairFatos(List<MessageModel> mensagens) {
    // Isto é um placeholder. No mundo real, usaríamos um call LLM aqui.
    // Exemplo simples de análise estática:
    for (var msg in mensagens) {
      final text = msg.content.toLowerCase();
      if (msg.role == 'user' && text.contains('gosto de')) {
        return 'Marcos mencionou algo de que gosta.';
      }
    }
    return ''; // Nenhum fato novo extraído estaticamente
  }

  /// Ao final de cada conversa:
  /// 1. Extrai fatos novos
  /// 2. Atualiza resumo no Firebase
  static Future<void> consolidarMemoria(List<MessageModel> mensagens) async {
    if (mensagens.isEmpty) return;

    // 1. Extrai fatos novos
    final String fatoExtraido = extrairFatos(mensagens);
    List<String> novosFatos = [];
    if (fatoExtraido.isNotEmpty) {
      novosFatos.add(fatoExtraido);
    }

    // Na prática, também geraríamos um novo `resumo` consolidado com IA integrando a conversa atual.
    // Aqui atualizaremos apenas se encontrarmos um resumo válido (usando um mock).
    String novoResumo = "Interação mais recente adicionada à memória. (Simulado)";

    // 2. Atualiza resumo no Firebase
    await FirebaseService.atualizarResumo(novoResumo, novosFatos);
  }
}
