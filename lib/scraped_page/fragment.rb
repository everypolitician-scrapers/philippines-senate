require 'field_serializer'

class ScrapedPage
  class Fragment
    include FieldSerializer

    def initialize(noko:, url:)
      @noko = noko
      @url = url
    end

    private

    attr_reader :noko, :url
  end
end
