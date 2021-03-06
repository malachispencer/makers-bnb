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
    it 'returns all spaces that are not booked on a specified date' do
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

      expect(results.length).to eq(1)
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

  describe '.all_by_user_id' do
    it 'returns all spaces listed by a user' do
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
        user_id: host.id
      )

      spaces = Space.all_by_user_id(user_id: host.id)

      expect(spaces.length).to eq(2)
      expect(spaces[0].name).to eq('Richmond House')
      expect(spaces[1].name).to eq('Ealing Flat')
    end
  end

  describe '.update' do
    it 'updates the details of a space' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      edited_space = Space.update(
        space_id: space.id,
        name: 'Stylish Ealing Apartment',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 175
      )

      expect(edited_space.id).to eq(space.id)
      expect(edited_space.name).to eq('Stylish Ealing Apartment')
      expect(edited_space.price).to eq(175)
    end

    it 'handles strings with apostrophes' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      edited_space = Space.update(
        space_id: space.id,
        name: "Malachi's Ealing Offering",
        description: "Studio apartment in London's best borough",
        location: 'Ealing, London, UK',
        price: 175
      )

      expect(edited_space.name).to eq("Malachi's Ealing Offering")
    end

    it 'handles strings with double quotes' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      edited_space = Space.update(
        space_id: space.id,
        name: '"Special" Flat in Ealing',
        description: 'Studio apartment in the "best" borough of London',
        location: 'Ealing, London, UK',
        price: 175
      )
      
      expect(edited_space.name).to eq('"Special" Flat in Ealing')
    end
  end

  describe '.delete' do
    it 'removes a Space from the database' do
      space = Space.create(
        name: 'Ealing Flat',
        description: 'Studio apartment',
        location: 'Ealing, London, UK',
        price: 150,
        user_id: host.id
      )

      Space.delete(space_id: space.id)

      db_response = DatabaseConnection.query(
        "SELECT * FROM spaces WHERE id = '#{space.id}';"
      ).first

      expect(db_response).to be_nil
    end
  end
end