import { HeroSection } from "./components/HeroSection";
import { InfoCardGrid } from "./components/InfoCardGrid";
import { PlayEmbed } from "./components/PlayEmbed";
import { SectionHeading } from "./components/SectionHeading";
import { TopBar } from "./components/TopBar";
import { WrapUpBanner } from "./components/WrapUpBanner";
import {
  findings,
  hero,
  processItems,
  purposeItems,
  teamMembers,
} from "./content";

export default function Home() {
  return (
    <div className="relative isolate min-h-screen overflow-hidden bg-slate-950 text-slate-100">
      <div className="pointer-events-none absolute inset-0 -z-10 opacity-70">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(56,189,248,0.18),transparent_30%),radial-gradient(circle_at_80%_30%,rgba(94,234,212,0.14),transparent_28%),radial-gradient(circle_at_50%_80%,rgba(167,139,250,0.2),transparent_32%)]" />
        <div className="absolute inset-x-0 top-32 mx-auto h-[460px] max-w-5xl rounded-full bg-gradient-to-r from-cyan-500/10 via-blue-500/10 to-fuchsia-500/10 blur-3xl" />
        <div className="absolute inset-0 bg-[linear-gradient(120deg,rgba(255,255,255,0.06)_1px,transparent_1px),linear-gradient(0deg,rgba(255,255,255,0.05)_1px,transparent_1px)] bg-[length:120px_120px]" />
      </div>

      <div className="mx-auto max-w-6xl px-6 py-12 lg:py-16">
        <TopBar badge={hero.badge} context={hero.context} />

        <main className="space-y-16 pb-10">
          <HeroSection
            track={hero.track}
            title={hero.title}
            subtitle={hero.subtitle}
          />

          <section id="purpose" className="space-y-6">
            <SectionHeading
              eyebrow="Purpose"
              title="What the game delivers"
              gradientFrom="from-cyan-400"
              gradientTo="to-fuchsia-400"
              eyebrowColor="text-cyan-100"
            />
            <InfoCardGrid items={purposeItems} cardClassName="hover:shadow-cyan-500/20 hover:border-cyan-200/40" />
          </section>

          <section id="play" className="space-y-6">
            <SectionHeading
              eyebrow="Play"
              title="Try the web build"
              gradientFrom="from-emerald-400"
              gradientTo="to-cyan-400"
              eyebrowColor="text-emerald-100"
            />
            <PlayEmbed iframeSrc="/immunodefender/index.html" />
          </section>

          <section id="process" className="space-y-6">
            <SectionHeading
              eyebrow="Process"
              title="Design and research path"
              gradientFrom="from-blue-400"
              gradientTo="to-violet-400"
              eyebrowColor="text-blue-100"
            />
            <InfoCardGrid
              items={processItems}
              columns="md:grid-cols-2"
              cardClassName="bg-gradient-to-br from-slate-900/80 via-slate-900/50 to-slate-900/70 hover:shadow-blue-500/20 hover:border-blue-300/40"
            />
          </section>

          <section id="team" className="space-y-6">
            <SectionHeading
              eyebrow="Team"
              title="Who built ImmunoDefender"
              gradientFrom="from-amber-300"
              gradientTo="to-orange-500"
              eyebrowColor="text-amber-100"
            />
            <InfoCardGrid
              items={teamMembers.map((member) => ({
                title: member.name,
                detail: member.focus,
                eyebrow: member.role,
              }))}
              columns="sm:grid-cols-2 lg:grid-cols-3"
              cardClassName="hover:border-amber-200/50 hover:shadow-amber-400/20"
            />
          </section>

          <section id="report" className="space-y-6">
            <SectionHeading
              eyebrow="Findings"
              title="What we learned"
              gradientFrom="from-pink-400"
              gradientTo="to-rose-500"
              eyebrowColor="text-pink-100"
            />
            <InfoCardGrid
              items={findings}
              cardClassName="hover:border-rose-200/50 hover:shadow-rose-400/20"
            />
          </section>

          <WrapUpBanner />
        </main>
      </div>
    </div>
  );
}
