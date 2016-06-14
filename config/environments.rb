configure :development, :test do
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "db/auther.sqlite3"
  )
end
