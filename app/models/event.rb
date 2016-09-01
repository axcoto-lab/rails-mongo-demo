class Event
  include Mongoid::Document

  index({loc: "2dsphere"})

  field :type, type: String
  field :description, type: String
  field :loc, type: Hash
  field :start_at, type: DateTime

  before_save :fix_location, if: :loc_changed?

  def fix_location
    self.loc = {
      type: "Point",
      coordinates: self.loc["coordinates"].map(&:to_f)
    }
  end

  rails_admin do
    field :type, :string
    field :description, :text
    field :start_at, :date

    field :loc, :map
  end

end
