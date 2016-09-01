require 'test_helper'

class Pod::FetcherTest < ActiveSupport::TestCase
  setup do
    @csv_url = "http://csv.url"
    @json_url = "http://json.url"
    @csv_content =
      <<-CMD
b B   http://www.myaudiocast.com/mellmellly4/rss/ http://www.myaudiocast.com/mellmellly4/ mellmellly4 mellmellly4@gmail.com ()  ""  ""  false ""  ""
      CMD
    @json_content = {
        error: nil,
        result: "success",
        count: 50,
        podcasts: [{
          "title" => "This American Life",
          "podcast_id" => 2,
          "image_url" => "http://www.thisamericanlife.org/sites/all/themes/thislife/images/logo-square-1400.jpg",
          "feed_url" => "http://feeds.thisamericanlife.org/talpodcast"
        }]
    }

    stub_request(:get, @csv_url).
      to_return(:status => 200, :body => @csv_content)

    stub_request(:get, @json_url).
      to_return(:status => 200, :body => @json_content.to_json)
  end

  test 'parse json' do
    podcasts = Pod::Fetcher.new.request_json(@json_url)
    assert_equal podcasts, @json_content[:podcasts]
  end

  test 'sync' do
    Podcast.delete_all
    Pod::Fetcher.stub :request_json, @json_content[:podcasts] do
      Pod::Fetcher.sync!
    end
    assert_equal 1, Podcast.count
  end
end
