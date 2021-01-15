# frozen_string_literal: true

describe User do
  describe '.create' do
    it 'wraps user info in a User object' do
      user = User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')

      expect(user.name).to eq('Malachi')
      expect(user.email).to eq('m.spencer@makers.com')
    end
  end

  describe '.find' do
    it 'returns nil if id is given as nil' do
      User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')

      expect(User.find(id: nil)).to be_nil
    end

    it 'retrieves user from db by id' do
      user = User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')
      found_user = User.find(id: user.id)

      expect(found_user.id).to eq(user.id)
      expect(found_user.email).to eq(user.email)
    end
  end

  describe '.authenticate' do
    it 'returns the user given a correct email and password' do
      user = User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')
      authenticated_user = User.authenticate(email: 'm.spencer@makers.com', password: 'p20201124')

      expect(authenticated_user.id).to eq user.id
      expect(authenticated_user.email).to eq user.email
    end

    it 'retusn nil if user enters wrong email' do
      User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')
      authenticated_user = User.authenticate(email: 'a.spencer@makers.com', password: 'p20201124')

      expect(authenticated_user).to eq nil
    end

    it 'retusn nil if user enters wrong password' do
      User.create(name: 'Malachi', email: 'm.spencer@makers.com', password: 'p20201124')
      authenticated_user = User.authenticate(email: 'm.spencer@makers.com', password: 'a20201124')

      expect(authenticated_user).to eq nil
    end
  end
end
