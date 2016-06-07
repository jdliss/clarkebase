require 'rails_helper'

RSpec.feature "User can login" do
  scenario "when a user fills in username, password they are logged in" do
    user = create(:user)

    visit root_path

    click_on "Sign In"

    expect(current_path).to eq new_user_session_path

    within(".sign-in") do
      fill_in "Email",    with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end

    expect(current_path).to eq root_path

    within(".flash") do
      expect(page).to have_content "Signed in successfully."
    end
  end
end
