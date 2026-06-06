require "test_helper"

class Apis::XAPI::AccountTrackerTest < ActiveSupport::TestCase
  FakeAccounts = Struct.new(:response, keyword_init: true) do
    def by_usernames(_usernames)
      response
    end
  end

  FakePosts = Struct.new(:responses, keyword_init: true) do
    def for_account(account_id, since_id: nil, max_results: 10)
      responses.fetch(account_id).merge("since_id" => since_id, "max_results" => max_results)
    end
  end

  test "captures account and post snapshots by username" do
    account = { "id" => "123", "username" => "frendtech", "public_metrics" => { "followers_count" => 10 } }
    tracker = Apis::XAPI::AccountTracker.new(
      accounts: FakeAccounts.new(response: { "data" => [ account ] }),
      posts: FakePosts.new(responses: { "123" => { "data" => [ { "id" => "999" } ] } })
    )

    snapshot = tracker.snapshot_username("frendtech", since_id: "998", max_results: 5)

    assert_equal account, snapshot[:account]
    assert_equal [ { "id" => "999" } ], snapshot[:posts]
  end

  test "captures grouped post snapshots for multiple accounts" do
    accounts = [
      { "id" => "123", "username" => "frendtech" },
      { "id" => "456", "username" => "example" }
    ]
    tracker = Apis::XAPI::AccountTracker.new(
      accounts: FakeAccounts.new(response: { "data" => accounts }),
      posts: FakePosts.new(
        responses: {
          "123" => { "data" => [ { "id" => "999" } ] },
          "456" => { "data" => [ { "id" => "888" } ] }
        }
      )
    )

    snapshot = tracker.snapshot_usernames(
      %w[frendtech example],
      since_id_by_account_id: { "456" => "887" },
      max_results: 5
    )

    assert_equal accounts, snapshot[:accounts]
    assert_equal [ { "id" => "999" } ], snapshot[:posts_by_account_id]["123"]
    assert_equal [ { "id" => "888" } ], snapshot[:posts_by_account_id]["456"]
  end
end
