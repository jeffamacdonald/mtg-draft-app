class FileField < ViewComponent::Base
  attr_reader :form, :name, :help, :file_format

  def initialize(form:, name:, help:, file_format:)
    @form = form
    @name = name
    @help = help
    @file_format = file_format
  end
end
