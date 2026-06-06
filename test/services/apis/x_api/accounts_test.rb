require "test_helper"

class Apis::XAPI::AccountsTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body, keyword_init: true)

  test "fetches users by username with public metric fields" do
    requests = []
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: { "data" => [] }.to_json)
    end

    Apis::XAPI::Accounts.new(bearer_token: "token", transport:).by_usernames(%w[frendtech example])

    request = requests.first
    uri = URI(request[:url])
    params = URI.decode_www_form(uri.query).to_h

    assert_equal "/2/users/by", uri.path
    assert_equal "Bearer token", request[:headers]["Authorization"]
    assert_equal "frendtech,example", params["usernames"]
    assert_includes params["user.fields"], "public_metrics"
  end

  test "fetches users by id" do
    requests = []
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: { "data" => [] }.to_json)
    end

    Apis::XAPI::Accounts.new(bearer_token: "token", transport:).by_ids(%w[123 456])

    uri = URI(requests.first[:url])
    params = URI.decode_www_form(uri.query).to_h

    assert_equal "/2/users", uri.path
    assert_equal "123,456", params["ids"]
  end
end
