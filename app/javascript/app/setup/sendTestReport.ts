import type { Website } from "../models";
import reportEndpoint from "./reportEndpoint";

// a blocked URI on a reserved TLD, so a test report is easy to tell apart
const TEST_BLOCKED_URI = "https://csphero-test-report.example/script.js";

export default async function sendTestReport(website: Website) {
  const endpoint = reportEndpoint(website.token);

  const response = await fetch(endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/csp-report" },
    body: JSON.stringify({ "csp-report": testViolation(website, endpoint) }),
  });

  if (!response.ok) {
    throw new Error(failureReason(response.status));
  }
}

function testViolation(website: Website, endpoint: string) {
  return {
    "document-uri": `https://${website.domain}/`,
    referrer: "",
    "violated-directive": "script-src-elem",
    "effective-directive": "script-src-elem",
    "original-policy": `default-src 'self'; report-uri ${endpoint}`,
    disposition: "report",
    "blocked-uri": TEST_BLOCKED_URI,
    "status-code": 200,
  };
}

function failureReason(status: number) {
  if (status === 429) {
    return "The monthly report limit is reached, so the test report was not stored.";
  }
  return `The endpoint answered with status ${status}.`;
}
