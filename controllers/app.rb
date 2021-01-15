# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require 'pg'
require_relative '../lib/database_connection'
require_relative './bookings_controller'
require_relative './spaces_controller'
require_relative './users_controller'
require_relative './server'
require_relative '../lib/user'
require_relative '../database_connection_setup'
require_relative '../lib/booking'
