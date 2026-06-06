class Apis::XAPI::BaseService < Apis::BaseClient
  attr_reader :api_key, :secret_key, :bearer_token
  private :api_key, :secret_key, :bearer_token

  BASE_URL = "https://api.x.com"

  DEFAULT_USER_FIELDS = %w[
    created_at
    description
    id
    location
    name
    profile_image_url
    public_metrics
    username
    verified
    verified_type
  ].freeze

  DEFAULT_POST_FIELDS = %w[
    attachments
    author_id
    conversation_id
    created_at
    entities
    id
    lang
    public_metrics
    referenced_tweets
    text
  ].freeze

  def initialize(
    api_key: x_api_credentials[:api_key],
    secret_key: x_api_credentials[:secret_key],
    bearer_token: x_api_credentials[:bearer_token] || ENV["X_API_BEARER_TOKEN"],
    **options
  )
    @api_key = api_key
    @secret_key = secret_key
    @bearer_token = bearer_token

    super(
      base_url: BASE_URL,
      headers: default_headers(bearer_token),
      **options
    )
  end

  private

  def default_headers(bearer_token)
    {
      "Accept" => "application/json",
      "Authorization" => bearer_token.present? ? "Bearer #{bearer_token}" : nil
    }.compact
  end

  def x_api_credentials
    environment_credentials = Rails.application.credentials.dig(Rails.env.to_sym, :x_api)

    environment_credentials.presence || Rails.application.credentials.dig(:x_api) || {}
  end

  def csv(values)
    Array(values).compact_blank.join(",")
  end
end
