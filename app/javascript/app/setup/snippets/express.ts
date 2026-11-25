import { STARTER_POLICY, type SetupSnippet } from "./types";

const express: SetupSnippet = {
  id: "express",
  label: "Express",
  file: "app.js",
  code: (endpoint) => `const csp = "${STARTER_POLICY}; report-uri ${endpoint}";

app.use((req, res, next) => {
  res.setHeader("Content-Security-Policy-Report-Only", csp);
  next();
});`,
};

export default express;
