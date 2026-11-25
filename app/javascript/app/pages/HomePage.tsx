import * as React from "react";
import { Link } from "react-router-dom";
import type { ReportQuota, Website } from "../models";
import { ChevronRightIcon, PlusIcon } from "../components/icons";
import ReportQuotaUsage from "../components/ReportQuotaUsage";
import AddWebsitePage from "./AddWebsitePage";

const HomePage: React.FC<{ websites: Website[]; quota: ReportQuota | undefined }> = ({
  websites,
  quota,
}) => {
  if (websites.length === 0) {
    return <AddWebsitePage welcome />;
  }

  return (
    <main className="home-page">
      <div className="container">
        <header className="home-header">
          <h1>Your websites</h1>
          <p className="home-subtitle">
            {pluralize(websites.length, "website", "websites")} monitored
          </p>
        </header>
        <div className="domain-list">
          {websites.map((website) => {
            const hasReports = website.last24h_reports_count > 0;
            return (
              <Link
                to={`/domains/${website.id}/${website.has_reports ? "agg-reports" : "edit"}`}
                className="domain"
                key={website.id}
              >
                <div className="domain-monogram">
                  {website.domain.charAt(0).toUpperCase()}
                </div>
                <div className="domain-info">
                  <div className="domain-host">{website.domain}</div>
                  <div
                    className={`reports-count${hasReports ? " has-reports" : ""}`}
                  >
                    <span>
                      {hasReports ? (
                        <>
                          <b>
                            {pluralize(
                              website.last24h_reports_count,
                              "report",
                              "reports"
                            )}
                          </b>{" "}
                          in the last 24 hours
                        </>
                      ) : website.has_reports ? (
                        "No new reports in the last 24 hours"
                      ) : (
                        "Waiting for the first report"
                      )}
                    </span>
                  </div>
                </div>
                <ChevronRightIcon className="domain-chevron" />
              </Link>
            );
          })}
          <Link to="/add" className="add-domain">
            <PlusIcon /> Add website
          </Link>
        </div>
        {quota && <ReportQuotaUsage quota={quota} />}
      </div>
    </main>
  );
};

export default HomePage;

function pluralize(count: number, singular: string, plural: string) {
  return `${count.toLocaleString()} ${count === 1 ? singular : plural}`;
}
