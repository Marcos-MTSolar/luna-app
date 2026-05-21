import React from 'react';
import { Mic, Send } from 'lucide-react';

interface ChatInputProps {
  sugestoes: string[];
  onEnviar: (text: string) => void;
  value: string;
  onChange: (val: string) => void;
}

export default function ChatInput({ sugestoes, onEnviar, value, onChange }: ChatInputProps) {
  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      onEnviar(value);
    }
  };

  return (
    <div className="flex flex-col gap-4 w-full">
      {/* Botão Virtual Call */}
      <div className="flex justify-center mb-2">
        <button 
          className="px-6 py-2 rounded-full text-white font-medium text-sm transition-transform hover:scale-105 active:scale-95 shadow-lg"
          style={{
            background: 'linear-gradient(to right, #7c3aed, #06b6d4)'
          }}
        >
          Virtual Call
        </button>
      </div>

      {/* Input de Texto */}
      <div className="relative flex items-center">
        <input 
          type="text" 
          placeholder="Fale ou digite..."
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onKeyDown={handleKeyDown}
          className="w-full bg-white/10 border border-white/20 text-white placeholder-white/50 rounded-full px-6 py-4 pr-24 focus:outline-none focus:ring-2 focus:ring-[#7c3aed]/50 backdrop-blur-md"
        />
        <div className="absolute right-2 flex items-center gap-2">
          <button className="p-2 text-white/70 hover:text-white transition-colors rounded-full hover:bg-white/10">
            <Mic className="w-5 h-5" />
          </button>
          <button 
            onClick={() => onEnviar(value)}
            className="p-2 text-white/70 hover:text-[#06b6d4] transition-colors rounded-full hover:bg-white/10"
          >
            <Send className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Sugestões Rápidas */}
      <div className="flex flex-wrap gap-2 justify-center mt-2">
        {sugestoes.map((sugestao, idx) => (
          <button
            key={idx}
            onClick={() => onChange(sugestao)}
            className="px-4 py-2 rounded-full text-xs text-white/80 bg-white/5 border border-white/10 hover:bg-white/10 hover:text-white transition-colors backdrop-blur-md"
          >
            {sugestao}
          </button>
        ))}
      </div>
    </div>
  );
}
