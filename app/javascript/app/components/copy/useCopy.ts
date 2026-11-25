import { useState } from "react";

const FEEDBACK_MS = 1500;

export default function useCopy(): [boolean, (value: string) => void] {
  const [copied, setCopied] = useState(false);

  const copy = (value: string) => {
    navigator.clipboard.writeText(value).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), FEEDBACK_MS);
    });
  };

  return [copied, copy];
}
