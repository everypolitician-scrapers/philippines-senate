require 'bundler/setup'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'pry'
require 'scraped'
require 'open-uri-cached-archive'
require 'scraperwiki'

class OpenURICachedStrategy < Scraped::Request::Strategy
  def response
    response = OpenUriCachedArchive.new('.cache').responses.find { |r| r.base_uri.to_s == url.to_s }
    { status: response.status.first.to_i, body: response.read, headers: response.meta }
  end
end

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
    URI.join(url, noko.parent.at_css('img')[:src]).to_s
  end

  field :name do
    noko.at_css('strong').text.tidy.sub(/^Senator /, '')
  end

  field :post do
    noko.at_css('em') && noko.at_css('em').text.tidy
  end
end

url = 'http://www.senate.gov.ph/senators/sen17th.asp'
response = Scraped::Request.new(url: url, strategies: [OpenURICachedStrategy]).response
page = MembersListPage.new(response: response)

page.members.each do |member|
  row = MemberRow.new(noko: member, response: response)
  puts row.to_h
  ScraperWiki.save_sqlite([:name], row.to_h)
end
