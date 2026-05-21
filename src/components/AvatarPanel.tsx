import React from 'react';
import { User } from 'lucide-react';

interface AvatarPanelProps {
  ultimaMensagemLuna: string;
  ultimaMensagemUsuario: string;
}

export default function AvatarPanel({ ultimaMensagemLuna, ultimaMensagemUsuario }: AvatarPanelProps) {
  return (
    <div className="flex flex-col items-center justify-center relative w-full h-full">
      {/* Avatar Luna com Box Shadow Duplo */}
      <div 
        className="relative w-48 h-48 bg-[#2d2d44] rounded-full flex items-center justify-center mb-8"
        style={{
          boxShadow: '0 0 40px rgba(124, 58, 237, 0.3), 0 0 80px rgba(6, 182, 212, 0.3)'
        }}
      >
        <User className="w-24 h-24 opacity-20 text-white" />
      </div>

      {/* Balão da Luna (Flutuando) */}
      {ultimaMensagemLuna && (
        <div 
          className="absolute top-[60%] left-1/2 -translate-x-1/2 -translate-y-[120%] p-4 rounded-2xl max-w-[80%] text-center text-white/90"
          style={{
            background: 'rgba(255, 255, 255, 0.08)',
            backdropFilter: 'blur(12px)',
            border: '1px solid rgba(255, 255, 255, 0.1)'
          }}
        >
          {ultimaMensagemLuna}
        </div>
      )}

      {/* Balão do Usuário (Abaixo à direita) */}
      {ultimaMensagemUsuario && (
        <div className="w-full flex justify-end mt-4">
          <div 
            className="p-3 rounded-2xl max-w-[70%] text-right text-white/90 bg-[#7c3aed]/40 backdrop-blur-md"
            style={{
              border: '1px solid rgba(124, 58, 237, 0.3)'
            }}
          >
            {ultimaMensagemUsuario}
          </div>
        </div>
      )}
    </div>
  );
}
