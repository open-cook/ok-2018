xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0" ,
  "xmlns:content"=>"http://purl.org/rss/1.0/modules/content/",
  "xmlns:media"=>"http://search.yahoo.com/mrss/",
  "xmlns:wfw"=>"http://wellformedweb.org/CommentAPI/",
  "xmlns:dc"=>"http://purl.org/dc/elements/1.1/"){

  xml.channel do
    xml.title "open-cook.ru, RSS feed"
    xml.description "Открытая Кухня Анны Нечаевой. Сайт с рецептами простых и доступных блюд, которые может приготовить каждый из самых обычных продуктов"
    xml.link "http://open-cook.ru"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.intro
        xml.link polymorphic_url(post)
        xml.pubDate post.created_at.to_s(:rfc822)
      end
    end
  end
}

