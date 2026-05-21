import React from 'react';

interface MemoryPanelProps {
  resumo: string;
  fatos: string[];
  padroes: string[];
}

export default function MemoryPanel({ resumo, fatos, padroes }: MemoryPanelProps) {
  return (
    <div className="flex flex-col gap-6 p-4 h-full">
      <h2 className="text-xl font-semibold mb-2 text-white/80 uppercase tracking-widest text-sm">Memória Ativa</h2>
      
      {/* Seção: Momentos Recentes */}
      <div 
        className="p-4 rounded-2xl"
        style={{
          background: 'rgba(255, 255, 255, 0.05)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          backdropFilter: 'blur(12px)'
        }}
      >
        <h3 className="text-sm font-medium text-white/60 mb-2 uppercase tracking-wide">Momentos Recentes</h3>
        <p className="text-white/90 text-sm leading-relaxed">{resumo}</p>
      </div>

      {/* Seção: Fatos */}
      <div 
        className="p-4 rounded-2xl"
        style={{
          background: 'rgba(255, 255, 255, 0.05)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          backdropFilter: 'blur(12px)'
        }}
      >
        <h3 className="text-sm font-medium text-white/60 mb-2 uppercase tracking-wide">Fatos</h3>
        <ul className="list-disc list-inside text-white/90 text-sm space-y-1">
          {fatos.map((fato, idx) => (
            <li key={idx}>{fato}</li>
          ))}
        </ul>
      </div>

      {/* Seção: Padrões */}
      <div 
        className="p-4 rounded-2xl"
        style={{
          background: 'rgba(255, 255, 255, 0.05)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          backdropFilter: 'blur(12px)'
        }}
      >
        <h3 className="text-sm font-medium text-white/60 mb-2 uppercase tracking-wide">Padrões</h3>
        <ul className="list-disc list-inside text-white/90 text-sm space-y-1">
          {padroes.map((padrao, idx) => (
            <li key={idx}>{padrao}</li>
          ))}
        </ul>
      </div>
    </div>
  );
}
