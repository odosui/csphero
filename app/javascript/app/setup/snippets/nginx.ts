import { STARTER_POLICY, type SetupSnippet } from "./types";

const nginx: SetupSnippet = {
  id: "nginx",
  label: "Nginx",
  file: "nginx.conf, inside the server block",
  code: (endpoint) =>
    `add_header Content-Security-Policy-Report-Only "${STARTER_POLICY}; report-uri ${endpoint}" always;`,
};

export default nginx;
