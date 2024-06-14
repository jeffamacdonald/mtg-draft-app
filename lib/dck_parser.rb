class DckParser
  attr_reader :dck_file
  attr_accessor :import_cards, :invalid_records

  def initialize(dck_file)
    @dck_file = dck_file
    @import_cards = []
    @invalid_records = []
  end

  def call
    parse_file
    [import_cards, invalid_records]
  end

  private

  def parse_file
    open_file_content.each do |line|
      count, set, num, name = split_line(line)
      validate_name(name)
      validate_count(count&.to_i, name)
      validate_set(set, name)

      if valid?(name)
        import_cards << Import::Card.new(
          :count => count&.to_i,
          :set => set,
          :name => parse_name(name)
        )
      end
    end
  end

  def split_line(line)
    initial_split = line.gsub("\n","").gsub("\r","").split(Regexp.union([' [','] ']))
    [initial_split[0], initial_split[1].split(":").first, initial_split[2]]
  end

  def valid?(name)
    name.present? && invalid_records.none? { |record| record.name == name }
  end

  def validate_name(name)
    if name.blank?
      invalid_records << Import::InvalidRecord.new(
        name: "N/A",
        error_message: "Unknown card, name is blank")
    end
  end

  def validate_count(count, name)
    if count.blank? || count < 1
      invalid_records << Import::InvalidRecord.new(
        name: "#{name || "N/A"}",
        error_message: "Count Invalid"
      )
    end
  end

  def validate_set(set, name)
    if set.blank? || !set.length.between?(3,4)
      invalid_records << Import::InvalidRecord.new(
        name: "#{name || "N/A"}",
        error_message: "Set Invalid"
      )
    end
  end

  def parse_name(name)
    if name&.include?("//") && !name&.include?(" // ")
      name.gsub("//", " // ")
    else
      name
    end
  end

  def open_file_content
    if dck_file.attached?
      file_path = ActiveStorage::Blob.service.send(:path_for, dck_file.key)
      File.open(file_path)
    else
      raise "No file attached"
    end
  end
end
