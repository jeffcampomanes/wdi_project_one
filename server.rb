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
# require './model/subscriber.rb'
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

#view authors on viewing page with list of authors
get("/authors") do
	erb(:authors, {locals: {authors: Author.all()} })	
end

#adding authors via form
get("/authors/add") do
	erb(:authors_add, {locals: {authors: Author.all()} })
end

#add authors to server
post("/authors") do

	author_hash = {
		username: params["username"], 
		email: params["email"]
	}
	a = Author.new(author_hash)
	a.save
	erb(:authors, {locals: {authors: Author.all()} })
end

#view specific author with id
get("/authors/:id") do 
	author = Author.find_by({id: params[:id]})
	post = Post.where({author_id: params[:id]})
	erb(:author, {locals: {author: author, posts: post, tags: Tag.all()} })
end

############################################################
#POSTS

#view posts on viewing page with list of posts
get("/posts") do #INDEX
	erb(:posts, {locals: {posts: Post.all()} })
end

#add post content via form
get("/posts/add") do #NEW
	erb(:posts_add, {locals: {posts: Post.all(), authors: Author.all(), tags: Tag.all() } })
end

#adding posts to server
post("/posts") do  #NEW
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

# SendGrid info here
		# subscribers = Subscriber.all()
		# title = posts_hash[:title]  
		# subscribe(subscribers, title)
	erb(:posts, {locals: {posts: Post.all()} })
end
#end

#view specific post with id
get("/posts/:id") do #SHOW
	post = Post.find_by({id: params[:id]})
	author = Author.find_by({id: post.author_id})
	erb(:post, {locals: {post: post, author: author} })
end

get("/posts/:id/edit") do #EDIT
	post = Post.find_by({id: params[:id]})
	author = Author.find_by({id: post.author_id})
	erb(:posts_edit, {locals: {post: post, posts: Post.all(), authors: Author.all()} })
end

put("/posts/:id/edit") do #SHOW
	post_hash = {
		title: params["title"],
		post_date: params["post_date"],
		post: params["post"],
		author_id: params["author_id"],
		tag_id: params["tag_id"],
		tag: params["tag"]
	}
	p = Post.find_by({id: params[:id]})
	p.update(post_hash)

	erb(:post, { locals: { post: post, author: author} })
end

delete("/posts/:id") do
  post = Post.find_by({id: params[:id]})
  post.destroy

  redirect "/posts" 
end

############################################################
#FEED (see all posts)

get("/feed") do
	erb(:feed, {locals: {posts: Post.all()} })
end
############################################################
#TAG

get("/tags") do #index
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end


get("/tags/add") do #new tags
	erb(:tags_add, { locals: { tags: Tag.all(), posts: Post.all() } })
end


post("/tags") do #index
	tags_hash = {
		tag: params["tag"],
	}

	all_tags = Tag.create(tags_hash)
	all_tags.save
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end


get("/tags/:id") do #show
	tag = Tag.find_by({id: params[:id]})
	post = Post.where({tag_id: params[:id]})
	erb(:tag, { locals: { tag: Tag.all(), post: post, posts: Post.all() } })
end

# Edit tag form
get("/tags/:id/edit") do #edit
	tag = Tag.find_by({id: params[:id]})
	erb(:tags_edit, { locals: { tag: tag } })
end

# Captures edited tag name and sends user to list of tags
put("/tags/:id") do #show
	tags_hash = {
		tag: params["tag"],
	}

	all_tags = Tag.create(tags_hash)
	all_tags.save
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end	

# Deletes tag and redirects user to list of tags
delete ("/tags/:id") do
	tag = Tag.find_by({id: params[:id]})
	tag.destroy

	redirect "/tags"
end

############################################################
# SUBSCRIBERS/CONFIRMATION PAGE

#WAITING FOR THE API KEY FROM SENDGRID#

get ("/subscribe") do ##working
	erb (:subscribe)
end

# # Captures new subscriber data into hash, sends user back to confirmation page

# post("/subscribers") do
# 	subscribers_hash = {
# 		name: params["name"],
# 		email: params["email"]
# 	}

# 	all_subscribers = Subscriber.create(subscribers_hash)
# 	all_subscribers.save

# 	redirect "/confirmation"
# end

# get ("/confirmation") do ##working
# 	erb(:"subscribers_confirmation")
# end


