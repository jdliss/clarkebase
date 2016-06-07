require 'rails_helper'

RSpec.feature "User can login" do
  scenario "when a user fills in username, password they are logged in" do
    user = create(:user)

    visit root_path

    click_on "Sign In"

    expect(current_path).to eq new_user_session_path

    within(".sign-in-page") do
      fill_in "Email",    with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end

    expect(current_path).to eq root_path

    within(".flash") do
      expect(page).to have_content "Signed in successfully."
    end
  end
  scenario "user can log out" do
    login_as create(:user), scope: :user

    visit root_path

    within(".navbar") do
      expect(page).to have_content "Sign Out"
      expect(page).to_not have_content "Sign In"
      expect(page).to_not have_content "Sign Up"
    end
  end
end
