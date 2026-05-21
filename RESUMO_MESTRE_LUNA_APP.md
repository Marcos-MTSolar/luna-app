---

# RESUMO MESTRE — LUNA APP

## 1. VISÃO GERAL
- **Propósito do sistema**: Aplicativo de chat focado em interações e Roleplay com a "Luna", uma persona simulada (vizinha de 40 anos interagindo com o usuário Marcos). O app processa indicadores emocionais da persona de forma fluída (humor, afeto, energia e sincronia).
- **Público-alvo**: Usuários em busca de imersão narrativa e interação textual baseada em linguagem corporal e conversacional com uma Inteligência Artificial.
- **Estágio atual do projeto**: Protótipo funcional avançado. A stack de frontend em React acaba de ser integrada ao backend (Vercel Serverless para LLM) e ao Firebase (memória dinâmica), embora o repositório ainda possua versões legadas (Flutter e Angular) coabitando na raiz.

## 2. STACK TECNOLÓGICA
- **Frontend**: React (construído com Vite), estilizado com Tailwind CSS e integração de ícones Lucide (localizado na pasta `src/`).
- **Backend**: API Serverless desenvolvida em Node.js (`luna-api/api/chat.js`) orquestrada via Vercel.
- **Banco de dados e Storage**: Firebase Firestore para armazenamento NoSQL (lida com os dados de histórico emocional, fatos e resumos da interface). **Não há** integração ou uso de Supabase Storage.
- **Integrações externas**: Conexão backend direta a uma instância do modelo LLM Ollama (`dolphin-llama3:8b`). **Não existem** integrações de sistemas legados de envio (como Evolution API ou WhatsApp real).
- **Mobile**: Construído para atuar majoritariamente de forma responsiva como PWA via React/Vite. Menções de mobile nativo existem devido às pastas inativas do Capacitor (`luna-app/capacitor.config.ts`) e projeto Dart (`lib/`).

## 3. ESTRUTURA DE ARQUIVOS
- **Mapa completo de pastas e arquivos**:
  - `/src/`: Frontend React funcional, dividido em `/components` e `/services`. Responsável por toda a UI dinâmica atual.
  - `/luna-api/`: Serviços da API Backend Serverless.
  - `/lib/`: Código legado em Flutter/Dart contendo modelos, telas e serviços inativos.
  - `/luna-app/`: Projeto legado em Ionic/Angular que estava em andamento.
  - `/vercel.json`: Arquivo mestre na raiz do projeto contendo as regras de `rewrites` para a Vercel, delegando `/api/*` à função serverless e a raiz ao React estático.
  - `/package.json`: Repositório de gerenciamento dos scripts NPM e bibliotecas instaladas da versão React (`vite`, `firebase`, `tailwindcss`, etc).
- **Responsabilidade de cada arquivo principal**:
  - `src/components/LunaScreen.tsx`: Motor principal do painel interativo; une o ChatInput, painel de Avatares, painel de Memória e controle de emoções em uma grid flexível, ativando useEffects que puxam e atualizam métricas em tempo real.
  - `src/services/firebase.ts`: Exporta a configuração direta de comunicação do front-end com as credenciais do Firestore.
  - `luna-api/api/chat.js`: Proxy isolado entre o usuário e a inteligência artificial. Injera o prompt de formatação mandatória (System Instructions), bate na API do Ollama e formata os retornos num JSON confiável para atualizar os componentes front-end.

## 4. MÓDULOS E FUNCIONALIDADES
- **Descrição detalhada de cada módulo**:
  - **Interação (ChatInput & Avatar)**: Permite envio livre de mensagens com sugestões do que falar baseadas na interpretação de momento (entregues dinamicamente pela própria IA).
  - **Memória Lateral (MemoryPanel)**: Interface que mostra visualmente os metadados consumidos da base no Firebase. Demonstra resumos, fatos da vida e momentos da narrativa.
  - **Monitoramento Emocional (EmotionalIndicators)**: Feedback visual na interface mostrando o nível de "Humor", "Energia", "Sincronia" e "Afeto", decodificado diretamente pela LLM no momento da resposta.
- **Fluxo de uso de cada tela**: Todo o acesso desemboca em uma única tela SPA, dividida em colunas em desktop. Toda vez que uma mensagem é enviada, a Vercel chama o Ollama, o JSON de retornos reflete visualmente imediatamente e um espelho do estado emocional daquele minuto é injetado no Firebase Firestore pelo cliente.

