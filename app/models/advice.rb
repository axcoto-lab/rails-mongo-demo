require 'Date'

class Advice

  # Find an advice
  def self.find(criteria)
    puts criteria

    today = Date.today
    events = Event
      .where(:start_at.gte => today.to_s)
      .where(:start_at.lte => (today+2).to_s)
      .where(loc: {
        "$near" => {
           "$geometry" => {
              type: "Point" ,
              coordinates: [ criteria[:long].to_f, criteria[:lat].to_f ]
           },
           "$maxDistance" => criteria[:diameter].to_f * 1609.34
        }
      })
    if events.first
      advice_from_event(events.sample)
    else
      advice_from_recomendation(Recommendation.where(:skin_type => criteria[:skin_type]))
    end
  end

  # Build advice from event
  def advice_from_event(event)
    event.description
  end

  def advice_from_recomendation(recomendation)
    
  end
end
