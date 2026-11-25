import * as React from "react";
import { useState } from "react";
import { Link } from "react-router-dom";
import { CheckIcon, ChevronRightIcon } from "../components/icons";
import type { Website } from "../models";
import sendTestReport from "./sendTestReport";

const FirstReportStatus: React.FC<{ website: Website }> = ({ website }) => {
  if (website.has_reports) {
    return <ReportsArriving website={website} />;
  }
  return <WaitingForFirstReport website={website} />;
};

const ReportsArriving: React.FC<{ website: Website }> = ({ website }) => (
  <div className="first-report-status arrived">
    <div className="status-line">
      <CheckIcon className="status-mark" />
      <b>Reports are arriving</b>
    </div>
    <Link to={`/domains/${website.id}/agg-reports`} className="action-link">
      View reports
      <ChevronRightIcon />
    </Link>
  </div>
);

const WaitingForFirstReport: React.FC<{ website: Website }> = ({ website }) => {
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSendTest = async () => {
    setSending(true);
    setError(null);
    try {
      await sendTestReport(website);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Could not send the test report.");
      setSending(false);
    }
  };

  return (
    <div className="first-report-status waiting">
      <div className="status-line">
        <span className="status-pulse" />
        <b>Waiting for the first report from {website.domain}</b>
      </div>
      <p>
        Once the header is live, open your site in a browser. Violations
        usually show up here within a minute. This page updates on its own.
      </p>
      <p>
        Not deployed yet? Send a test report to see what the dashboard looks
        like.
      </p>
      <button
        type="button"
        className="humble"
        onClick={handleSendTest}
        disabled={sending}
      >
        {sending ? "Sending…" : "Send a test report"}
      </button>
      {error && <p className="status-error">{error}</p>}
    </div>
  );
};

export default FirstReportStatus;
