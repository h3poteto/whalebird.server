json.extract! @response, :screen_name, :description, :statuses_count, :friends_count, :followers_count
json.profile_image_url @response.profile_image_url.to_s
