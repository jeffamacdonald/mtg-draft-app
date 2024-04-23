module Import
  class Card < Struct.new(:count, :set, :name, keyword_init: true)
  end
end
