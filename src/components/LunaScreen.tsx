import React, { useState, useEffect } from 'react';
import { carregarMemoria, atualizarEstadoEmocional } from '../services/firebase';
import MemoryPanel from './MemoryPanel';
import AvatarPanel from './AvatarPanel';
import EmotionalIndicators from './EmotionalIndicators';
import ChatInput from './ChatInput';

export default function LunaScreen() {
  const [humor, setHumor] = useState("—");
  const [afeto, setAfeto] = useState("—");
  const [energia, setEnergia] = useState("—");
  const [sincronia, setSincronia] = useState("—");
  const [memoriaAtual, setMemoriaAtual] = useState("");
  const [resumo, setResumo] = useState("");
  const [fatos, setFatos] = useState<string[]>([]);
  const [padroes, setPadroes] = useState<string[]>([]);
  
  const [sugestoes, setSugestoes] = useState([
    "Como foi o seu dia?",
    "Me conta uma novidade.",
    "O que acha de sairmos hoje?"
  ]);
  
  const [mensagens, setMensagens] = useState([
    { role: 'luna', content: '*sorrio suavemente te observando*' },
    { role: 'user', content: 'Oi, tudo bem?' }
  ]);
  
  const [inputValue, setInputValue] = useState('');

  useEffect(() => {
    carregarMemoria().then((data) => {
      if (data) {
        setResumo(data.resumo || "");
        setFatos(data.fatos || []);
        setPadroes(data.padroes_usuario || []);
        if (data.estado_emocional) {
          setHumor(data.estado_emocional.humor || "—");
          setAfeto(data.estado_emocional.afeto || "—");
          setEnergia(data.estado_emocional.energia || "—");
          setSincronia(data.estado_emocional.sincronia || "—");
        }
      }
    });
  }, []);

  const ultimaMensagemLuna = mensagens.filter(m => m.role === 'luna').pop()?.content || '';
  const ultimaMensagemUsuario = mensagens.filter(m => m.role === 'user').pop()?.content || '';

  const handleEnviar = async (text: string) => {
    if (!text.trim()) return;
    
    const novasMensagens = [...mensagens, { role: 'user', content: text }];
    setMensagens(novasMensagens);
    setInputValue('');

    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages: novasMensagens })
      });
      
      const data = await res.json();
      const reply = data.reply;
      
      if (reply) {
        setMensagens([...novasMensagens, { role: 'luna', content: reply.resposta }]);
        if (reply.sugestoes && Array.isArray(reply.sugestoes)) {
          setSugestoes(reply.sugestoes);
        }
        
        setHumor(reply.humor || "—");
        setAfeto(reply.afeto || "—");
        setEnergia(reply.energia || "—");
        setSincronia(reply.sincronia || "—");
        setMemoriaAtual(reply.memoria_momento || "");
        
        atualizarEstadoEmocional({
          humor: reply.humor || "—",
          afeto: reply.afeto || "—",
          energia: reply.energia || "—",
          sincronia: reply.sincronia || "—"
        });
      }
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 h-screen max-w-7xl mx-auto">
      {/* Coluna Esquerda: MemoryPanel */}
      <div className="flex flex-col overflow-y-auto">
        <MemoryPanel 
          resumo={resumo} 
          fatos={fatos} 
          padroes={padroes} 
          memoriaAtual={memoriaAtual}
        />
      </div>

      {/* Coluna Central: AvatarPanel + ChatInput */}
      <div className="flex flex-col relative overflow-hidden bg-white/5 border border-white/10 rounded-3xl backdrop-blur-md">
        <div className="flex-1 overflow-y-auto p-4 flex flex-col justify-center">
          <AvatarPanel 
            ultimaMensagemLuna={ultimaMensagemLuna} 
            ultimaMensagemUsuario={ultimaMensagemUsuario} 
          />
        </div>
        <div className="p-4 border-t border-white/10">
          <ChatInput 
            sugestoes={sugestoes} 
            onEnviar={handleEnviar}
            value={inputValue}
            onChange={(val: string) => setInputValue(val)}
          />
        </div>
      </div>

      {/* Coluna Direita: EmotionalIndicators */}
      <div className="flex flex-col overflow-y-auto">
        <EmotionalIndicators 
          humor={humor} 
          afeto={afeto} 
          energia={energia} 
          sincronia={sincronia} 
        />
      </div>
    </div>
  );
}
