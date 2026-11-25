module AlertTestData
  def create_account(email: "owner@example.com", confirmed: true, domain: "acme.org")
    user = User.new(email:, password: "password123")
    confirmed ? user.skip_confirmation! : user.skip_confirmation_notification!
    user.save!
    user.companies.first.websites.create!(domain:)
  end

  def create_violation(website, blocked_source: "https://cdn.example.com", directive: "script-src", first_seen_at: Time.current, **attrs)
    website.violations.create!(
      directive:, blocked_source:, first_seen_at:, last_seen_at: first_seen_at, reports_count: 1, **attrs
    )
  end

  def create_report(website, directive: "script-src", blocked_uri: "https://cdn.example.com/a.js", **attrs)
    website.reports.create!(violated_directive: directive, blocked_uri:, **attrs)
  end
end
