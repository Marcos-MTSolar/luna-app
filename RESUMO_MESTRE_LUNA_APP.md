# RESUMO MESTRE — LUNA APP

## 1. VISÃO GERAL
- **Propósito do sistema**: Aplicativo de chat interativo focado em um companheiro virtual (Luna), que simula ser uma vizinha de 40 anos interagindo com o usuário (Marcos). O chat possui contextos automáticos baseados na interação (mensagem ou presencial).
- **Público-alvo**: Usuários que buscam uma interação e interpretação de papéis (Roleplay) com uma IA focada em imersão narrativa.
- **Estágio atual do projeto**: Protótipo avançado. O projeto apresenta múltiplas abordagens de frontend (Flutter, Ionic/Angular e React) coabitando o mesmo repositório, conectados a um backend serverless em Vercel e serviço Ollama.

## 2. STACK TECNOLÓGICA
- **Frontend**: O repositório contém três protótipos de frontend não integrados:
  - React/Vite (pasta `src/`) com TailwindCSS.
  - Angular + Ionic (pasta `luna-app/`).
  - Flutter (pasta `lib/`).
- **Backend**: Função serverless em Node.js (`luna-api/api/chat.js`).
- **Banco de dados e Storage**: Firebase Firestore (usado para memória e histórico de conversas). **NÃO HÁ** integração com Supabase Storage implementada no código.
- **Integrações externas**: Conexão com um servidor LLM Ollama (modelo `dolphin-llama3:8b`) via Vercel. **NÃO HÁ** integrações com Evolution API ou Railway implementadas.
- **Mobile**: Capacitor configurado na versão Angular/Ionic (`luna-app/capacitor.config.ts`) e versão nativa desenvolvida com Flutter.

## 3. ESTRUTURA DE ARQUIVOS
- **Mapa completo de pastas e arquivos**:
  - `/luna-api/`: Backend - Contém as configurações do Vercel (`vercel.json`) e o endpoint `api/chat.js`.
  - `/luna-app/`: Frontend Ionic/Angular - Contém o app em `/src/app/` com os serviços de memória, api e Firebase.
  - `/lib/`: Frontend Flutter - Contém `models/`, `screens/` e `services/` e a interface completa de chat.
  - `/src/`: Frontend React - Contém a tela inicial simulada `App.tsx` e `main.tsx`.
- **Responsabilidade de cada arquivo principal**:
  - `luna-api/api/chat.js`: Função serverless que atua como proxy, recebendo as mensagens e roteando para a instância do Ollama.
  - `lib/services/api_service.dart` / `luna-app/src/app/services/api.service.ts`: Gerenciam a comunicação do frontend com a API de IA, formatando e injetando o "System Prompt" correto na requisição.
  - `lib/services/memory_service.dart`: Responsável por montar o prompt de sistema mesclando os dados (resumo e fatos) do usuário com as regras base da persona (Luna).
  - `lib/services/firebase_service.dart`: Classe que interage de forma direta com o Firestore para carregar/salvar as memórias.

## 4. MÓDULOS E FUNCIONALIDADES
- **Módulo de Chat**: Permite o envio e recebimento de mensagens, identificando e injetando automaticamente no contexto se a interação está sendo via "mensagem" de celular (textos e emojis) ou modo "presencial" (textos narrativos usando asteriscos).
- **Módulo de Memória**: Salva todas as conversas do usuário e busca dinamicamente do Firebase os metadados consolidados (`resumo`, `fatos`), garantindo a continuidade narrativa (persistência de longo prazo).
- **Fluxo de uso de cada tela**:
  - **HomeScreen**: Exibe a foto/avatar de Luna, um indicador verde de status "Online agora" e o botão "Conversar".
  - **ChatScreen**: Exibe as trocas de mensagens na tela. Permite o envio pela caixa de texto de mensagens normais ou interações focadas em linguagem corporal (`*sorrio*`). Ao finalizar/sair do chat, o processo de consolidação de memória é disparado.

