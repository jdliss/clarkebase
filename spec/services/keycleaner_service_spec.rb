require 'rails_helper'
require 'keycleaner_service'

RSpec.describe KeyCleanerService do
  it "it normalizes with normal pem format" do
    private_key = ENV["PEM_KEY"]

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key.delete("\n")).to eq ENV["PEM_KEY"].dup.delete("\n")
  end

  it "it normalizes with missing header and footer" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key.delete("\n")).to eq der_key.delete("\n")
  end

  it "it normalizes with missing new line chars" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = ENV["DER_KEY_WITH_HEADERS"].dup.delete("\n")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key.delete("\n")).to eq der_key.delete("\n")
  end

  it "it normalizes with missing new line chars and missing header/footer" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("\n", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key.delete("\n")).to eq der_key.delete("\n")
  end
end
