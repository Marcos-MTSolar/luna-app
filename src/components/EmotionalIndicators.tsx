interface Props {
  humor: string;
  afeto: string;
  energia: string;
  sincronia: string;
}

export default function EmotionalIndicators({ humor, afeto, energia, sincronia }: Props) {
  const indicadores = [
    { icone: "😊", label: "Humor", valor: humor },
    { icone: "❤️", label: "Afeto", valor: afeto },
    { icone: "⚡", label: "Energia", valor: energia },
    { icone: "🔄", label: "Sincronia", valor: sincronia },
  ];

  return (
    <div className="flex flex-col gap-3">
      {indicadores.map((item) => (
        <div
          key={item.label}
          className="flex items-center gap-3 px-4 py-3 rounded-xl"
          style={{
            background: "rgba(255,255,255,0.05)",
            border: "1px solid rgba(255,255,255,0.1)",
            backdropFilter: "blur(12px)",
          }}
        >
          <span className="text-xl">{item.icone}</span>
          <div className="flex flex-col">
            <span className="text-xs" style={{ color: "var(--text-secondary)" }}>{item.label}</span>
            <span className="text-sm font-semibold" style={{ color: "var(--text-primary)" }}>{item.valor || "—"}</span>
          </div>
        </div>
      ))}
    </div>
  );
}