## 5. BANCO DE DADOS
- **Todas as tabelas (Coleções) e suas colunas no Firebase**:
  - `memoria` (Documento único e direto no Firestore: `luna`):
    - `resumo` (string)
    - `fatos` (array de strings)
    - `ultima_conversa` (timestamp)
  - `conversas` (Múltiplos documentos):
    - `modo` (string: "presencial" ou "message")
    - `data` (server timestamp)
    - `mensagens` (array de objetos. Em Flutter possui `id`, `role`, `content`, `timestamp`, `mode`, `isNarrative`)
- **Relacionamentos entre tabelas**: NoSQL puro baseado em documentos, sem relacionamento rígido por ids.
- **Regras de isolamento multi-tenant (company_id)**: **NÃO IMPLEMENTADAS NO CÓDIGO**. O sistema não é multi-tenant. Todos os dados são consolidados diretamente para uma única persona e num único documento chamado "luna".

## 6. INTEGRAÇÕES EXTERNAS
- **Evolution API (fluxo de envio e recebimento)**: **NÃO EXISTE NO CÓDIGO**. O software não integra com WhatsApp oficial. Toda troca de mensagens ocorre no próprio frontend nativo.
- **Supabase Storage (buckets, policies)**: **NÃO EXISTE NO CÓDIGO**.
- **Firebase (push notifications)**: **NÃO EXISTE NO CÓDIGO**. Firebase é usado de forma exclusiva para o Firestore Database Client. Não há Push Notifications.
- **Vercel (deploy e serverless)**: Função provisionada no Vercel (com duração máxima `maxDuration: 30`) para receber as mensagens do frontend e intermediar de forma segura o acesso com o endpoint da LLM.
- **Railway (Evolution API)**: **NÃO EXISTE NO CÓDIGO**.
- **Ollama LLM**: Integração manual com engine local/remota operando o `dolphin-llama3:8b`.

## 7. AUTENTICAÇÃO E SEGURANÇA
- **Fluxo de login e JWT**: **NÃO EXISTE NO CÓDIGO**. O acesso ao App é totalmente anônimo e direto.
- **Roles de usuário e permissões**: **NÃO EXISTE NO CÓDIGO**.
- **Middleware de autenticação**: **NÃO EXISTE NO CÓDIGO**. O acesso à API (`chat.js`) no Vercel está com permissões de CORS abertas de forma genérica para `*`.
- **Variáveis de ambiente críticas**: `OLLAMA_URL` no backend e `GEMINI_API_KEY` (somente em `.env.example`, mas ainda sem uso efetivo detectado no motor do app).

> ⚠️ ATENÇÃO: Falta de autenticação e regras abertas de CORS representam riscos severos, visto que o banco de dados pode ser sobreescrito a qualquer momento devido a ausência de regras no Firestore, e a API serverless pode ser abusada publicamente.

## 8. REGRAS DE NEGÓCIO
- **Todas as regras identificadas no código**: 
  - A IA precisa se comportar exclusivamente como Luna, e o usuário será sempre reconhecido como Marcos.
  - Modos de detecção automática: Se a mensagem contiver "elevador", "porta" ou "pessoalmente", a IA assume o comportamento **presencial**, usando asteriscos (*) nas respostas para simular linguagem corporal e tensão crescente.
  - O modo **mensagem** (ativo por termos como "whatsapp" ou "pelo celular") exige da IA respostas mais casuais e diretas, simulando a troca de mensagens real por celular.
- **Fluxo completo do funil de vendas**: **NÃO EXISTE NO CÓDIGO**. Trata-se de um app de roleplay, não voltado a vendas.
- **Fluxo completo do WhatsApp**: **NÃO EXISTE NO CÓDIGO**.
- **Segregação de visibilidade por role**: **NÃO EXISTE NO CÓDIGO**.

## 9. FLUXO DO WHATSAPP
> ⚠️ ATENÇÃO: Nenhuma das integrações reais com o mensageiro WhatsApp está presente no código-fonte. Este projeto atua apenas como um emulador conversacional com uma interface similar a um chat.
- **Envio de texto, áudio, imagem e documento**: Somente envio de texto puro é processado e suportado pelo backend na configuração atual da interface.
- **Recebimento via webhook**: **NÃO EXISTE NO CÓDIGO**.
- **Processamento e upload de mídia para o Storage**: **NÃO EXISTE NO CÓDIGO**.
- **Como a media_url é salva para from_me true e false**: **NÃO EXISTE NO CÓDIGO**.
- **Instâncias configuradas e seus propósitos**: **NÃO EXISTE NO CÓDIGO**.

