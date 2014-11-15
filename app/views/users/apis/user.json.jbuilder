json.extract! @response, :screen_name, :statuses_count, :friends_count, :followers_count
json.description @response.description.present? ? @response.description : ""
json.profile_image_url @response.profile_image_url.to_s
