json.array!(@response) do |res|
  json.extract! res, :text, :favorited?
  json.created_at res.created_at.strftime("%Y-%m-%d %H:%M")
  json.id_str res.id.to_s
  json.user do |json|
    json.extract! res.user, :screen_name, :name, :protected?
    json.profile_image_url res.user.profile_image_url.to_s
  end
  if res.media.present?
    json.media res.media.map {|m| m.media_url.to_s }
  end
end
