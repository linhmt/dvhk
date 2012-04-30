Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  User.new(:email => email,
    :password => password, 
    :password_confirmation => password,
    :name => "test").save!

  visit '/users/sign_in'
  fill_in "user_email", :with=>email
  fill_in "user_password", :with=>password
  click_button "Sign In"
end

When /^user goes to Actions page$/ do
  click_ "Actions"
end

When /^click Create Flight$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^user is redirected to Create Flight form$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^a user not logged in$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^user is redirected to Sign In form$/ do
  pending # express the regexp above with the code you wish you had
end