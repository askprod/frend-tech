require "test_helper"

class Apis::XAPI::PostsTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body, keyword_init: true)

  test "fetches posts by id with metric fields" do
    requests = []
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: { "data" => [] }.to_json)
    end

    Apis::XAPI::Posts.new(bearer_token: "token", transport:).by_ids(%w[111 222])

    uri = URI(requests.first[:url])
    params = URI.decode_www_form(uri.query).to_h

    assert_equal "/2/tweets", uri.path
    assert_equal "111,222", params["ids"]
    assert_includes params["tweet.fields"], "public_metrics"
  end

  test "fetches posts for an account and omits blank cursors" do
    requests = []
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: { "data" => [] }.to_json)
    end

    Apis::XAPI::Posts.new(bearer_token: "token", transport:).for_account("123", since_id: nil, max_results: 25)

    uri = URI(requests.first[:url])
    params = URI.decode_www_form(uri.query).to_h

    assert_equal "/2/users/123/tweets", uri.path
    assert_equal "25", params["max_results"]
    assert_equal "replies", params["exclude"]
    assert_nil params["since_id"]
  end
end
