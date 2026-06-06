class Apis::XAPI::AccountTracker
  attr_reader :accounts, :posts
  private :accounts, :posts

  def initialize(accounts: nil, posts: nil)
    @accounts = accounts ||= Apis::XAPI::Accounts.new
    @posts = posts ||= Apis::XAPI::Posts.new
  end

  def snapshot_username(username, since_id: nil, max_results: 10)
    account = accounts.by_usernames([ username ]).fetch("data").first

    {
      account:,
      posts: posts
        .for_account(account.fetch("id"), since_id:, max_results:)
        .fetch("data", [])
    }
  end

  def snapshot_usernames(usernames, since_id_by_account_id: {}, max_results: 10)
    accounts_response = accounts.by_usernames(usernames)
    tracked_accounts = accounts_response.fetch("data", [])

    {
      accounts: tracked_accounts,
      posts_by_account_id: tracked_accounts.to_h do |account|
        account_id = account.fetch("id")

        [
          account_id,
          posts
            .for_account(account_id, since_id: since_id_by_account_id[account_id], max_results:)
            .fetch("data", [])
        ]
      end
    }
  end
end
