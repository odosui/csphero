import * as React from "react";
import { format } from "date-fns";
import type { ReportQuota } from "../models";

const ReportQuotaUsage: React.FC<{ quota: ReportQuota }> = ({ quota }) => {
  if (quota.limit === null) {
    return null;
  }

  const usage = `${quota.used.toLocaleString()} of ${quota.limit.toLocaleString()} reports used this month`;

  if (quota.used < quota.limit) {
    return <p className="report-quota-usage">{usage}</p>;
  }

  return (
    <p className="report-quota-usage exhausted">
      {usage}. New reports are not collected until{" "}
      {format(new Date(quota.resets_at), "MMMM d")}.
    </p>
  );
};

export default ReportQuotaUsage;
