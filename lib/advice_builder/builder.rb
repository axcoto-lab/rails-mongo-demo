module AdviceBuilder
  class Builder
    attr_reader :advice, :criteria

    def initialize(advice, criteria)
      @advice = advice
      @criteria = criteria
    end

    def build
      body = case advice
      when Event
        build_for_event
      when Recommendation
        build_for_recomendation
      end
      if body
        {advice: body}
      end
    end

    private
    # Build advice from event
    def build_for_event
      advice.description
    end

    # Build advice fromr recomendation
    def build_for_recomendation
      user_id = criteria[:user_id]
      return nil unless user_id

      begin
        user = User.find(user_id)
      rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
        return nil
      end

      advice.template
        .gsub("[NAME]", user.name)
        .gsub("[ADVICE]", advice.advice)
    end

  end
end
