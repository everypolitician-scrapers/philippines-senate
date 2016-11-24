class AbsoluteUrlsForImages < Scraped::Response::Decorator
  def body
    doc = Nokogiri::HTML(super)
    doc.css('img').each do |img|
      img[:src] = URI.join(url, img[:src]).to_s
    end
    doc.to_s
  end
end
