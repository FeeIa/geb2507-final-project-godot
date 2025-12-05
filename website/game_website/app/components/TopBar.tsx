type TopBarProps = {
  badge: string;
  context: string;
};

export function TopBar({ badge, context }: TopBarProps) {
  return (
    <div className="flex flex-wrap items-center justify-between gap-3 pb-10">
      <div className="flex items-center gap-3">
        <span className="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-cyan-100">
          {badge}
        </span>
        <span className="text-sm text-slate-400">{context}</span>
      </div>
      <a
        href="#play"
        className="inline-flex items-center gap-2 rounded-full border border-cyan-400/60 bg-cyan-400/10 px-4 py-2 text-sm font-semibold text-cyan-100 transition hover:-translate-y-0.5 hover:border-cyan-300 hover:text-white hover:shadow-[0_10px_40px_-24px_rgba(34,211,238,0.9)]"
      >
        Play Web Build
        <span aria-hidden="true" className="text-lg">-&gt;</span>
      </a>
    </div>
  );
}
