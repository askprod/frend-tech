class Apis::XAPI::Posts < Apis::XAPI::BaseService
  DEFAULT_EXPANSIONS = %w[author_id referenced_tweets.id].freeze
  DEFAULT_EXCLUDES = %w[replies].freeze

  def by_ids(ids, post_fields: DEFAULT_POST_FIELDS, expansions: DEFAULT_EXPANSIONS)
    get(
      "/2/tweets",
      params: {
        ids: csv(ids),
        "tweet.fields": csv(post_fields),
        expansions: csv(expansions)
      }
    )
  end

  def for_account(
    account_id,
    since_id: nil,
    max_results: 10,
    post_fields: DEFAULT_POST_FIELDS,
    expansions: DEFAULT_EXPANSIONS,
    exclude: DEFAULT_EXCLUDES
  )
    get(
      "/2/users/#{account_id}/tweets",
      params: {
        since_id:,
        max_results:,
        "tweet.fields": csv(post_fields),
        expansions: csv(expansions),
        exclude: csv(exclude)
      }
    )
  end
end
