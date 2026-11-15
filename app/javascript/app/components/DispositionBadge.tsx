import type { FC } from "react";

const LABELS: Record<string, string> = {
  enforce: "Enforce",
  report: "Report",
};

const DispositionBadge: FC<{ disposition: string | null | undefined }> = ({
  disposition,
}) => {
  const key = disposition?.toLowerCase() ?? "";
  return (
    <span className={`disposition-badge ${key}`}>
      {LABELS[key] ?? disposition ?? "—"}
    </span>
  );
};

export default DispositionBadge;
