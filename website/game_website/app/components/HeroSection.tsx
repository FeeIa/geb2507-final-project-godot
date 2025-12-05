type HeroSectionProps = {
  track: string;
  title: string;
  subtitle: string;
};

export function HeroSection({ track, title, subtitle }: HeroSectionProps) {
  return (
    <section className="grid gap-10 lg:grid-cols-[1.2fr_0.9fr] lg:items-center">
      <div className="space-y-6">
        <div className="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-semibold text-slate-200">
          {track}
        </div>
        <div className="space-y-4">
          <h1 className="text-4xl font-semibold leading-tight text-white sm:text-5xl">
            {title}
          </h1>
          <p className="max-w-3xl text-lg leading-relaxed text-slate-300">
            {subtitle}
          </p>
        </div>
        <div className="flex flex-wrap gap-3">
          <a
            href="#purpose"
            className="inline-flex items-center justify-center gap-2 rounded-full bg-white text-slate-900 px-5 py-3 text-sm font-semibold transition hover:-translate-y-0.5 hover:shadow-lg hover:shadow-cyan-500/20"
          >
            View project focus
          </a>
          <a
            href="#process"
            className="inline-flex items-center justify-center gap-2 rounded-full border border-white/15 px-5 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:border-white/30 hover:text-cyan-50"
          >
            Read design process
          </a>
          <a
            href="#report"
            className="inline-flex items-center justify-center gap-2 rounded-full border border-cyan-300/40 bg-cyan-400/10 px-5 py-3 text-sm font-semibold text-cyan-100 transition hover:-translate-y-0.5 hover:border-cyan-200/70 hover:text-white"
          >
            Findings & insights
          </a>
        </div>
      </div>

      <div className="relative overflow-hidden rounded-3xl border border-white/10 bg-white/5 p-6 shadow-2xl shadow-cyan-500/10">
        <div className="absolute inset-0 bg-gradient-to-br from-cyan-400/15 via-transparent to-fuchsia-500/10" />
        <div className="relative flex flex-col gap-5">
          <div className="flex items-center justify-between text-sm text-slate-300">
            <span>Project snapshot</span>
            <span className="rounded-full bg-white/10 px-3 py-1 text-xs font-semibold text-white">
              Web ready
            </span>
          </div>
          <div className="grid grid-cols-2 gap-4 text-slate-100">
            <div className="rounded-2xl border border-white/10 bg-slate-900/60 p-4">
              <p className="text-sm text-slate-400">Built with</p>
              <p className="text-lg font-semibold text-white">
                Godot 4 - HTML5 export
              </p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-slate-900/60 p-4">
              <p className="text-sm text-slate-400">Target outcome</p>
              <p className="text-lg font-semibold text-white">
                Boost vaccine & immunity literacy through play
              </p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-slate-900/60 p-4">
              <p className="text-sm text-slate-400">Format</p>
              <p className="text-lg font-semibold text-white">
                Browser-friendly serious game
              </p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-slate-900/60 p-4">
              <p className="text-sm text-slate-400">Team</p>
              <p className="text-lg font-semibold text-white">
                Design - Dev - Research trio
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
