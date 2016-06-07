require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to :user }
  it { is_expected.to callback(:generate_private_key).before(:save) }
end
