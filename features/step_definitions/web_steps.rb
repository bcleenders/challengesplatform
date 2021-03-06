When(/^I visit the "(.*?)" page$/) do |pageName|
  visit getRoute(pageName)
end

def getRoute(name)
  case name
    # authentication-related
    when "login"
      new_user_session_path
    when "dashboard.index"
      dashboard_path
    when "dashboard"
      dashboard_path
    when "index"
      root_path
    when "logout"
      destroy_user_session_path
    when "registration.new"
      new_user_registration_path
    when "challenges.index"
      challenges_path
    when "challenge.new"
      new_challenge_path
    when "search.index"
      search_path

    #static
    when "aboutus"
      aboutus_path
    when "team"
      team_path
    when "createchallenge"
      createchallenge_path
    when "challengeguidelines"
      challengeguidelines_path
    when "universities"
      universities_path
    when "companies"
      companies_path
    when "termsofservice"
      termsofservice_path
    when "privacy"
      privacy_path
    when "press"
      press_path

    # Admin namespace
    when "admin/review.index"
      admin_review_index_path
    when "admin/usermanagement.index"
      admin_usermanagement_index_path
    when /^admin\/users.([0-9]+).edit$/
      edit_admin_user_path($1)
    when "admin/users.new"
      new_admin_user_path
    

    #Challenge related
    when /^challenges.([0-9]+)$/ #matches a challenge id
      challenge_path($1)
    when /^challenges.([0-9]+).edit$/ #matches a challenge id
      edit_challenge_path($1)
    when /^user.([0-9]+).profile$/
      profile_user_path($1)
    when /^challenges.([a-z]+)$/
      "/challenges/" + $1

    # Message related
    when "messages"
      messages_path
    when /^messages.([0-9]+)$/
      message_path($1)

    #user
    when "user.edit"
        edit_user_registration_path
    else
      print("Invalid route requested (" + name + ")")
  end
end

def getRouteWithUser(name, user)
  case name 
  when "user.edit"
    edit_user_registration_path(user)
  else
    print("Invalid route requested (" + name + ")")
  end
end

When(/^I visit the "(.*?)" page for user "(.*?)"$/) do |page, email|
  user = User.where(:email => email).first
  
  visit getRouteWithUser(page,user)

end

Then(/^I should see the "(.*?)" button$/) do |buttonID|
  find("#" + buttonID).should_not be_nil
end

Then(/^I should see a message with "(.*?)"$/) do |contents|
  page.should have_content(contents)
end

Then(/^I should not see a message with "(.*?)"$/) do |contents|
  page.should_not have_content(contents)
end

Then(/^I should see the "(.*?)" page$/) do |pageName|
  page.should_not be_nil
  find('input#page_identifier').value.should eql pageName
end

Then(/^I should see "(.*?)" in section "(.*?)"$/) do |text, section|
  within(:xpath, "//div[@id='#{css_case(section)}']") do
    page.should have_content(text)
  end
end

Then(/^I should not see "(.*?)" in section "(.*?)"$/) do |text, section|
  within(:xpath, "//div[@id='#{css_case(section)}']") do
    page.should_not have_content(text)
  end
end

Then(/^I should see a "(.*?)" field in the form$/) do |fieldName|
  page.should have_xpath('//input[@name="{fieldName}"] | //textarea[@name="{fieldName}"] | //select[@name="{fieldName}"]')
end

def css_case(str)
  str.squish.underscore.downcase.tr(" ","_")
end

def stringToDate(string)
  case string
    when 'today' then
      Date.today
    when 'tomorrow' then
      Date.tomorrow
    when 'next month' then
      Date.today >> 1
    when 'last month' then
      Date.today << 1
    when 'last week' then
      Date.today - 7
    when 'next week' then
      Date.today + 7
    when 'last year' then
      Date.today + 365
    when 'next year' then
      Date.today - 365
    else
      string
  end
end


def interpret_dates(hash)
  # Interpret dates
  hash.each do |key, value|
    if key.include?("date")
      hash[key] = stringToDate(value)
    end
    if key.include?("updated_at")
         hash[key] = case value
      when 'today' then
        Time.now
      when 'tomorrow' then
        Time.now + 24*3600
      when 'next month' then
        Time.now + 30*24*3600
      when 'last month' then
        Time.now - 30*24*3600
      when 'last week' then
        Time.now - 24*3600*7
      when 'next week' then
        Time.now + 24*3600*7
      when 'last year' then
        Time.now - 24*3600*365
      when 'next year' then
        Time.now + 24*3600*365
      else
        value
      end
    end
  end
end

Given(/^the following (.+) records?$/) do |factory, table|
  table.hashes.each do |hash|
    interpret_dates(hash)
    FactoryGirl.create(factory, hash)
  end
end

Then(/^show me the page$/) do
  print page.html
  save_and_open_page
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in field, :with => value
end

Then(/^I should be on the "(.*?)" page$/) do |url|
  current_path.should == getRoute(url)
end