## 10. BUILD E DEPLOY
- **Processo de build do frontend**:
  - React (em `/src/`): Build feito via vite, `npm run build`.
  - Angular/Ionic (em `/luna-app/`): Build pelo Angular CLI (`ng build`).
  - Flutter (em `/lib/`): Segue fluxo padrão nativo `flutter build`.
- **Deploy na Vercel (serverless functions)**: O projeto contido em `/luna-api/` efetua deploy via Vercel conectando a rota `api/chat`.
- **Variáveis de ambiente necessárias**: `OLLAMA_URL` precisará estar exposta na Vercel para o funcionamento da LLM.
- **Mobile com Capacitor**: Funcional na versão Angular configurada com `capacitor.config.ts`. A pasta `android` já existe com as configurações da plataforma de empacotamento.

## 11. PROBLEMAS RESOLVIDOS
- Não constam no código, branches atuais ou histórico em texto quaisquer problemas de bugfixing específicos e resolvidos com suas respectivas causas raiz e soluções aplicadas.

## 12. DÉBITOS TÉCNICOS
- **Problemas conhecidos ainda não resolvidos**:
  - Extração de Fatos Mockada: O método `extrairFatos` no Flutter e Angular está fixado com lógicas genéricas de estáticas em código (`return 'Marcos mencionou algo de que gosta.'`), ou seja, as novas memórias baseadas nos textos longos não estão ativas usando um LLM de análise.
  - Endpoints Fixados: A URL de requisição à API `http://100.127.52.14:11434/api/chat` está escrita diretamente no código `api_service.dart`.
  - Fragmentação do código: Existem três projetos de frontend separados e não unificados na estrutura geral.
- **Riscos identificados no código**:
  - A API em Vercel tem livre trânsito devido as propriedades de Cross-Origin expostas.

> ⚠️ ATENÇÃO: O código da aplicação cliente expõe chamadas para modificação na API do Firebase e em memória local. A ausência de regras de escrita nos documentos do Firebase (Firestore Rules) é uma falha passível de modificação por qualquer parte externa não autenticada.

## 13. BACKLOG E MELHORIAS SUGERIDAS
- **Funcionalidades pendentes**:
  - Implementar de forma concreta o algoritmo/agent de LLM em `extrairFatos()` que recebe a transcrição do último chat com a Luna, analisa os dados, e insere os novos comportamentos no array de fatos conhecidos.
  - Desenvolver o mecanismo de autenticação via Firebase para isolamento real das instâncias caso o projeto seja lançado para mais usuários.
- **Melhorias técnicas recomendadas**:
  - Unificar de vez os três repositórios em apenas uma linguagem definitiva.
  - Utilizar Variáveis de Ambiente locais e em Produção para as rotas da API em detrimento das Strings injetadas nos services.
- **Ordem de prioridade sugerida**:
  1. Padronizar em um único front-end que será assumido de forma oficial.
  2. Implementar autenticação básica Firebase.
  3. Adicionar Variáveis de Ambiente no front.
  4. Finalizar o fluxo de extração de memória da IA via LLM.

## 14. VARIÁVEIS DE AMBIENTE
- **Lista completa de todas as variáveis necessárias**:
  - `OLLAMA_URL`: Obrigatório. URL de apontamento para a infraestrutura que roda o modelo Ollama.
  - `GEMINI_API_KEY`: Em teste ou como reserva (consta apenas em `.env.example`).
  - `APP_URL`: URL base do projeto (consta apenas em `.env.example`).
- **Onde cada uma é usada**: Somente a `OLLAMA_URL` é de fato consumida de forma real pelo Node na linha 41 do arquivo `/luna-api/api/chat.js`. As outras estão referenciadas sem utilidade prática no momento.
- **Quais são seguras para o frontend (VITE_) e quais são apenas para o backend**: No código atual não foram configuradas variáveis de ambiente do tipo `VITE_` ou congêneres de modo de injeção front-end seguro. Todas as listadas são sensíveis e devem atuar apenas na API Serverless ou Backend.
