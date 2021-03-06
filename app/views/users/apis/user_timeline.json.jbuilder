json.array!(@response) do |res|
  json.extract! res, :text, :favorited?
  json.created_at res.created_at.strftime("%Y-%m-%d %H:%M")
  json.id_str res.id.to_s
  json.user do |json|
    json.extract! res.user, :screen_name, :name, :protected?
    json.profile_image_url res.user.profile_image_url_https.to_s
  end
  if res.media.present?
    json.partial! 'users/apis/medias', medias: res.media
  end
  if res.retweeted_status.present?
    if res.media.present?
      json.partial! 'users/apis/medias', medias: res.retweeted_status.media
    end
    json.text res.retweeted_status.text
    json.created_at res.retweeted_status.created_at.strftime("%Y-%m-%d %H:%M")
    json.user do |json|
      json.extract! res.retweeted_status.user, :screen_name, :name, :protected?
      json.profile_image_url res.retweeted_status.user.profile_image_url_https.to_s
    end
    json.retweeted do |json|
      json.extract! res.user, :screen_name, :name, :protected?
      json.profile_image_url res.user.profile_image_url_https.to_s
      json.created_at res.retweeted_status.created_at
    end
  end
end
