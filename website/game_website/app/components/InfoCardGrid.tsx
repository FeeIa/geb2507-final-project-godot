type CardItem = {
  title: string;
  detail: string;
  eyebrow?: string;
};

type InfoCardGridProps = {
  items: CardItem[];
  columns?: string;
  cardClassName?: string;
};

export function InfoCardGrid({
  items,
  columns = "md:grid-cols-3",
  cardClassName,
}: InfoCardGridProps) {
  return (
    <div className={`grid gap-4 ${columns}`}>
      {items.map((item) => (
        <div
          key={item.title}
          className={`rounded-2xl border border-white/10 bg-slate-900/70 p-4 shadow-md shadow-slate-900/50 transition hover:-translate-y-1 hover:border-white/20 ${
            cardClassName ?? ""
          }`}
        >
          {item.eyebrow ? (
            <p className="text-xs uppercase tracking-[0.2em] text-slate-300">
              {item.eyebrow}
            </p>
          ) : null}
          <h3 className="text-lg font-semibold text-white">{item.title}</h3>
          <p className="mt-3 text-sm leading-relaxed text-slate-300">
            {item.detail}
          </p>
        </div>
      ))}
    </div>
  );
}
