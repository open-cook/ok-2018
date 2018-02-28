json.array! @pubs do |pub|
  json.image image_url pub.main_image.url(:preview, timestamp: false)
  json.title pub.title
  json.intro pub.intro
end
