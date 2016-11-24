class MemberRow < Scraped::HTML
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
