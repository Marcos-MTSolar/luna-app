import React from 'react';

interface EmotionalIndicatorsProps {
  humor: string;
  afeto: string;
  energia: string;
  sincronia: string;
}

export default function EmotionalIndicators({ humor, afeto, energia, sincronia }: EmotionalIndicatorsProps) {
  const indicators = [
    { icone: '😊', label: 'Humor', valor: humor },
    { icone: '❤️', label: 'Afeto', valor: afeto },
    { icone: '⚡', label: 'Energia', valor: energia },
    { icone: '🔄', label: 'Sincronia', valor: sincronia },
  ];

  return (
    <div className="flex flex-col gap-4 p-4 h-full">
      <h2 className="text-xl font-semibold mb-2 text-white/80 uppercase tracking-widest text-sm">Estado Emocional</h2>
      <div className="flex flex-col gap-4 flex-1">
        {indicators.map((ind, idx) => (
          <div 
            key={idx}
            className="flex items-center justify-between p-4 rounded-2xl"
            style={{
              background: 'rgba(255, 255, 255, 0.05)',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              backdropFilter: 'blur(12px)'
            }}
          >
            <div className="flex items-center gap-3">
              <span className="text-2xl">{ind.icone}</span>
              <span className="text-white/70 font-medium">{ind.label}</span>
            </div>
            <span className="text-white font-bold">{ind.valor}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
