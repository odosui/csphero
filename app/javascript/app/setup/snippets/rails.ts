import type { SetupSnippet } from "./types";

const rails: SetupSnippet = {
  id: "rails",
  label: "Rails",
  file: "config/initializers/content_security_policy.rb",
  guideUrl: "https://www.csphero.com/blog/content-security-policy-with-rails",
  code: (endpoint) => `Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.report_uri "${endpoint}"
  end

  config.content_security_policy_report_only = true
end`,
};

export default rails;
