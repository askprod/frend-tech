require "json"
require "rest-client"

class Apis::BaseClient
  attr_reader :base_url, :headers, :timeout, :transport
  private :base_url, :headers, :timeout, :transport

  class Error < StandardError
    attr_reader :status, :body

    def initialize(message, status: nil, body: nil)
      super(message)
      @status = status
      @body = body
    end
  end

  class AuthenticationError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end

  def initialize(base_url:, headers: {}, timeout: 10, transport: nil)
    @base_url = base_url
    @headers = headers
    @timeout = timeout
    @transport = transport
  end

  private

  def get(path, params: {}, headers: {})
    request(:get, path, params:, headers:)
  end

  def post(path, params: {}, headers: {})
    request(:post, path, params:, headers:)
  end

  def delete(path, params: {}, headers: {})
    request(:delete, path, params:, headers:)
  end

  def request(method, path, params: {}, headers: {})
    response = perform_request(
      method:,
      url: build_url(path, params),
      headers: self.headers.merge(headers),
      timeout:,
      open_timeout: timeout
    )

    parse_response(response)
  rescue RestClient::ExceptionWithResponse => error
    parse_response(error.response)
  end

  def build_url(path, params)
    uri = URI.join(base_url, path)
    query = params.compact_blank
    uri.query = URI.encode_www_form(query) if query.any?
    uri.to_s
  end

  def perform_request(options)
    return transport.call(options) if transport

    RestClient::Request.execute(**options)
  end

  def parse_response(response)
    body = response.body.presence
    parsed_body = body ? JSON.parse(body) : {}
    status = response.code.to_i

    return parsed_body if status.between?(200, 299)

    raise error_class_for(status).new(error_message(parsed_body, status), status:, body: parsed_body)
  rescue JSON::ParserError => error
    raise Error.new("API returned invalid JSON: #{error.message}", status: response.code.to_i, body: response.body)
  end

  def error_class_for(status)
    case status
    when 401, 403 then AuthenticationError
    when 404 then NotFoundError
    when 429 then RateLimitError
    when 500..599 then ServerError
    else Error
    end
  end

  def error_message(body, status)
    detail = body["detail"] || body["title"] || body["error"] || body["message"]
    detail.presence || "API request failed with status #{status}"
  end
end
