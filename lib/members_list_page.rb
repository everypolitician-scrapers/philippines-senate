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
