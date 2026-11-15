Dir[File.join(__dir__, "development", "*.rb")].sort.each { |file| require file }

user = User.order(:id).first or abort("Sign up a user in development first, then re-run db:seed.")
company = user.companies.order(:id).first

sites = [
  { domain: "app.example.com", count: 600, report_only_share: 0.1, burst: { count: 45, hours_ago: 3 } },
  { domain: "www.example.com", count: 350, report_only_share: 0.0 },
  { domain: "docs.example.com", count: 150, report_only_share: 1.0 },
]

sites.each_with_index do |site, index|
  website = company.websites.find_or_create_by!(domain: site[:domain])
  DevSeeds::WebsiteSeeder.new(
    website,
    count: site[:count],
    report_only_share: site[:report_only_share],
    burst: site[:burst],
    random: Random.new(index + 1),
  ).call
  puts "#{website.domain}: #{website.reports.count} reports"
end
