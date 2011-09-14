require 'spec_helper'

describe ActivityFeed::Feed do
  it 'should pull up the correct list of ActivityFeed:Items when calling #page using :memory_item' do    
    1.upto(5) do |index|
      item = Fabricate(ActivityFeed.persistence, :user_id => 1, :nickname => 'nickname_1', :text => "text_#{index}")
      item.save
    end
    
    feed = ActivityFeed::Feed.new(1)
    feed.page(1).size.should be(5)
  end

  it 'should pull up the correct list of ActivityFeed:Items when calling #page using :mongo_mapper_item' do    
    ActivityFeed.persistence = :mongo_mapper_item
    ActivityFeed::MongoMapperItem.count.should be(0)
    1.upto(5) do |index|
      item = Fabricate(ActivityFeed.persistence, :user_id => 1, :nickname => 'nickname_1', :text => "text_#{index}")
      item.save
    end
    ActivityFeed::MongoMapperItem.count.should be(5)
    
    feed = ActivityFeed::Feed.new(1)
    feed.page(1).size.should be(5)
  end
  
  it 'should return the correct number for #total_items' do
    1.upto(3) do |index|
      item = Fabricate(ActivityFeed.persistence, :user_id => 1, :nickname => 'nickname_1', :text => "text_#{index}")
      item.save
    end
    
    feed = ActivityFeed::Feed.new(1)
    feed.total_items.should be(3)
  end
  
  it 'should return the correct number for #total_pages' do
    1.upto(Leaderboard::DEFAULT_PAGE_SIZE + 1) do |index|
      item = Fabricate(ActivityFeed.persistence, :user_id => 1, :nickname => 'nickname_1', :text => "text_#{index}")
      item.save
    end
    
    feed = ActivityFeed::Feed.new(1)
    feed.total_pages.should be(2)
  end
end