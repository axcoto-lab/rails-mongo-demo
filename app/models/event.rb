class Event
  include Mongoid::Document

  EVENT_NEAR_DAY_THRESHOLD = 2
  MILE_TO_METER_RATIO = 1609.34

  index({loc: "2dsphere"})

  field :type, type: String
  field :description, type: String
  field :loc, type: Hash
  field :start_at, type: DateTime

  validates :type, presence: true
  validates :description, presence: true
  validates :loc, presence: true
  validates :start_at, presence: true

  rails_admin do
    field :type, :string
    field :description, :text
    field :start_at, :date

    field :loc, :map
  end

  before_save :fix_location, if: :loc_changed?

  scope :upcoming, -> {
    today = Date.today
    where(:start_at.gte => today.to_s)
      .where(:start_at.lte => (today + EVENT_NEAR_DAY_THRESHOLD).to_s)
  }

  scope :within, ->(long, lat, diameter) {
    where(loc: {
      "$near" => {
         "$geometry" => {
            type: "Point" ,
            coordinates: [ long.to_f, lat.to_f ]
         },
         "$maxDistance" => diameter.to_f * MILE_TO_METER_RATIO
      }
    })
  }

  def fix_location
    return if self.loc["coordinates"].nil?

    self.loc = {
      type: "Point",
      coordinates: self.loc["coordinates"].map(&:to_f)
    }
  end
end
