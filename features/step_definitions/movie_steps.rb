# The starter app renders each movie as a card inside #movies.
module MovieListHelpers
  def displayed_movie_titles
    all('#movies > div[id^="movie_"] > p:first-child').map do |title|
      title.text.sub(/\ATitle:\s*/, '').strip
    end
  end
end

World(MovieListHelpers)

Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then(/^(\d+) seed movies should exist$/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |first_title, second_title|
  titles = displayed_movie_titles
  expect(titles).to include(first_title, second_title)
  expect(titles.index(first_title)).to be < titles.index(second_title)
end

When(/^I check the following ratings: (.*)$/) do |rating_list|
  rating_list.split(',').map(&:strip).each do |rating|
    check(rating)
  end
end

Then(/^I should (not )?see the following movies: (.*)$/) do |negation, movie_list|
  titles = displayed_movie_titles
  movie_list.split(',').map(&:strip).each do |title|
    if negation
      expect(titles).not_to include(title)
    else
      expect(titles).to include(title)
    end
  end
end

Then(/^I should see all the movies$/) do
  expect(displayed_movie_titles).to match_array(Movie.pluck(:title))
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use this to write "Then debug" in your scenario to open a console.
  require "byebug"
  byebug
  1 # intentionally force debugger context in this method
end

Then(/^debug javascript$/) do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # Retained as requested by the starter; completed features never call it.
  raise "Remove this step from your .feature files"
end
