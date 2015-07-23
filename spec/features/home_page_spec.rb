require "rails_helper"

RSpec.feature "Home page", type: :feature do
  before(:each) do
    @user = FactoryGirl.create :user,
            username: "Norin",
            email: "norin@example.com",
            password: "secret",
            password_confirmation: "secret",
            account_activated: true
  end
  
  # scenario "User visit home page" do
  #   5.times { FactoryGirl.create :episode }
    
  #   visit root_path
  #   expect(page).to have_selector("div#episodes>div", count: 5)
  # end
  
  scenario "User has already logged in" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    
    visit root_path
    expect(page).to have_selector("li", text: "Logout")
    expect(page).to have_selector("li", text: "Account")
    expect(page).to have_selector("a", text: @user.username.capitalize)
  end
  
  scenario "User has not logged in" do
    visit root_path
    expect(page).to have_selector("li", text: "Login")
    expect(page).to have_selector("li", text: "Register")
    expect(page).to_not have_selector("a", text: @user.username.capitalize)
  end
end
