class ForceUTF8BodyEncoding < Scraped::Response::Decorator
  def body
    super.force_encoding('utf-8')
  end
end
