require "test_helper"

class Apis::BaseClientTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body, keyword_init: true)

  class TestClient < Apis::BaseClient
    def fetch
      get("/resource", params: { keep: "value", skip: nil })
    end
  end

  test "builds a request and parses JSON responses" do
    requests = []
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: { "ok" => true }.to_json)
    end

    response = TestClient.new(
      base_url: "https://api.example.test",
      headers: { "Authorization" => "Bearer token" },
      transport:
    ).fetch

    request = requests.first
    uri = URI(request[:url])

    assert_equal({ "ok" => true }, response)
    assert_equal "/resource", uri.path
    assert_equal({ "keep" => "value" }, URI.decode_www_form(uri.query).to_h)
    assert_equal "Bearer token", request[:headers]["Authorization"]
  end

  test "raises specific errors for rate limits" do
    transport = lambda do |_options|
      Response.new(code: "429", body: { "detail" => "Too many requests" }.to_json)
    end

    error = assert_raises Apis::BaseClient::RateLimitError do
      TestClient.new(base_url: "https://api.example.test", transport:).fetch
    end

    assert_equal 429, error.status
    assert_equal "Too many requests", error.message
  end
end
