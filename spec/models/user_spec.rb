require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new(email: "test@test.com", password: "password") }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest).with_message('Password can\'t be blank') }
  it { should validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  it 'creates a password digest when a password is given' do
    expect(user.password_digest).to_not be_nil
  end

  it 'creates a session token before validation' do
    user.valid?
    expect(user.session_token).to_not be_nil
  end

  describe 'User#is_password?' do
    let(:wrong_pass) { "wrong_pass" }
    let(:right_pass) { "password" }

    it 'verifies a password is not correct' do
      expect(user.is_password?(wrong_pass)).to be false
    end

    it 'verifies a password is correct' do
      expect(user.is_password?(right_pass)).to be true
    end
  end

  describe 'User#reset_token!' do
    it 'sets a new session token on the user' do
      user.valid?
      old_session_token = user.session_token
      user.reset_token!("session_token")
      expect(user.session_token).not_to eq(old_session_token)
    end

    it 'returns the session token' do
      expect(user.reset_token!("session_token")).to eq(user.session_token)
    end
  end

  describe 'User::find_by_crendtials' do
    before { user.save! }
      
    it 'returns nil given bad credentials' do
      expect(User.find_by_credentials('nouser@.com', 'pasword')).to be_nil
      expect(User.find_by_credentials('test@test.com', 'wrong')).to be_nil
    end

    it 'returns user given good credentials' do
      expect(User.find_by_credentials('test@test.com', 'password')).to be_a(User)
    end
  end
end
