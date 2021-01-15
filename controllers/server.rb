# frozen_string_literal: true

require_relative '../lib/user'

class MakersBnB < Sinatra::Base
  enable :sessions, :method_override
  set :views, File.expand_path('../views', __dir__)
  set :public_folder, File.expand_path('../public', __dir__)
  register Sinatra::Flash

  get '/' do
    @user = User.find(id: session[:user_id])

    if @user
      redirect '/dashboard'
    else
      erb(:index)
    end
  end

  get '/dashboard' do
    @user = User.find(id: session[:user_id])
    @date = session[:check_in_date]
    erb(:dashboard)
  end
end
