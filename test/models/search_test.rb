require "test_helper"

class SearchTest < ActiveSupport::TestCase
  setup do
    Searchable::EnglishEvent.reindex
  end

  test "should create a search for all events" do
    search = Search.create!(
      search_query: search_queries(:empty),
      searchable_event_type: "Searchable::EnglishEvent",
      keywords: "*",
      conditions: {},
    )

    assert_equal search.status, "completed"
    assert_equal search.result.count, 3
  end
end
