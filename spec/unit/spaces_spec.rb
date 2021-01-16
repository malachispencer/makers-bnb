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
    xit 'inserts its arguments into the spaces table' do
      result = Space.create(description: 'A luxurious villa in Beverly Hills', name: 'Hidden Gem of Beverly Hills',
                            location: 'Los Angeles, Beverly Hills', price: 300, user_id: test_user.id)
      expect(result).to be_instance_of(described_class)
      expect(result.name).to eq('Hidden Gem of Beverly Hills')
      expect(result.description).to eq('A luxurious villa in Beverly Hills')
      expect(result.location).to eq('Los Angeles, Beverly Hills')
      expect(result.price).to eq(300)
      expect(result.user_id).to eq(test_user.id)
    end
  end

  describe '.retrieve_available' do
    it 'returns all spaces from database if no date given' do
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

      results = Space.retrieve_available(
        user_id: guest.id,
        date: nil
      )

      expect(results[0][:space].name).to eq('Ealing Flat')
      expect(results[0][:host_name]).to eq('ai')
      expect(results[1][:space].name).to eq('Richmond House')
      expect(results[1][:host_name]).to eq('Malachi')
    end

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
  end

  describe '.find_by_id' do
    xit 'returns a given space by id' do
      space = Space.create(
        description: 'A luxurious villa in Beverly Hills',
        name: 'Hidden Gem of Beverly Hills',
        location: 'Los Angeles, Beverly Hills',
        price: 300,
        user_id: test_user.id
      )
      found_space = Space.find_by_id(id: space.id)
      expect(found_space.id).to eq(space.id)
    end
  end
end
