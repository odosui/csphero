class AlertMailer < ApplicationMailer
  LIST_SIZE = 10

  layout "alert_mailer"

  helper_method :dashboard_url

  def new_violations(website, violations)
    @website = website
    @violations = violations.first(LIST_SIZE)
    @hidden_count = violations.size - @violations.size

    alert_mail website, "new_violations",
      subject: "#{violations.size} new CSP #{"violation".pluralize(violations.size)} on #{website.domain}"
  end

  def weekly_digest(digest)
    @website = digest.website
    @digest = digest

    alert_mail @website, "weekly_digest", subject: "#{@website.domain}: your week in CSP reports"
  end

  private

  def alert_mail(website, kind, subject:)
    @subscription = Alerts::Subscription.new(website, kind)
    @unsubscribe_url = alert_unsubscription_url(kind: kind, token: @subscription.token)

    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>"
    headers["List-Unsubscribe-Post"] = "List-Unsubscribe=One-Click"

    mail to: website.company.alert_recipients, subject:
  end

  def dashboard_url(website)
    "#{root_url}#/domains/#{website.id}/agg-reports"
  end
end
