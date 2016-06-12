require 'rails_helper'

RSpec.feature "User can add friends" do
  scenario "by email address" do
    visit friends_path

    within(".sign-up-page") do
      fill_in "Username",                 with: "pindell@example.com"
      fill_in "Password",              with: "password"
      fill_in "Password Confirmation", with: "password"
      click_button "Sign up"
    end

    expect(current_path).to eq "/wallets/new"
    expect(User.first.email).to eq "pindell@example.com"

    within(".flash") do
      expect(page).to have_content "Welcome! You have signed up successfully."
    end
  end
end
