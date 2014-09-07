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
require 'rubygems' 
require 'twilio-ruby'
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

#add authors to server
post('/authors') do

	author_hash = {
		username: params["username"], 
		email: params["email"]
	}
	a = Author.new(author_hash)
	a.save
	erb(:authors, {locals: {authors: Author.all()} })
end

#view authors on viewing page with list of authors
get("/authors") do
	erb(:authors, {locals: {authors: Author.all()} })	
end

#adding authors via form
get("/authors/add") do
	erb(:authors_add, {locals: {authors: Author.all()} })
end

#view specific author with id
get("/authors/:id") do 
	author = Author.find_by({id: params[:id]})
	post = Post.find_by({id: params[:id]})
	erb(:author, {locals: {author: author, posts: Post.all()} })
end

############################################################
#POSTS

#adding posts to server
post("/posts") do 
	post_hash = {
		title: params["title"],
		post_date: params["post_date"],
		post: params["post"],
		author_id: params["author_id"],
		tag: params["tag"],
	}
	p = Post.new(post_hash)
	p.save
	erb(:posts, {locals: {posts: Post.all()} })
end

#view posts on viewing page with list of posts
get("/posts") do
	erb(:posts, {locals: {posts: Post.all()} })
end

#add post content via form
get("/posts/add") do
	erb(:posts_add, {locals: {authors: Author.all() } })
end

#view specific post with id
get("/posts/:id") do
	post = Post.find_by({id: params[:id]})
	author = Author.find_by({id: post.author_id})
	erb(:post, {locals: {post: post, author: author} })
end

############################################################
#FEED (see all posts)

get("/feed") do
	erb(:feed, {locals: {posts: Post.all()} })
end
############################################################
#TAG

## tags will show in inspector but won't show on page. they are added to database. when searching for tag, it will be added to database instead of searched upon. ##
post("/tags") do
	tags_hash = {
		tag: params["tag"]
	} 
	Tag.create(tags_hash)

	erb(:tags, { locals: { tag: Tag.all() } })
end

get("/tags") do
	erb(:tags, { locals: { tag: Tag.all() } })
end

get("/tags/:id/posts") do
	tag = Tag.find_by("id", params[:id])

	erb(:tags, { locals: { tag: tag } })
end
############################################################
# TWILIO MESSAGING

account_sid = 'AC162b4ab94b6b6e6022465ae7bc35785e'
# auth_token = 'c7a0e35f4bd45b8ff1aa3e400c368493'

# # set up a client to talk to the Twilio REST API
# @client = Twilio::REST::Client.new account_sid, auth_token

# @client.account.messages.create(
# 	:from => '+19732334163', 
# 	:to => '+18625967865', 
# 	:body => 'Hey there!'
# 	)

