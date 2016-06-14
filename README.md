# BasicOAuth2
A simple sinatra app to solve a programming challenge to implement a slice of the OAuth2 spec

Only requirements are a working Ruby installation

## How to get started

1. `bundle install`
2. `ruby app/application.rb`

## Running the tests

`ruby test/auther.rb`

## Providing sample data and testing the API by hand

Easiest way is to use curl.

#### Step 1: Create a client:
`curl -d "name=CLIENTNAME" http://localhost:4567/clients`

(Take note of the client key we got back)

#### Step 2: Create a user:
`curl -d "name=FRIENDLYNAME&username=USERNAME&password=PASSWORD&client_key=CLIENT_KEY" http://localhost:4567/users`

#### Step 3: Authenticate the user:
`curl -d "username=USERNAME&password=PASSWORD&grant_type=password" http://localhost:4567/token`

(Take note of the refresh token we get back)

#### Step 4: Refresh authentication with the refresh token
`curl -d "grant_type=refresh_token&refresh_token=REFRESH_TOKEN" http://localhost:4567/token`
