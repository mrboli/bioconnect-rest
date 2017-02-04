module TimecardsHelper
  def timecard_exists?(id)
    Timecard.exists? id: id
  end
end
