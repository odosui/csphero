# What makes two reports "the same violation": the directive and where the
# blocked resource came from, without the path or query string.
class Violation::Signature
  ORIGIN = %r{\A[a-z][a-z0-9+.\-]*://[^/?#]+}i
  EXTENSION = /\A(chrome|moz|safari-web|ms-browser)-extension/i

  attr_reader :directive, :blocked_source

  def self.of(report)
    new(
      directive: report.violated_directive.presence || report.effective_directive,
      blocked_uri: report.blocked_uri,
      source_file: report.source_file
    )
  end

  def initialize(directive:, blocked_uri:, source_file: nil)
    @directive = directive.to_s.split.first
    @blocked_source = origin_of(blocked_uri.to_s.strip)
    @source_file = source_file.to_s
  end

  # Reports without a directive are malformed; the ones caused by a visitor's
  # browser extension say nothing about the website.
  def trackable?
    directive.present? && !from_extension?
  end

  def to_h
    { directive:, blocked_source: }
  end

  private

  def origin_of(uri)
    uri[ORIGIN]&.downcase || uri
  end

  def from_extension?
    blocked_source.match?(EXTENSION) || @source_file.match?(EXTENSION)
  end
end
