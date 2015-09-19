json.extract! @response, :name,:screen_name, :statuses_count, :friends_count, :followers_count, :following?
json.description @response.description.present? ? @response.description : ""
json.profile_image_url @response.profile_image_url_https.to_s
json.follower? @follower
json.private_account? !@response.following? && @response.protected?
json.follow_request_sent? @response.follow_request_sent?
