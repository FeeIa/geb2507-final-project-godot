type SectionHeadingProps = {
  eyebrow: string;
  title: string;
  gradientFrom: string;
  gradientTo: string;
  eyebrowColor?: string;
};

export function SectionHeading({
  eyebrow,
  title,
  gradientFrom,
  gradientTo,
  eyebrowColor = "text-slate-200",
}: SectionHeadingProps) {
  return (
    <div className="flex items-center gap-3">
      <span
        className={`h-10 w-1 rounded-full bg-gradient-to-b ${gradientFrom} ${gradientTo}`}
      />
      <div>
        <p className={`text-xs uppercase tracking-[0.25em] ${eyebrowColor}`}>
          {eyebrow}
        </p>
        <h2 className="text-2xl font-semibold text-white">{title}</h2>
      </div>
    </div>
  );
}
