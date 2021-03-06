require './lib/connection.rb'
require './model/author.rb'
require './model/post.rb'
require './model/snippet.rb'
require './model/tag.rb'
require './model/subcriber.rb'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

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
get("/posts") do 
	erb(:posts, {locals: {posts: Post.all()} })
end

#add post content via form
get("/posts/add") do 
	erb(:posts_add, {locals: {posts: Post.all(), authors: Author.all(), tags: Tag.all() } })
end

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
	post = Post.new(post_hash)
	post.save

#SendGrid info here
		subscribers = Subscriber.all()
		title = post_hash[:title]  
		subscribe(subscribers, title)
	erb(:posts, {locals: {posts: Post.all()} })
end
#end

#view specific post with id
get("/posts/:id") do
	post = Post.find_by({id: params[:id]})
	author = Author.find_by({id: post.author_id})
	erb(:post, {locals: {post: post, author: author} })
end

get("/posts/:id/edit") do 
	post = Post.find_by({id: params[:id]})
	author = Author.find_by({id: post.author_id})
	erb(:posts_edit, {locals: {post: post, posts: Post.all(), authors: Author.all()} })
end

put("/posts/:id") do 
	post_hash = {
		title: params["title"],
		post_date: params["post_date"],
		post: params["post"],
		author_id: params["author_id"],
		tag_id: params["tag_id"],
		tag: params["tag"]
	}
	post = Post.find_by({id: params[:id]})
	post.update(post_hash)
	author = Author.find_by({id: post.author_id})
	tag = Tag.find_by(id: params[:id])
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

get("/tags") do 
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })
end


get("/tags/add") do 
	erb(:tags_add, { locals: { tags: Tag.all(), posts: Post.all() } })

end

post("/tags") do 
	tag_hash = {
		tag: params["tag"],
	}

	all_tags = Tag.create(tag_hash)
	all_tags.save
	erb(:tags, { locals: { tag: Tag.all(), posts: Post.all() } })

redirect "/posts/add"
end

get("/tags/:id/posts") do 
	tag = Tag.find_by({id: params[:id]})
	post = Post.where({tag_id: params[:id]})
	erb(:tag, { locals: { tag: Tag.all(), post: post, posts: Post.all() } })
end

get("/tags/:id/edit") do 
	tag = Tag.find_by({id: params[:id]})
	erb(:tags_edit, { locals: { tag: tag } })
end

put("/tags/:id") do 
	tag_hash = {
		tag: params["tag"],
	}

	all_tag = Tag.create(tag_hash)
	all_tags.save
	erb(:tags, { locals: { tag: tag, tags: Tag.all(), posts: Post.all() } })
end	

delete ("/tags/:id") do
	tag = Tag.find_by({id: params[:id]})
	tag.destroy

	redirect "/tags"
end
############################################################
# SUBSCRIBERS/CONFIRMATION PAGE

get ("/subscribe") do
	erb (:subscribe)
end

post("/subscribers") do
	subscribers_hash = {
		name: params["name"],
		email: params["email"]
	}

	all_subscribers = Subscriber.create(subscribers_hash)
	all_subscribers.save

	redirect "/confirmation"
end

get ("/confirmation") do 
	erb(:"subscribers_confirmation")
end
