require 'bundler/setup'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'pry'
require 'scraped'
require 'open-uri-cached-archive'
require 'scraperwiki'
require 'require_all'
require_rel 'lib'

class String
  def tidy
    gsub(/[[:space:]]+/, ' ').strip
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
