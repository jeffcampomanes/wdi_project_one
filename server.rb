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
#TAG

get '/tags' do 
  list_tags = Tag.all()
  erb(:tags, {locals: {list_tags: list_tags}})
end

get '/tags/:id' do 
  this_tag = Tag.find_by({id: params[:id]}) 
  list_posts = Post.all()
  list_authors = Author.all()
  erb(:tag, {locals: {this_tag: this_tag, list_posts: list_posts, list_authors: list_authors}})
end
############################################################
#TWILIO MESSAGING

account_sid = 'AC162b4ab94b6b6e6022465ae7bc35785e'
auth_token = 'c7a0e35f4bd45b8ff1aa3e400c368493'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

@client.account.messages.create(
	:from => '+19732334163', 
	:to => '+18625967865', 
	:body => 'Hey there!')

