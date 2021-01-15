describe User do
  describe '.create' do
    it 'wraps user info in a User object' do
      user = User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      expect(user.name).to eq('Malachi')
      expect(user.email).to eq('m.spencer@makers.com')
    end
  end

  describe '.find' do
    it 'returns nil if id is given as nil' do
      expect(User.find(id: nil)).to be_nil
    end

    it 'retrieves user from db by id' do
      user = User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      found_user = User.find(id: user.id)

      expect(found_user.id).to eq(user.id)
      expect(found_user.email).to eq(user.email)
    end
  end

  describe '.authenticate' do
    it 'returns the user given a correct email and password' do
      user = User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      authenticated_user = User.authenticate(
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      expect(authenticated_user.id).to eq(user.id)
      expect(authenticated_user.email).to eq(user.email)
    end

    it 'retusn nil if user enters wrong email' do
      User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      authenticated_user = User.authenticate(
        email: 'm.spencer@codeworks.com', 
        password: '2020'
      )

      expect(authenticated_user).to be_nil
    end

    it 'retusn nil if user enters wrong password' do
      User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      authenticated_user = User.authenticate(
        email: 'm.spencer@makers.com', 
        password: 'wrong_password'
      )

      expect(authenticated_user).to be_nil
    end
  end

  describe '.find_by_email' do
    it 'returns nil if no user with this email exists' do
      found_user = User.find_by_email(email: 'm.spencer@codeworks.com')

      expect(found_user).to be_nil
    end

    it 'returns user if user found' do
      User.create(
        name: 'Malachi', 
        email: 'm.spencer@makers.com', 
        password: '2020'
      )

      found_user = User.find_by_email(email: 'm.spencer@makers.com')

      expect(found_user.name).to eq('Malachi')
      expect(found_user.email).to eq('m.spencer@makers.com')
    end
  end
end
