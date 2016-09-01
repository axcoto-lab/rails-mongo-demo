class Recommendation
  include Mongoid::Document
  extend Enumerize

  index({skin_type: 1})

  SKIN_TYPE_LIST = %w(
    normal oil dry
  ).freeze

  field :template, type: String
  field :advice, type: String
  field :skin_type, type: String do
    enum_method do
      :skin_type_list
    end
  end

  enumerize :skin_type, in: SKIN_TYPE_LIST

  def skin_type_list
    %w(
    normal oil dry
    ).freeze
  end
end
