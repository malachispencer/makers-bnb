# frozen_string_literal: true

def setup_test_database
  connection = PG.connect(dbname: 'makers_bnb_test')
  connection.exec('TRUNCATE users, spaces, bookings;')
end
