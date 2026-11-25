import { STARTER_POLICY, type SetupSnippet } from "./types";

const headers: SetupSnippet = {
  id: "headers",
  label: "HTTP headers",
  note: "report-to is the modern Reporting API and report-uri the fallback for older browsers. Browsers that support report-to ignore report-uri, so it is safe to ship both.",
  code: (endpoint) =>
    [
      `Reporting-Endpoints: csp-endpoint="${endpoint}"`,
      `Content-Security-Policy-Report-Only: ${STARTER_POLICY}; report-uri ${endpoint}; report-to csp-endpoint`,
    ].join("\n"),
};

export default headers;
