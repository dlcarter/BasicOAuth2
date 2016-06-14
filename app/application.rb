require 'sinatra' 
require 'sinatra/activerecord'
require './config/environments'
Dir["./app/models/*"].each {|file| require file }

get '/' do
  return "Why hello there"
end

get '/users' do
  return User.all.to_json
end

# TODO: Secure, salt, hash etc the password
post '/users.json' do
  @user = User.new(name: params[:name], username: params[:username], password: params[:password])
  
  if @user.save
    return 201
  else
    return [422, { errors: @user.errors }.to_json]
  end
end

# For registering a new client in the system
# POST clients#create
post '/clients' do
  @client = Client.new(name: params[:name])

  if @client.save
    return 201
  else
    return [422, { errors: @client.errors }.to_json]
  end
end

# GET clients#index
get '/clients.json' do
  return Client.all.to_json
end

# POST token
# Params:
#   grant_type: currently supports only 'password' or 'refresh_token'
#   username: (password grant_type only) username to authenticate
#   password: (password grant_type only) password to authenticate
#   refresh_token: (refresh_token grant_type only) auth token to refresh
post '/token' do
  begin
    case params[:grant_type].downcase
    when 'password'
      u = User.find_by!(username: params[:username], password: params[:password])
      s = Session.first_or_create(username: u.username)
      s.generate_token!
      return [200, s.token]
    when 'refresh_token'
      s = Session.find(token: params[:token])
      s.generate_token!
      return [200, s.token]
    else
      return [422, { errors: "Must request a valid grant type" }]
    end
  # When an auth record is not found in this context, they are not authorized
  rescue ActiveRecord::RecordNotFound => ex
    raise ex
    return 401
  end
end