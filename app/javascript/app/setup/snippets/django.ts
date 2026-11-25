import type { SetupSnippet } from "./types";

const django: SetupSnippet = {
  id: "django",
  label: "Django",
  file: "settings.py (Django 6 or newer)",
  guideUrl:
    "https://www.csphero.com/blog/content-security-policy-for-django-6",
  code: (endpoint) => `from django.utils.csp import CSP

MIDDLEWARE = [
    # ...
    "django.middleware.csp.ContentSecurityPolicyMiddleware",
]

SECURE_CSP_REPORT_ONLY = {
    "default-src": [CSP.SELF],
    "report-uri": "${endpoint}",
}`,
};

export default django;
