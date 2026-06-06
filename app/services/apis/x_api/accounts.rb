class Apis::XAPI::Accounts < Apis::XAPI::BaseService
  def by_usernames(usernames, user_fields: DEFAULT_USER_FIELDS)
    get(
      "/2/users/by",
      params: {
        usernames: csv(usernames),
        "user.fields": csv(user_fields)
      }
    )
  end

  def by_ids(ids, user_fields: DEFAULT_USER_FIELDS)
    get(
      "/2/users",
      params: {
        ids: csv(ids),
        "user.fields": csv(user_fields)
      }
    )
  end
end
