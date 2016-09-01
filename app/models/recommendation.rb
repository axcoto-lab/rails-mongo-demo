class Recommendation
  include Mongoid::Document
  extend Enumerize

  SKIN_TYPE_LIST = %w(
    normal oil dry combination sensitive
  ).freeze

  index({skin_type: 1})

  field :template, type: String
  field :advice, type: String
  field :skin_type, type: String do
    enum_method do
      :skin_type_list
    end
  end

  enumerize :skin_type, in: SKIN_TYPE_LIST

  validates :template, presence: true
  validates :advice, presence: true
  validates :advice, presence: true
  validates :skin_type, inclusion: { in: SKIN_TYPE_LIST,
    message: "%{value} is not a valid skin type" }

  private
  def skin_type_list
    SKIN_TYPE_LIST
  end
end
