require_relative 'scraped_page/fragment'
require 'uri'

class MemberRow < ScrapedPage::Fragment
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