## 5. BANCO DE DADOS
- **Todas as tabelas e suas colunas (Firestore)**:
  - `memoria` (Documento único de chaves em uma coleção aberta chamada "memoria", sob o ID "luna"):
    - `resumo` (String contendo parágrafo de resumo momentâneo).
    - `fatos` (Array de strings listando propriedades/preferências).
    - `padroes_usuario` (Array de comportamentos observados).
    - `estado_emocional` (Objeto atual com propriedades de afeto/humor).
    - `historico_emocional` (Matriz com objetos timestamp + estado da sessão).
- **Relacionamentos entre tabelas**: O aplicativo opera em arquitetura NoSQL Plana; sem chaves relacionais declaradas na estrutura de dados do código atual.
- **Regras de isolamento multi-tenant (company_id)**: **Não implementado no código**. A aplicação opera totalmente em caráter single-tenant, forçando todos os acessos a utilizarem o exato mesmo documento `"luna"`.

## 6. INTEGRAÇÕES EXTERNAS
- **Evolution API (fluxo de envio e recebimento)**: **Inexistente**. Não há trocas via WhatsApp oficial nem menções funcionais do tipo.
- **Supabase Storage (buckets, policies)**: **Inexistente**.
- **Firebase (push notifications)**: **Inexistente**. Somente o Cloud Firestore Data Storage está implementado em nível transacional.
- **Vercel (deploy e serverless)**: Atua como hospedeiro central provendo o React Bundle com o `@vercel/static-build` e as funções serverless de orquestração via `@vercel/node`.
- **Railway (Evolution API)**: **Inexistente**.

## 7. AUTENTICAÇÃO E SEGURANÇA
- **Fluxo de login e JWT**: **Inexistente**. O usuário abre a página e inicia a conversa sem autenticação.
- **Roles de usuário e permissões**: **Inexistente**.
- **Middleware de autenticação**: **Inexistente** (O CORS em `/api/chat.js` permite `*`).
- **Variáveis de ambiente críticas**: O código depende obrigatoriamente da env `OLLAMA_URL` no back-end para viabilizar as inferências. O front possui credenciais estáticas do Firebase sem tratativa baseada no cliente.

> ⚠️ ATENÇÃO: As credenciais do Firebase (apiKey, appId) estão vazadas em `firebase.ts` como plain text, e dada a ausência do Firebase Authentication em pareamento com o Firestore Rules, as chaves presentes dão a qualquer observador direitos irrestritos de modificar/deletar completamente o histórico emocional e memórias dos usuários se essas rules não estiverem travadas no painel da infraestrutura.

## 8. REGRAS DE NEGÓCIO
- **Todas as regras identificadas no código**: 
  - O "cérebro" foi configurado num "System Prompt" em hard-code injetado forçadamente no final de mensagens da API `chat.js`. A LLM é forçada a não entregar prosa textual, mas sim processar obrigatoriamente o retorno num formato validado JSON de 6 parâmetros.
  - Os estados emocionais não dependem do frontend para cálculo; eles são inteiramente decididos e manipulados através da inferência cognitiva do modelo `dolphin-llama3:8b`. O frontend atua meramente como um terminal que reage à análise.
- **Fluxo completo do funil de vendas**: **Inexistente**. O projeto é puramente Roleplay e ficção.
- **Fluxo completo do WhatsApp**: **Inexistente**. O App não funciona no WhatsApp nem suporta multi-agentes ou tickets de venda.
- **Segregação de visibilidade por role**: **Inexistente**.

## 9. FLUXO DO WHATSAPP
> ⚠️ ATENÇÃO: Todas as subseções abaixo (Envio de arquivos via WHATSAPP, Recebimento de webhooks de mensagens, Processamento no Supabase, Configurações de media_url, e Instâncias Z-API/Evolution) são ABSOLUTAMENTE **INEXISTENTES** no escopo e no código base analisado neste repositório. O "Luna App" simula uma vizinha num simulador estático interno, sem qualquer API mensageira terceira em funcionamento.

## 10. BUILD E DEPLOY
- **Processo de build do frontend**: É efetuado pelo Vite usando o script `npm run vercel-build`, minificando os Typescript files e gerando o cache na pasta `/dist/`.
- **Deploy na Vercel (serverless functions)**: Na Vercel, o diretório configurado lê o `vercel.json` na raiz da branch, injeta os scripts e isola a rota `/api/chat` usando o build serverless isolado em `luna-api/api/chat.js`.
- **Variáveis de ambiente necessárias**: A única obrigatória exigida por painel (Vercel ENV Settings) no cenário de produção atual é `OLLAMA_URL`.
- **Mobile com Capacitor**: Os arquivos de configuração (`capacitor.config.ts`, `android/`) permanecem no projeto como Débito Técnico deixado pelos antigos protótipos de interface, sem função declarada no workflow do Vercel/React atual.

