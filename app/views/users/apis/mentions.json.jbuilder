json.array!(@response) do |res|
  json.extract! res, :text
  json.created_at res.created_at.in_time_zone.strftime("%m月%d日%H:%M")
  json.id_str res.id.to_s
  json.user do |json|
    json.extract! res.user, :screen_name, :name
    json.profile_image_url res.user.profile_image_url.to_s
  end
end
