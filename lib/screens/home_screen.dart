import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            
            // Título elegante no topo
            const Text(
              'Luna',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 72,
                fontWeight: FontWeight.w300,
                color: Color(0xFFE8A0BF),
                letterSpacing: -1.0,
              ),
            ),
            
            const Spacer(),
            
            // Avatar circular placeholder
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 45,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status Online
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ADE80).withOpacity(0.5),
                        blurRadius: 10,
                      )
                    ]
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Online agora',
                  style: TextStyle(
                    color: Color(0xFFA1A1AA),
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            // Botão único "Conversar"
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90D9).withOpacity(0.3),
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // O modo da conversa (texto vs presencial) mudará 
                  // dentro do chat via contexto.
                  
                  // AQUI SERÁ INTEGRADA A PARTE 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: const Text(
                  'Conversar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Rodapé pequeno
            Text(
              'Luna • Seu andar'.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
