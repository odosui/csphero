import * as React from "react";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { CheckIcon, CopyIcon } from "../components/icons";
import Api from "../api";
import type { Website } from "../models";

const DomainEditPage: React.FC = () => {
  const [website, setWebsite] = useState<Website | null>(null);

  const { id } = useParams<{ id: string }>();

  useEffect(() => {
    if (!id) {
      return;
    }
    Api.websites.get(id).then((res) => {
      setWebsite(res);
    });
  }, [id]);

  if (website === null) {
    return null;
  }

  const endpoint = reportUri(website.token);

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
          <h2>Add these headers to your site</h2>
          <p>
            This covers every browser:{" "}
            <a
              href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-to"
              target="_blank"
              rel="noreferrer"
            >
              <code>report-to</code>
            </a>{" "}
            (modern Reporting API) plus{" "}
            <a
              href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-uri"
              target="_blank"
              rel="noreferrer"
            >
              <code>report-uri</code>
            </a>{" "}
            as a fallback for older ones. Browsers that support{" "}
            <code>report-to</code> ignore <code>report-uri</code>, so it's safe
            to ship both.
          </p>
          <p>
            Replace <code>default-src 'self'</code> with the policy you want to
            test. Once the reports stop surprising you, rename the header to{" "}
            <code>Content-Security-Policy</code> to enforce it.
          </p>
          <div className="instructions-block">
            <label className="endpoint-label">Response headers</label>
            <CopyBlock
              value={`Reporting-Endpoints: csp-endpoint="${endpoint}"\nContent-Security-Policy-Report-Only: default-src 'self'; report-uri ${endpoint}; report-to csp-endpoint`}
            />
          </div>
        </section>
      </div>
    </main>
  );
};

const useCopy = (): [boolean, (value: string) => void] => {
  const [copied, setCopied] = useState(false);
  const copy = (value: string) => {
    navigator.clipboard.writeText(value).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    });
  };
  return [copied, copy];
};

const CopyField: React.FC<{ value: string }> = ({ value }) => {
  const [copied, copy] = useCopy();
  return (
    <div className="copy-field">
      <code>{value}</code>
      <button
        type="button"
        className="humble copy-btn"
        onClick={() => copy(value)}
      >
        {copied ? <CheckIcon /> : <CopyIcon />}
        {copied ? "Copied" : "Copy"}
      </button>
    </div>
  );
};

const CopyBlock: React.FC<{ value: string }> = ({ value }) => {
  const [copied, copy] = useCopy();
  return (
    <div className="copy-block">
      <button
        type="button"
        className="copy-btn"
        aria-label={copied ? "Copied" : "Copy"}
        title={copied ? "Copied" : "Copy"}
        onClick={() => copy(value)}
      >
        {copied ? <CheckIcon /> : <CopyIcon />}
      </button>
      <pre>
        <code>{value}</code>
      </pre>
    </div>
  );
};

function reportUri(token: string) {
  return `${window.location.origin}/report/${token}`;
}

export default DomainEditPage;
