require "test_helper"

class Violation::SignatureTest < ActiveSupport::TestCase
  def signature(**attrs)
    Violation::Signature.new(directive: "script-src", blocked_uri: "https://cdn.example.com/a.js", **attrs)
  end

  test "reduces a blocked URL to its origin" do
    assert_equal "https://cdn.example.com", signature(blocked_uri: "https://CDN.example.com/lib/a.js?v=2#x").blocked_source
    assert_equal "http://localhost:3000", signature(blocked_uri: "http://localhost:3000/dev.js").blocked_source
    assert_equal "wss://live.example.com", signature(blocked_uri: "wss://live.example.com/socket").blocked_source
  end

  test "keeps keywords and bare schemes as they are" do
    assert_equal "inline", signature(blocked_uri: "inline").blocked_source
    assert_equal "eval", signature(blocked_uri: "eval").blocked_source
    assert_equal "data", signature(blocked_uri: "data").blocked_source
    assert_equal "", signature(blocked_uri: nil).blocked_source
  end

  test "takes the directive name out of an old-style violated-directive" do
    assert_equal "script-src", signature(directive: "script-src 'self' https:").directive
  end

  test "is not trackable without a directive" do
    assert_not signature(directive: nil).trackable?
    assert signature.trackable?
  end

  test "is not trackable when a browser extension caused it" do
    assert_not signature(blocked_uri: "chrome-extension").trackable?
    assert_not signature(blocked_uri: "moz-extension://abc/inject.js").trackable?
    assert_not signature(source_file: "chrome-extension").trackable?
  end
end
