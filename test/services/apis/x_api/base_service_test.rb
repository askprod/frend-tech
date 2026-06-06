require "test_helper"

class Apis::XAPI::BaseServiceTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body, keyword_init: true)

  class CredentialsClient < Apis::XAPI::BaseService
    def fetch
      get("/2/test")
    end
  end

  test "uses environment scoped Rails credentials for X API authentication" do
    requests = []
    credentials = {
      Rails.env.to_sym => {
        x_api: {
          api_key: "api-key",
          secret_key: "secret-key",
          bearer_token: "credential-bearer-token"
        }
      }
    }
    transport = lambda do |options|
      requests << options
      Response.new(code: "200", body: {}.to_json)
    end

    with_credentials(credentials) do
      CredentialsClient.new(transport:).fetch
    end

    assert_equal "Bearer credential-bearer-token", requests.first[:headers]["Authorization"]
  end

  private

  def with_credentials(credentials)
    application = Rails.application
    original_credentials = application.method(:credentials)

    application.define_singleton_method(:credentials) { credentials }
    yield
  ensure
    application.define_singleton_method(:credentials) { original_credentials.call }
  end
end
