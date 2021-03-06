# frozen_string_literal: true

require 'spec_helper'

describe 'Listing labs' do
  it 'approved labs are on index page' do
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: 'Fab Lab BCN')
    visit labs_path
    expect(page).to have_link 'Fab Lab BCN'
  end

  it 'unapproved labs are not on the index page' do
    lab = FactoryBot.create(:lab, name: 'A Lab')
    visit labs_path
    expect(page).to_not have_link 'A Lab'
  end

  it 'labs can be filtered by country code' do
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: 'USA Fab lab', country_code: 'us')
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: 'Spain Fab lab', country_code: 'sp')
    visit labs_path(country: 'US')
    expect(page).to have_link 'USA Fab lab'
    expect(page).to_not have_link 'Spain Fab lab'
  end
end

feature 'Searching Labs' do
  # We have to add the ability to submit the form without a submit button
  class Capybara::Session
    def submit(element)
      Capybara::RackTest::Form.new(driver, element.native).submit({})
    end
  end

  scenario 'finds labs that match a query in the name' do
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: 'The string asdf')
    visit labs_path
    expect(page).to have_text 'The string asdf'
    fill_in 'search-box', with: 'The string asdf' #
    form = find '.navbar-form' # find the form
    page.submit form # use the new .submit method, pass form as the argument
    expect(page).to have_text 'The string asdf'
  end

  scenario 'finds labs that match a query in the slug' do
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: "something that doesn't match", slug: 'thestringasdf')
    visit labs_path
    expect(page).to have_text "something that doesn't match"
    fill_in 'search-box', with: 'asdf' #
    form = find '.navbar-form' # find the form
    page.submit form # use the new .submit method, pass form as the argument
    expect(page).to have_text "something that doesn't match"
  end

  scenario 'finds labs that match a query in the country' do
    lab_usa = FactoryBot.create(:lab, workflow_state: 'approved', name: "something that doesn't match", slug: 'thestringasdf', country_code: 'US')
    lab_spain = FactoryBot.create(:lab, workflow_state: 'approved', country_code: 'SP')
    visit labs_path
    expect(page).to have_text "something that doesn't match"
    expect(page).to have_text 'US'
    expect(page).to have_text 'SP'
    fill_in 'search-box', with: 'United States of America' #
    form = find '.navbar-form' # find the form
    page.submit form # use the new .submit method, pass form as the argument
    expect(page).to have_text 'US'
    expect(page).to_not have_text 'SP'
  end

  scenario 'does not find labs that match neither name nor slug' do
    lab = FactoryBot.create(:lab, workflow_state: 'approved', name: "something that doesn't match", slug: 'thisdoesnotmatcheither')
    visit labs_path
    fill_in 'search-box', with: 'asdf' #
    form = find '.navbar-form' # find the form
    page.submit form # use the new .submit method, pass form as the argument
    expect(page).to_not have_text "something that doesn't match"
    expect(page).to have_text 'We could not find'
  end
end
