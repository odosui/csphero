import { STARTER_POLICY, type SetupSnippet } from "./types";

const nextjs: SetupSnippet = {
  id: "nextjs",
  label: "Next.js",
  file: "next.config.js",
  guideUrl:
    "https://www.csphero.com/blog/setting-content-security-policy-nextjs",
  code: (endpoint) => `const csp = "${STARTER_POLICY}; report-uri ${endpoint}";

module.exports = {
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [{ key: "Content-Security-Policy-Report-Only", value: csp }],
      },
    ];
  },
};`,
};

export default nextjs;
