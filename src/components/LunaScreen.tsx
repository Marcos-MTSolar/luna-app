import React, { useState } from 'react';
import MemoryPanel from './MemoryPanel';
import AvatarPanel from './AvatarPanel';
import EmotionalIndicators from './EmotionalIndicators';
import ChatInput from './ChatInput';

export default function LunaScreen() {
  const [humor, setHumor] = useState('85%');
  const [afeto, setAfeto] = useState('Alto');
  const [energia, setEnergia] = useState('70%');
  const [sincronia, setSincronia] = useState('Estável');
  
  const [memoriaAtual, setMemoriaAtual] = useState({
    resumo: "Luna percebeu que Marcos prefere interações casuais.",
    fatos: ["Gosta de tecnologia", "Prefere noites", "Acorda tarde"],
    padroes: ["Manda mensagens curtas", "Usa muitos emojis"]
  });
  
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

  const ultimaMensagemLuna = mensagens.filter(m => m.role === 'luna').pop()?.content || '';
  const ultimaMensagemUsuario = mensagens.filter(m => m.role === 'user').pop()?.content || '';

  const handleEnviar = (text: string) => {
    if (!text.trim()) return;
    setMensagens([...mensagens, { role: 'user', content: text }]);
    setInputValue('');
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 h-screen max-w-7xl mx-auto">
      {/* Coluna Esquerda: MemoryPanel */}
      <div className="flex flex-col overflow-y-auto">
        <MemoryPanel 
          resumo={memoriaAtual.resumo} 
          fatos={memoriaAtual.fatos} 
          padroes={memoriaAtual.padroes} 
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
