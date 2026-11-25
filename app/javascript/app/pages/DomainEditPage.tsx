import * as React from "react";
import { useParams } from "react-router-dom";
import CopyField from "../components/copy/CopyField";
import type { User } from "../models";
import AlertSettings from "../setup/AlertSettings";
import FirstReportStatus from "../setup/FirstReportStatus";
import reportEndpoint from "../setup/reportEndpoint";
import SetupSnippets from "../setup/SetupSnippets";
import useWebsite from "../setup/useWebsite";

const DomainEditPage: React.FC<{ user: User }> = ({ user }) => {
  const { id } = useParams<{ id: string }>();
  const website = useWebsite(id);

  if (website === null) {
    return null;
  }

  const endpoint = reportEndpoint(website.token);

  return (
    <main className="website-edit-page">
      <div className="container">
        <header className="setup-header">
          <h1>Set up reporting for {website.domain}</h1>
          <p className="secondary">
            Send your Content Security Policy violation reports to the endpoint
            below. Start in report-only mode: the browser reports what your
            policy would block, without blocking anything.
          </p>
        </header>

        <div className="instructions-block">
          <label className="endpoint-label">Your reporting endpoint</label>
          <CopyField value={endpoint} />
        </div>

        <section className="i2 setup-option">
          <h2>1. Add the reporting header to your site</h2>
          <p>
            Pick your stack and paste the snippet. Replace{" "}
            <code>default-src 'self'</code> with the policy you want to test.
            Once the reports stop surprising you, switch the header to{" "}
            <code>Content-Security-Policy</code> to enforce it.
          </p>
          <SetupSnippets endpoint={endpoint} />
        </section>

        <section className="i2 setup-option">
          <h2>2. Check that reports arrive</h2>
          <FirstReportStatus website={website} />
        </section>

        <section className="i2 setup-option">
          <h2>3. Get emailed when something changes</h2>
          <AlertSettings key={website.id} website={website} user={user} />
        </section>
      </div>
    </main>
  );
};

export default DomainEditPage;
