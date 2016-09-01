class User
  include Mongoid::Document
  field :name, type: String
  field :loc, type: Hash

  before_save :fix_location, if: :loc_changed?

  def fix_location
    self.loc = {
      type: "Point",
      coordinates: self.loc["coordinates"].map(&:to_f)
    }
  end

  rails_admin do
    field :name, :string
    field :loc, :map
  end
end
