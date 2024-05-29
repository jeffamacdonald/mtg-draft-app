class SkippedPick
  def name
    "SKIPPED"
  end

  def color_identity
    Card::SkippedColorIdentity.new
  end
end
