# X API Services

These classes wrap the X API calls used to track accounts, account stats, posts, and post stats.

## Classes

- `Apis::XAPI::Accounts` fetches X users and their public profile metrics.
- `Apis::XAPI::Posts` fetches tweets/posts and their public metrics.
- `Apis::XAPI::AccountTracker` combines account lookup with recent post fetching for one or many usernames.

## Examples

```ruby
accounts = Apis::XAPI::Accounts.new
accounts.by_usernames(["frendtech"])

posts = Apis::XAPI::Posts.new
posts.for_account("123456789", max_results: 10)

tracker = Apis::XAPI::AccountTracker.new
tracker.snapshot_username("frendtech", max_results: 10)
tracker.snapshot_usernames(["frendtech", "example"], max_results: 10)
tracker.snapshot_username("frendtech", since_id: "latest_tracked_post_id")
```
