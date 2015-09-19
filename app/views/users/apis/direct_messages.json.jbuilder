json.array!(@response) do |res|
  json.extract! res, :text
  json.created_at res.created_at.strftime("%Y-%m-%d %H:%M")
  json.id_str res.id.to_s
  json.user do |json|
    json.extract! res.sender, :name, :screen_name
    json.profile_image_url res.sender.profile_image_url_https.to_s
  end
end
