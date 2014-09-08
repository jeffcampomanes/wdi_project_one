require 'active_record'

class Subscriber < ActiveRecord::Base

  end

def subscribe (subscribers, title)
  subscribers.each do |subscriber|
  response = HTTParty.post "https://sendgrid.com/api/mail.send.json", 
    :body => {
    "api_user" => "jeffcampomanes",
    "api_key" => "#WAITING FOR API KEY",
    "to" => "#{subscriber.email}",
    "toname"=> "#{subscriber.name}",
    "from" => "jeffcampomanes@gmail.com,
    "subject" => " '#threetothedome!' ",
    "text" => "Hi #{subscriber.name}! Here's a new blog post for you to enjoy on '#threetothedome': '#{title}.' Check it out!"
      	};
  	end
end