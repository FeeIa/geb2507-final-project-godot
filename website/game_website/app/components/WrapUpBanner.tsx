export function WrapUpBanner() {
  return (
    <section className="rounded-3xl border border-white/10 bg-gradient-to-r from-cyan-500/10 via-blue-500/10 to-fuchsia-500/10 p-8 shadow-2xl shadow-cyan-500/10">
      <div className="grid gap-6 md:grid-cols-[1.6fr_1fr] md:items-center">
        <div className="space-y-3">
          <p className="text-xs uppercase tracking-[0.25em] text-cyan-100">Wrap-up</p>
          <h2 className="text-2xl font-semibold text-white">Ready for the report and demo</h2>
          <p className="text-sm leading-relaxed text-slate-200">
            Embed your latest Godot HTML5 export, link to your write-up, and share this site with instructors or
            stakeholders. Everything here is static-friendly and works on desktop and mobile.
          </p>
        </div>
        <div className="flex flex-wrap gap-3">
          <a
            href="/immunodefender/index.html"
            className="inline-flex flex-1 items-center justify-center gap-2 rounded-full bg-white px-5 py-3 text-sm font-semibold text-slate-900 transition hover:-translate-y-0.5 hover:shadow-lg hover:shadow-cyan-500/20 md:flex-none"
          >
            Launch game build
          </a>
          <a
            href="#report"
            className="inline-flex flex-1 items-center justify-center gap-2 rounded-full border border-white/20 bg-white/5 px-5 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:border-white/35 md:flex-none"
          >
            Attach PDF report
          </a>
        </div>
      </div>
    </section>
  );
}
