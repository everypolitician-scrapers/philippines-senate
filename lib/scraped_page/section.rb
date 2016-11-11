require 'field_serializer'

class ScrapedPage
  def self.section(name, klass, &block)
    define_method(name) do
      instance_eval(&block).map do |noko|
        klass.new(noko: noko, url: url)
      end
    end
  end

  class Section
    include FieldSerializer

    def initialize(noko:, url:)
      @noko = noko
      @url = url
    end

    private

    attr_reader :noko, :url
  end
end
