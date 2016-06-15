require 'rails_helper'
require 'keycleaner_service'

RSpec.describe KeyCleanerService do
  it "it normalizes with normal pem format" do
    private_key = ENV["PEM_KEY"]

    private_key = KeyCleanerService.clean_user_input(private_key)

    pem_key = ENV["PEM_KEY"].dup.delete("\n")
    pem_key = pem_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    pem_key = pem_key.gsub("-----END RSA PRIVATE KEY-----", "")

    expect(private_key.delete("\n")).to eq pem_key
  end

  it "it normalizes with missing header and footer" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    der_key = ENV["DER_KEY_WITH_HEADERS"].dup.delete("\n")
    der_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    der_key = der_key.gsub("-----END RSA PRIVATE KEY-----", "")

    expect(private_key.delete("\n")).to eq der_key
  end

  it "it normalizes with missing new line chars" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = ENV["DER_KEY_WITH_HEADERS"].dup.delete("\n")

    private_key = KeyCleanerService.clean_user_input(private_key)

    der_key = ENV["DER_KEY_WITH_HEADERS"].dup.delete("\n")
    der_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    der_key = der_key.gsub("-----END RSA PRIVATE KEY-----", "")

    expect(private_key.delete("\n")).to eq der_key
  end

  it "it normalizes with missing new line chars and missing header/footer" do
    der_key = ENV["DER_KEY_WITH_HEADERS"].dup
    private_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("\n", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    der_key = ENV["DER_KEY_WITH_HEADERS"].dup.delete("\n")
    der_key = der_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    der_key = der_key.gsub("-----END RSA PRIVATE KEY-----", "")

    expect(private_key.delete("\n")).to eq der_key
  end

  it "can reformat to 'public strict format'" do

    public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu6EKjlDGug/Vv9ibCQ0GRGADnZ1lCOczOuU6ZBRt7BZHzn16YSULZvy0fvDOEf4yrJM35nl6iwkzN4TdI5FecxVo/1GHx9v5NFY1cQw2EyvU/YVyEHcwpTn3BtqYkH2ZfZbvN0yp+Esd0HcO7m9AzdyFadwG27AX20Iis9lcvA/qO63lB4ITAhCH1zCz0adWICUS9+POAhLvL8wHHHi/F1969rA3ly8vioC1qpJFSflo/Ap35clL4mQzf7qsMPF6ysxUhTHrdVI+DPY0NjPLiE5mPRiBDDNIIXqcINDL6yuBukT3vXh6SyTIWUOy+OBnDqE9e8VCGMLETqTXkuwajwIDAQAB"

    formatted = KeyCleanerService.public_strict_format(public_key)

    expect(public_key).to_not start_with("-----BEGIN PUBLIC KEY-----")
    expect(formatted).to start_with("-----BEGIN PUBLIC KEY-----")
  end

  it "can generate the public key in a non-strict format given a valid private key" do
    der_private_key = ENV["PEM_KEY"].dup
    public_key = KeyCleanerService.non_strict(der_private_key)

    expect(der_private_key).to start_with("-----BEGIN RSA PRIVATE KEY-----")
    expect(public_key).to_not start_with("-----BEGIN PUBLIC KEY-----")
  end
end
