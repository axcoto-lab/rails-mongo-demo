require 'test_helper'
require 'date'

describe Advice do
  let(:user) {
    User.create(name: 'First User',
      loc: {
        type: 'Point',
        coordinates: [ -122.4376, 37.7577 ]
    })
  }

  let(:recomendation) {
    Recommendation.create(template: 'Good morning[NAME]! Sky is clear today. [ADVICE]',
      advice: 'Enjoy a nice day',
      skin_type: 'normal')
  }

  let(:criteria) {
    {
      diameter: 20,
      lat: 37.9578,
      long: -122.4376,
      user_id: user.id,
      skin_type: 'normal'
    }
  }

  before do
    Rake::Task['db:mongoid:create_indexes'].invoke
  end

  describe '#find' do
    describe 'when has no event' do
      before do
        Event.delete_all
      end

      describe 'has no recomendation' do
        it 'not match by user' do
          advice = Advice.find(criteria.merge(user_id: 'invalid'))
          assert_nil advice
        end

        it 'not match by skin' do
          advice = Advice.find(criteria.merge(skin_type: 'oil'))
          assert_nil advice
        end
      end

      describe 'has recomendation' do
        it 'return recomendation' do
          advice = Advice.find(criteria)
          assert_equal advice, {:advice=>"Good morningFirst User! Sky is clear today. Enjoy a nice day"}
        end
      end
    end

    describe 'when has event' do
      let(:event) {
          Event.create(type: 'First event',
            description: 'This is first event',
            loc: {
              type: 'Point',
              coordinates:  [ -122.4376, 37.7577 ]
            },
            start_at: (Date.today()+1).to_s)
      }
      before do
        event
      end

      describe 'match criteria' do
        it 'return description' do
          advice = Advice.find(criteria)
          assert_equal event.description, advice[:advice]
        end
      end

      describe 'doesn not match criteria' do
        it 'return recomendation' do
          advice = Advice.find(criteria.merge(lat: 50, long: 50))
          assert_equal({:advice => "Good morningFirst User! Sky is clear today. Enjoy a nice day"}, advice)
        end
      end
    end
  end
end
