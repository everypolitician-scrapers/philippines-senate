class OpenURICachedStrategy < Scraped::Request::Strategy
  def response
    response = OpenUriCachedArchive.new(cache_directory).responses.find { |r| r.base_uri.to_s == url.to_s }
    { status: response.status.first.to_i, body: response.read, headers: response.meta }
  end

  private

  def cache_directory
    config[:cache_directory] || '.cache'
  end
end
