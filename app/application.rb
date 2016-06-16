require 'sinatra' 
require 'sinatra/activerecord'
require './config/environments'
Dir["./app/models/*"].each {|file| require file }
set :public_folder, 'public'

set :database_file, "../config/database.yml"

get '/users' do
  return User.all.to_json
end

# TODO: Secure, salt, hash etc the password
# For creating users in the system
# POST users#create
# Params:
#   name: (optional) Friendly name of the user
#   username: self explanatory
#   password: self explanatory
#   client_key: the key for the client to auth against
post '/users' do
  begin
    @client = Client.find_by!(key: params[:client_key])
    @user = User.new(name: params[:name], username: params[:username], password: params[:password], client_id: @client.id)
    
    if @user.save
      return 201
    else
      return [422, { errors: @user.errors }.to_json]
    end
  rescue ActiveRecord::RecordNotFound
    return [400, { errors: "Could not find client" }.to_json]
  end
end

# For registering a new client in the system
# POST clients#create
post '/clients' do
  @client = Client.new(name: params[:name])

  if @client.save
    return [201, @client.to_json]
  else
    return [422, { errors: @client.errors }.to_json]
  end
end

# GET clients#index
get '/clients' do
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
      s = Session.first_or_create(user_id: u.id)
    when 'refresh_token'
      s = Session.find_by!(refresh_token: params[:refresh_token])
    else
      return [400, { error: "invalid_grant" }.to_json]
    end
    s.refresh!
    return [200, {
      access_token: s.token,
      refresh_token: s.refresh_token,
      token_type: "example",
      expires_in: (s.expires_at - Time.now).to_i
    }.to_json]
  # When an auth record is not found in this context, they are not authorized
  rescue ActiveRecord::RecordNotFound => ex
    return [400, { error: "invalid_client" }.to_json]
  end
end
