describe Space do
  let(:guest) { 
    User.create(
      name: 'Malachi',
      email: 'm.spencer@makers.com',
      password: '2020'
    )
  }

  let(:host) { 
    User.create(
      name: 'ai',
      email: 'ai@makers.com',
      password: '2020'
    )
  }

  let(:today) { Date.today.to_s }

  describe '.create' do
    it 'adds space to database and returns that space' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      expect(space.name).to eq('Ealing Flat')
      expect(space.user_id).to eq(host.id)
    end
  end

  describe '.all' do
    it 'returns all spaces from the database' do
      Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      Space.create(
        name: 'Richmond House',
        description: 'Marvellous 4 bedroom home',
        location: 'Richmond, London, UK',
        price: 300,
        user_id: guest.id
      )

      results = Space.all
      
      expect(results[0][:space].name).to eq('Richmond House')
      expect(results[0][:host_name]).to eq('Malachi')
      expect(results[1][:space].name).to eq('Ealing Flat')
      expect(results[1][:host_name]).to eq('ai')
    end
  end

  describe '.retrieve_available' do
    it 'returns all listings that are not booked on a specified date' do
      booked_space = Space.create(
        description: 'A luxurious villa in Beverly Hills', 
        name: 'Hidden Gem of Beverly Hills',
        location: 'Los Angeles, Beverly Hills', 
        price: 300, 
        user_id: host.id
      )

      Booking.create(
        check_in: today,
        booked: true, 
        space_id: booked_space.id, 
        user_id: guest.id
      )

      not_booked_space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      results = Space.retrieve_available(user_id: guest.id, date: today)

      expect(results[0][:space].name).to eq('Ealing Flat')
      expect(results[0][:host_name]).to eq('ai')
    end

    it 'does not return space user has already requested on date' do
      requested_space = Space.create(
        name: 'Richmond House',
        description: 'Marvellous 4 bedroom home',
        location: 'Richmond, London, UK',
        price: 300,
        user_id: host.id
      )

      Booking.create(
        check_in: today,
        booked: false, 
        space_id: requested_space.id, 
        user_id: guest.id
      )

      not_requested_space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      results = Space.retrieve_available(user_id: guest.id, date: today)

      expect(results.length).to eq(1)
      expect(results[0][:space].name).to eq(not_requested_space.name)
      expect(results[0][:host_name]).to eq(host.name)
    end
  end

  describe '.find_by_id' do
    it 'returns a given space by id' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      found_space = Space.find_by_id(id: space.id)

      expect(found_space.name).to eq(space.name)
      expect(found_space.id).to eq(space.id)
    end
  end
end
