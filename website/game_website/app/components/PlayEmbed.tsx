type PlayEmbedProps = {
  iframeSrc: string;
  linkLabel?: string;
};

export function PlayEmbed({ iframeSrc, linkLabel = "Open in full tab" }: PlayEmbedProps) {
  return (
    <div className="grid gap-6 lg:grid-cols-[1.3fr_0.9fr]">
      <div className="rounded-3xl border border-white/10 bg-slate-900/70 p-5 shadow-xl shadow-cyan-500/10">
        <div className="relative aspect-[16/9] overflow-hidden rounded-2xl border border-white/10 bg-gradient-to-br from-slate-800 via-slate-900 to-slate-950">
          <iframe
            title="ImmunoDefender Web Build"
            src={iframeSrc}
            className="absolute inset-0 h-full w-full rounded-2xl border-0"
            allowFullScreen
          />
          <div className="pointer-events-none absolute inset-0 rounded-2xl ring-1 ring-white/5" />
        </div>
        <div className="mt-4 flex flex-wrap items-center justify-between gap-3 text-sm text-slate-300">
          <p>
            Place your Godot HTML5 export in{" "}
            <span className="font-semibold text-white">public/immunodefender/</span>{" "}
            so the iframe above loads it. Keep the generated paths intact.
          </p>
          <a
            href={iframeSrc}
            className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/5 px-3 py-2 text-xs font-semibold text-white transition hover:border-white/30 hover:-translate-y-0.5"
          >
            {linkLabel}
            <span aria-hidden="true">-&gt;</span>
          </a>
        </div>
      </div>
      <div className="rounded-3xl border border-white/10 bg-slate-900/70 p-6 shadow-xl shadow-emerald-500/10">
        <h3 className="text-lg font-semibold text-white">Export checklist (Godot)</h3>
        <ol className="mt-3 space-y-3 text-sm leading-relaxed text-slate-300">
          <li>
            1. In Godot, set up an <span className="font-semibold text-white">HTML5</span> export preset.
          </li>
          <li>
            2. Export the project to{" "}
            <span className="font-semibold text-white">public/immunodefender/</span> inside this repo.
          </li>
          <li>
            3. Keep the generated <span className="font-semibold text-white">.html</span>,{" "}
            <span className="font-semibold text-white">.wasm</span>, and{" "}
            <span className="font-semibold text-white">.pck</span> files together.
          </li>
          <li>4. Restart the Next.js dev server if running, then reload this page.</li>
          <li>
            5. For sizing tweaks, edit the canvas styles in the exported HTML (or wrap the iframe with Tailwind classes).
          </li>
        </ol>
      </div>
    </div>
  );
}
