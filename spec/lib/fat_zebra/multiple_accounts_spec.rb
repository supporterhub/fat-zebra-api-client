require 'spec_helper'

describe 'Multiple accounts', :vcr, :no_default_account do

  describe 'The basics' do
    it { expect(FatZebra.configurations).to be_nil }

    let(:purchase_0) { FatZebra::Purchase.create valid_purchase_payload }

    it { expect { purchase_0 }.to raise_error(FatZebra::ConfigurationError, 'No account specified') }

    let(:account_1) {
      FatZebra::Config.new(
        username:  'TEST_USERNAME_1',
        token:     'TEST_TOKEN_1',
        gateway:   :sandbox,
        test_mode: true
      )
    }
    let(:account_2) {
      FatZebra::Config.new(
        username:  'TEST_USERNAME_2',
        token:     'TEST_TOKEN_2',
        gateway:   :sandbox,
        test_mode: true
      )
    }

    it { expect(account_1.valid!).to be_truthy }
    it { expect(account_2.valid!).to be_truthy }

    let(:purchase_1) { FatZebra::Purchase.create valid_purchase_payload, account: account_1 }

    let(:purchase_2) { FatZebra::Purchase.create valid_purchase_payload, account: account_2 }

    it {
      expect(purchase_1.accepted?).to be_truthy
      expect(purchase_1.id).to eq('071-P-ACCOUNT-1')
    }

    it {
      expect(purchase_2.accepted?).to be_truthy
      expect(purchase_2.id).to eq('071-P-ACCOUNT-2')
    }
  end

  describe 'Conflicting accounts' do
    it {
      expect(FatZebra.configurations).to be_nil

      FatZebra.configure do |config|
        config.username  = 'TEST_USERNAME_1'
        config.token     = 'TEST_TOKEN_1'
        config.gateway   = :sandbox
        config.test_mode = true
      end

      account = FatZebra::Config.new(
        username:  'TEST_USERNAME_2',
        token:     'TEST_TOKEN_2',
        gateway:   :sandbox,
        test_mode: true
      )

      expect { FatZebra::Purchase.create valid_purchase_payload, account: account }.to raise_error(FatZebra::ConfigurationError, 'Ambiguous accounts specified')
    }
  end

end
