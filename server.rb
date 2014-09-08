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
require './model/subscribe.rb'
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
	post = Post.where({author_id: params[:id]})
	# tag = Tag.find_by({id: post.tag_id})
	erb(:author, {locals: {author: author, posts: Post.all(), tags: Tag.all()} })
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
		tag_id: params["tag_id"],
		tag: params["tag"]
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

#duplication of tags#
# t = Post.find_by({tag: params["tag"]})
# 	if t == nil
#     tag_hash = {tag: params["tag"]}
#     t = Tag.new(tag_hash)

# this_tag = Post.find_by({tag: params["tag"]})
# tag_id = this_tag[:id]

	erb(:posts_add, {locals: {authors: Author.all() } })
end
# end



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


post("/tags") do
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end

get("/tags") do
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end

get("/tags/:id") do
	# tag = Tag.find_by("id", params[:id])

	# erb(:tags, { locals: { tag: tag, posts: Post.all() } })
	erb(:tag, { locals: { tag: Tag.all(), posts: Post.all() } })
end

############################################################
#SUBSCRIBE
post '/subscribe_text' do
	number_hash = {
		first_name: params["first_name"],
		last_name: params["last_name"],
		email: params["email"],
  		phone_number: params["phone_number"]
  	}
  s = Subscribe.new(number_hash)
  s.save
	erb(:subscribe)	
redirect '/feed'
end

get("/subscribe_text") do
	erb(:subscribe)	
end
############################################################
# TWILIO MESSAGING

# account_sid = 'AC162b4ab94b6b6e6022465ae7bc35785e'
# auth_token = 'c7a0e35f4bd45b8ff1aa3e400c368493'
# # set up a client to talk to the Twilio REST API
# @client = Twilio::REST::Client.new account_sid, auth_token


# Subscribe.all().each do |x|
# @client.account.messages.create({
# 	:from => '+19732334163', 
# 	:to => x[:phone_number], 
#     :body => " "
#   })
# end

############################################################


