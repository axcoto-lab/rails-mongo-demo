module Skin
  class Skin
    SKIN_TYPE_NORMAL = 1
    SKIN_TYPE_DRY = 2
    SKIN_TYPE_OIL = 3

    class << self
      def point(skin)
        case skin.lowcase
        when 'normal'.freeze
          SKIN_TYPE_NORMAL
        when 'dry'.freeze
          SKIN_TYPE_DRY
        when 'oil'.freeze
          SKIN_TYPE_OIL
        end
      end

    end
  end
end
