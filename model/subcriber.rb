require 'active_record'

class Subscriber < ActiveRecord::Base

  end

def subscribe (subscribers, title)
  subscribers.each do |subscriber|
  response = HTTParty.post "https://sendgrid.com/api/mail.send.json", 
    :body => {
    "api_user" => "jeffcampo",
    "api_key" => "#komodo112",
    "to" => "#{subscriber.email}",
    "toname"=> "#{subscriber.name}",
    "from" => "jeffcampomanesme.com",
    "subject" => " '#threetothedome!' ",
    "text" => "Hi #{subscriber.name}! Here's a new blog post for you to enjoy on #threetothedome: '#{title}.'"
        };
  	end
end