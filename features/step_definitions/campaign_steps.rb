Given /^(#{AUTHOR}) has an? (.*)?campaign for "([^"]+)" targeting (#{DOLLAR_AMOUNT}) by (#{DATE})$/ do |author, state, title, target_amount, target_date|
  book_version = author.book_versions.find_by_title(title)
  expect(book_version).not_to be_nil
  state = state.present? ? state.strip : 'active'
  FactoryGirl.create(:campaign, book: book_version.book,
                                target_amount: target_amount,
                                target_date: target_date,
                                state: state)
end

Given /^(?:the )?(#{BOOK}) has an? (.*)?campaign targeting (#{DOLLAR_AMOUNT})(?: by (#{DATE}))?$/ do |book, state, target_amount, target_date|
  state = state.present? ? state.strip : 'active'
  target_date = (Date.today + 30) unless target_date.present?
  FactoryGirl.create(:campaign, book: book,
                                target_amount: target_amount,
                                target_date: target_date,
                                state: state)
end

Given /^(#{BOOK}) has an active campaign$/ do |book|
  FactoryGirl.create(:campaign, book: book)
end

Given /^(?:the )?(#{BOOK}) has a campaign$/ do |book|
  FactoryGirl.create(:campaign, book: book)
end

When /^donation collection has finished for the (#{BOOK})$/ do |book|
  campaign = book.campaigns.collecting.first
  expect(campaign).not_to be_nil
  DonationCollector.perform campaign.id
end

Given /(#{CAMPAIGN}) is (collected|active)/ do |campaign, state|
  campaign.update_attribute :state, state
end
