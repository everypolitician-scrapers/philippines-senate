require 'bundler/setup'
require 'pry'
require 'scraped_page'
require 'scraperwiki'

require_relative 'lib/core_ext'
require_relative 'lib/members_list_page'
require_relative 'lib/member_row'

strategy = ScrapedPage::Strategy::LiveRequestArchive.new
url = 'http://www.senate.gov.ph/senators/sen17th.asp'

page = MembersListPage.new(url: url, strategy: strategy)

page.members.each do |member|
  row = MemberRow.new(noko: member, url: url)
  ScraperWiki.save_sqlite([:name], row.to_h)
end
