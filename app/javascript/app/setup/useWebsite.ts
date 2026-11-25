import { useEffect, useState } from "react";
import Api from "../api";
import type { Website } from "../models";

const POLL_INTERVAL_MS = 3000;

// Loads a website and keeps refreshing it until its first report arrives.
export default function useWebsite(id: string | undefined) {
  const [website, setWebsite] = useState<Website | null>(null);
  const waitingForReports = website !== null && !website.has_reports;

  useEffect(() => {
    if (!id) return;
    setWebsite(null);
    Api.websites.get(id).then(setWebsite);
  }, [id]);

  useEffect(() => {
    if (!id || !waitingForReports) return;

    const timer = setInterval(() => {
      Api.websites.get(id).then(setWebsite);
    }, POLL_INTERVAL_MS);

    return () => clearInterval(timer);
  }, [id, waitingForReports]);

  return website;
}
