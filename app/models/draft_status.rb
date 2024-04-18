class DraftStatus
  class << self
    def all
      [pending, active, completed]
    end

    def pending
      "pending"
    end

    def active
      "active"
    end

    def completed
      "completed"
    end
  end
end
