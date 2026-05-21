interface Props {
  resumo: string;
  fatos: string[];
  padroes: string[];
  memoriaAtual: string;
}

export default function MemoryPanel({ resumo, fatos, padroes, memoriaAtual }: Props) {
  return (
    <div className="flex flex-col gap-4 p-4 h-full overflow-y-auto">

      {memoriaAtual && (
        <div className="rounded-xl p-3" style={{ background: "rgba(124,58,237,0.15)", border: "1px solid rgba(124,58,237,0.3)" }}>
          <p className="text-xs font-bold mb-1" style={{ color: "#7c3aed" }}>Momento Atual</p>
          <p className="text-sm" style={{ color: "var(--text-primary)" }}>{memoriaAtual}</p>
        </div>
      )}

      <div className="rounded-xl p-3" style={{ background: "rgba(255,255,255,0.05)", border: "1px solid rgba(255,255,255,0.1)" }}>
        <p className="text-xs font-bold mb-2" style={{ color: "var(--text-secondary)" }}>Momentos Recentes</p>
        <p className="text-sm" style={{ color: "var(--text-primary)" }}>{resumo || "Nenhum resumo ainda."}</p>
      </div>

      <div className="rounded-xl p-3" style={{ background: "rgba(255,255,255,0.05)", border: "1px solid rgba(255,255,255,0.1)" }}>
        <p className="text-xs font-bold mb-2" style={{ color: "var(--text-secondary)" }}>Fatos</p>
        {fatos && fatos.length > 0
          ? fatos.map((f, i) => (
              <p key={i} className="text-sm mb-1" style={{ color: "var(--text-primary)" }}>• {f}</p>
            ))
          : <p className="text-sm" style={{ color: "var(--text-secondary)" }}>Nenhum fato registrado.</p>
        }
      </div>

      <div className="rounded-xl p-3" style={{ background: "rgba(255,255,255,0.05)", border: "1px solid rgba(255,255,255,0.1)" }}>
        <p className="text-xs font-bold mb-2" style={{ color: "var(--text-secondary)" }}>Padrões</p>
        {padroes && padroes.length > 0
          ? padroes.map((p, i) => (
              <p key={i} className="text-sm mb-1" style={{ color: "var(--text-primary)" }}>• {p}</p>
            ))
          : <p className="text-sm" style={{ color: "var(--text-secondary)" }}>Nenhum padrão identificado ainda.</p>
        }
      </div>

    </div>
  );
}
