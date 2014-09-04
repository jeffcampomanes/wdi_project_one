## Microblog

---

A microblog allows users to create, devour, update, and delete miniature blog posts. You will be creating a team microblog, which allows a group of users to create posts on a shared feed. These posts can reference outside links and scrape useful information from them (like texts and images), and add novel commentary, like "LOLZ" or "haters gonna hate".


###***MVP***
- **Data Model**:
  - `micro_post`
  - `author`
  - `snippet`
  - `tag`
- **Required technologies or features**:
  - [Twilio](https://www.twilio.com/docs/api)
    - Allows an application to send text messages to any phone number
  - [SendGrid](https://sendgrid.com/docs/index.html)
    - Allows an application to send emails
- **Examples Idea**:
  - A sports team blog or general sports blog
- **User Stories (MVP)**:
  - A user can create a new `micro_post`
  - A user can add an `author` to a `micro_post` when creating it
  - A user can show (ie, see) a given `micro_post`
  - A user can see all of the `micro_post`s as a *feed* (`/feed`)
  - A user can add a link to a `micro_post` as a `snippet`
    - A snippet is similar to how Facebook handles links. When you paste a link to an article on Facebook, it shows you some limited information about it, but clicking it will take you to the full article.
  - A user can add a "topic" or "hashtag" to a `micro_post` as a `tag`
    - This should be optional to do and the choice of `tag` is up to the user. Not having a `tag` for the `post` should NOT break the application
    - `tag`s can be edited and deleted
  - When a user creates a `micro_post` they can create a new author or choose a pre-existing one from a drop-down menu
  - A user can view an `author`'s page that lists the `micro_post`s that they have created or edited
  - A user will receive an email or text message when a new `micro_post` is created
    - This text message or email should at least contain the title of the new `micro_post`
  - A user can view `micro_post`s posts by author (`authors/authorhandle/posts`)
  - A user can view `micro_post`s posts by tag (`tag/tagname/posts`)

---

###***Bonus***

- **Further User Stories**:
  - A user can reference an existing `micro_post` in a new `micro_post` (ie, *reblog* it)...
  - A user can identify a referenced `micro_post` in a reblog as a separate snippet...
  - A user can write a post that is "sticky" (stays at the top of the feed, or after a previously stuck post) and has a "life" (in seconds, the time until it becomes "unstuck") of up to two weeks...
- **Incorporate Bundler and a Gemfile into your application**
    - [Bundler Website](http://bundler.io/)
    - [Why use Bundler?](http://bundler.io/rationale.html)
    - [What is a Gemfile?](http://bundler.io/v1.3/gemfile.html)
    - [Sinatra docs for Bundler and Gemfiles](http://recipes.sinatrarb.com/p/development/bundler)
- **JSON Activity Streams and/or Request Response**
  - [Activity Streams](http://en.wikipedia.org/wiki/Activity_Streams_(format)) are complex feeds that explain what is happenning on your site. Your AS feed would be served from the endpoint `/as` and would record all the posting activity on the blog. This sort of feed could be generated using a gem, [for example](https://github.com/nov/activitystreams)
  - Alternatively, you can offer up a JSON representation of a single post at the endpoint `/as/post-id` -- a much simpler option.
  - Or you can do both!
  - To get Sinatra to form responses in JSON format rather than HTML, check out this [tutorial](http://nathanhoad.net/how-to-return-json-from-sinatra)
- **Additional API**
  - When viewing a `micro_post` that has a `tag`, also display content from one of the below APIs that has the same `tag` (hashtag)
    - [Twitter](https://dev.twitter.com/docs/api)
    - [Instagram](http://instagram.com/developer/)
    - [Tumblr](http://www.tumblr.com/docs/en/api/v2)
- **Implement responsive web design to your application**
  - [What the heck is responsive web design?](http://johnpolacek.github.io/scrolldeck.js/decks/responsive/)

---
