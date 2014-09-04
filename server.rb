require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'active_record'

require './lib/connection.rb'
require './model/author.rb'
require './model/post.rb'
require './model/snippet.rb'
require './model/tag.rb'

############################################################
#ACTIVE RECORD

#closing connection
after do
	ActiveRecord::Base.connection.close
end
############################################################
#INDEX

# index page
get("/") do
	erb(:index)
end
############################################################
#AUTHORS

# view authors sign up page
get("/authors") do
	erb(:authors_add, {locals: {authors: Author.all()} })	
end

#add contributing author
post ("/authors/add") do
	author_hash = {username: params["username"], email: params["email"]}
	a = Author.new(author_hash)
	a.save

erb(:authors)
end

#view specific author with id
get("/authors/:id") do

end

############################################################
#POSTS

#view posts
get("/posts") do
	erb(:posts)
end

#add post
get("/posts/add") do
	erb(:posts_add)
end

#view specific post with id
get("/posts/:name/:id") do

end

post("/posts") do
end

############################################################
#TAG

#view search tag page
get("/tag") do
 
end

get("/tag/:id") do

end




