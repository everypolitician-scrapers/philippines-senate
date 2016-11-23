require 'bundler/setup'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'pry'
require 'scraped'
require 'open-uri-cached-archive'
require 'scraperwiki'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
  end
end

class MembersListPage < Scraped
  field :term do
    noko.css('#content .h1_bold').first.text.tidy
  end

  field :term_id do
    term.to_i
  end

  field :members do
    noko.css('.officerdiv').xpath('.//td[.//span[@class="h1_sub"]]')
  end
end

class MemberRow < Scraped
  field :image do
    noko.parent.at_css('img')[:src]
  end

  field :name do
    noko.at_css('strong').text.tidy.sub(/^Senator /, '')
  end

  field :post do
    noko.at_css('em') && noko.at_css('em').text.tidy
  end
end

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

class ForceUTF8BodyEncoding < Scraped::Response::Decorator
  def body
    super.force_encoding('utf-8')
  end
end

class AbsoluteUrlsForImages < Scraped::Response::Decorator
  def body
    doc = Nokogiri::HTML(super)
    doc.css('img').each do |img|
      img[:src] = URI.join(url, img[:src]).to_s
    end
    doc.to_s
  end
end

url = 'http://www.senate.gov.ph/senators/sen17th.asp'

response = Scraped::Request.new(
  url: url,
  strategies: [
    OpenURICachedStrategy,
    Scraped::Request::Strategy::LiveRequest
  ]
).response(
  decorators: [ForceUTF8BodyEncoding, AbsoluteUrlsForImages]
)

page = MembersListPage.new(response: response)

page.members.each do |member|
  row = MemberRow.new(noko: member, response: response)
  puts row.to_h
  ScraperWiki.save_sqlite([:name], row.to_h)
end
