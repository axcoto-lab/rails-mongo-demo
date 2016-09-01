require 'date'

class Advice

  # Find an advice
  def self.find(criteria)
    events = Event.upcoming.within(criteria[:long], criteria[:lat], criteria[:diameter])

    advice = events.empty??
              Recommendation.where(:skin_type => criteria[:skin_type]).try(:sample) :
              events.first

    if advice
      AdviceBuilder::Builder.new(advice, criteria).build
    end
  end
end