## 11. PROBLEMAS RESOLVIDOS
- Roteamento defeituoso do Vercel corrigido na transição de repositórios ao unificar o `vercel.json` na pasta-raiz e definir os `rewrites` lógicos.
- Bug estrutural no Parser da `chat.js`, onde o Ollama estava quebrando a aplicação Vite caso o modelo LLM retornasse Markdown plain text por engano, corrigido com blocos `try/catch`, RegEx (eliminando a flag ```json``` da resposta) e implementando um mock seguro (objeto genérico) de Fallback via node-fetch.
- Problema de importação Vite/Rollup consertado através da instalação e efetivação da biblioteca central `firebase` via NPM no arquivo `package.json` principal (frontend React).

## 12. DÉBITOS TÉCNICOS
- **Problemas conhecidos ainda não resolvidos**:
  - Código fonte extremamente fraturado com resíduos extensos e complexos de frameworks concorrentes (Flutter e Angular em pastas `/lib/` e `/luna-app/`) que não fazem mais parte do core de compilação.
  - "Memória de Longo Prazo" visual não atualiza reativamente, já que não foi implantado o agente analisador que refaz o resumo e coleta os fatos das narrativas mais novas; o sistema atualmente apenas renderiza os blocos previamente injetados ou estáticos.
- **Riscos identificados no código**:
  - Dependência integral do endpoint hard-coded do Ollama em `chat.js` se não houver ENV, com resposta padrão mockada que pode quebrar a interatividade real caso instável.
  - O aplicativo grava no Firestore em cima da raiz hard-coded `"luna"`. Usuários simultâneos vão causar colisão letal em tempo real, corrompendo os dados de tela e substituindo `estado_emocional` sucessivamente.

> ⚠️ ATENÇÃO: Falta grave no isolamento (Single-Tenant). A ausência de geração de sessões impede que o app vá ao ar para tráfego simultâneo sem gerar erros de sobreposição de memória entre dois acessantes não autenticados.

## 13. BACKLOG E MELHORIAS SUGERIDAS
- **Funcionalidades pendentes**:
  - Algoritmo assíncrono de consolidação de memórias (uma crôn job ou função LLM paralela que a cada 5 mensagens resume a conversa, atualiza o JSON de resumo e joga pro Firebase).
  - Roteamento completo, páginas de login e geração de instâncias no Firebase para "múltiplos Marcos".
- **Melhorias técnicas recomendadas**:
  - Expurgo dos arquivos legados (`/lib`, `pubspec.yaml`, `/luna-app`, `.gitignore` redundantes) para limpar o repositório.
  - Mudança dos segredos do `firebase.ts` de String text para Import Meta Vars (`VITE_`).
- **Ordem de prioridade sugerida**:
  1. Configuração de Firebase Auth Anônimo atrelando UUID do browser ao documento do Firestore para gerar `users/XYZ/memoria`.
  2. Implementação das regras do Firebase Rules no console de Produção.
  3. Remoção de legados para deixar a pasta limpa (Refactorização pura em prol do Vite).
  4. Programação do "Agent de consolidação" para alimentar a lista de "Padrões" do usuário reativamente.

## 14. VARIÁVEIS DE AMBIENTE
- **Lista completa de todas as variáveis necessárias**:
  - `OLLAMA_URL`: URL da máquina/GPU onde a LLM roda o Inference Gateway.
  - `GEMINI_API_KEY`: Inativa, mas deixada em legado no arquivo `.env.example`.
  - `APP_URL`: URL em desuso da máquina base legada em exemplos de variáveis.
- **Onde cada uma é usada**: Das listadas no `.env.example`, **apenas** a `OLLAMA_URL` está em processamento funcional nas lógicas de orquestração do arquivo `luna-api/api/chat.js` para bater no LLM via node-fetch.
- **Quais são seguras para o frontend (VITE_) e quais são apenas para o backend**: Na configuração atual do código, nenhuma variável foi criada obedecendo à sintaxe `VITE_`. Todas as chaves em produção devem ser alocadas pelo painel da Vercel (Backend Secrets). Recomenda-se portar `firebaseConfig` da aplicação Typescript para segredos com prefixo Front-end `VITE_` em uma fase posterior.
---
