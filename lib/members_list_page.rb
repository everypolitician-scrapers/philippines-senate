require 'scraped_page'
require_relative 'member_row'

class MembersListPage < ScrapedPage
  field :term do
    noko.css('#content .h1_bold').first.text.tidy
  end

  field :term_id do
    term.to_i
  end

  section :members, MemberRow do
    noko.css('.officerdiv').xpath('.//td[.//span[@class="h1_sub"]]')
  end
end
