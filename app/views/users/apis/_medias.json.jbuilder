json.media medias.map {|m|
  m.media_url_https.to_s
}
json.video medias.map {|m|
  m.class == Twitter::Media::AnimatedGif ? m.video_info.variants.first.url.to_s : ""
}
