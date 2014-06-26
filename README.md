Yt - a Ruby client for the YouTube API
======================================================

Yt helps you write apps that need to interact with YouTube.

The **full documentation** is available at [rubydoc.info](http://rubydoc.info/github/Fullscreen/yt/master/frames).

[![Build Status](http://img.shields.io/travis/Fullscreen/yt/master.svg)](https://travis-ci.org/Fullscreen/yt)
[![Coverage Status](http://img.shields.io/coveralls/Fullscreen/yt/master.svg)](https://coveralls.io/r/Fullscreen/yt)
[![Dependency Status](http://img.shields.io/gemnasium/Fullscreen/yt.svg)](https://gemnasium.com/Fullscreen/yt)
[![Code Climate](http://img.shields.io/codeclimate/github/Fullscreen/yt.svg)](https://codeclimate.com/github/Fullscreen/yt)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://rubydoc.info/github/Fullscreen/yt/master/frames)
[![Gem Version](http://img.shields.io/gem/v/yt.svg)](http://rubygems.org/gems/yt)

After [registering your app](#configuring-your-app), you can run commands like:

```ruby
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow'
channel.title #=> "Fullscreen"
channel.public? #=> true
channel.comment_count #=> 773
channel.videos.count #=> 12
```

```ruby
video = Yt::Video.new id: 'MESycYJytkU'
video.title #=> "Fullscreen Creator Platform"
video.comment_count #=> 308
video.hd? #=> true
video.annotations.count #=> 1
```

The **full documentation** is available at [rubydoc.info](http://rubydoc.info/github/Fullscreen/yt/master/frames).

Available resources
===================

Yt::Account
-----------

Use [Yt::Account](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Account) to:

* authenticate as a YouTube account
* read the attributes of the account
* access the channel managed by the account
* access the videos uploaded by the account

```ruby
# Accounts can be initialized with access token, refresh token or an authorization code
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'

account.email #=> .. your e-mail address..
account.channel #=> #<Yt::Models::Channel @id=...>

account.videos.count #=> 12
account.videos.first #=> #<Yt::Models::Video @id=...>
```

*All the above methods require authentication (see below).*

Yt::ContentOwner
----------------

Use [Yt::ContentOwner](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/ContentOwner) to:

* authenticate as a YouTube content owner
* list the channels partnered with a YouTube content owner

```ruby
# Content owners can be initialized with access token, refresh token or an authorization code
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'

content_owner.partnered_channels.count #=> 12
content_owner.partnered_channels.first #=> #<Yt::Models::Channel @id=...>
```

*All the above methods require authentication (see below).*

Yt::Channel
-----------

Use [Yt::Channel](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Channel) to:

* read the attributes of a channel
* access the videos of a channel
* access the playlists of a channel
* subscribe to and unsubscribe from a channel
* create and delete playlists from a channel
* retrieve the daily earnings, views, comments, likes, dislikes, shares and impressions of a channel

```ruby
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow'

channel.title #=> "Fullscreen"
channel.description #=> "The first media company for the connected generation."
channel.description.has_link_to_playlist? #=> false
channel.thumbnail_url #=> "https://yt3.ggpht.com/-KMnbKDBl60w/.../photo.jpg"
channel.published_at #=> 2006-03-23 06:13:25 UTC
channel.public? #=> true

channel.view_count #=> 421619
channel.comment_count #=> 773
channel.video_count #=> 12
channel.subscriber_count #=> 136925
channel.subscriber_count_visible? #=> true

channel.videos.count #=> 12
channel.videos.first #=> #<Yt::Models::Video @id=...>

channel.playlists.count #=> 2
channel.playlists.first #=> #<Yt::Models::Playlist @id=...>
```

*The methods above do not require authentication.*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: account

channel.subscribed? #=> false
channel.subscribe #=> true

channel.create_playlist title: 'New playlist' #=> true
channel.delete_playlists title: 'New playlist' #=> [true]

channel.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}
channel.comments until: 2.days.ago #=> {Wed, 28 May 2014 => 9.0, Thu, 29 May 2014 => 4.0, …}
channel.likes from: 8.days.ago #=> {Tue, 27 May 2014 => 7.0, Wed, 28 May 2014 => 0.0, …}
channel.dislikes to: 2.days.ago #=> {Tue, 27 May 2014 => 0.0, Wed, 28 May 2014 => 1.0, …}
channel.shares since: 7.days.ago, until: 7.days.ago  #=> {Wed, 28 May 2014 => 3.0}
```

*The methods above require to be authenticated as a YouTube account (see below).*

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: content_owner

channel.earnings_on 5.days.ago #=> 12.23
channel.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}
channel.comments until: 2.days.ago #=> {Wed, 28 May 2014 => 9.0, Thu, 29 May 2014 => 4.0, …}
channel.likes from: 8.days.ago #=> {Tue, 27 May 2014 => 7.0, Wed, 28 May 2014 => 0.0, …}
channel.dislikes to: 2.days.ago #=> {Tue, 27 May 2014 => 0.0, Wed, 28 May 2014 => 1.0, …}
channel.shares since: 7.days.ago, until: 7.days.ago  #=> {Wed, 28 May 2014 => 3.0}
channel.impressions_on 5.days.ago #=> 157.0
```

*The methods above require to be authenticated as the channel’s content owner (see below).*

Yt::Video
-----------

Use [Yt::Video](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Video) to:

* read the attributes of a video
* update the attributes of a video
* access the annotations of a video
* like and dislike a video

```ruby
video = Yt::Video.new id: 'MESycYJytkU'

video.title #=> "Fullscreen Creator Platform"
video.description #=> "The new Fullscreen Creator Platform gives creators and brands a suite..."
video.description.has_link_to_channel? #=> true
video.thumbnail_url #=> "https://i1.ytimg.com/vi/MESycYJytkU/default.jpg"
video.published_at #=> 2013-07-09 16:27:32 UTC
video.public? #=> true
video.tags #=> []
video.channel_id #=> "UCxO1tY8h1AhOz0T4ENwmpow"
video.channel_title #=> "Fullscreen"
video.category_id #=> "22"
video.live_broadcast_content #=> "none"

video.duration #=> 86
video.hd? #=> true
video.stereoscopic? #=> false
video.captioned? #=> true
video.licensed? #=> false

video.annotations.count #=> 1
video.annotations.first #=> #<Yt::Models::Annotation @id=...>
```

*The methods above do not require authentication.*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
video = Yt::Video.new id: 'MESycYJytkU', auth: account

video.liked? #=> false
video.like #=> true
```

*The methods above require to be authenticated as a YouTube account (see below).*

```ruby
video.update title: 'A title', description: 'A description', tags: ['a tag'], categoryId: '21'
```

*The methods above require to be authenticated as the video’s owner (see below).*

Yt::Playlist
------------

Use [Yt::Playlist](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Playlist) to:

* read the attributes of a playlist
* update the attributes of a playlist
* access the items of a playlist
* add one or multiple videos to a playlist
* delete items from a playlist

```ruby
playlist = Yt::Playlist.new id: 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc'

playlist.title #=> "Fullscreen Features"
playlist.description #=> "You send us your best videos and we feature our favorite ones..."
playlist.description.has_link_to_subscribe? #=> false
playlist.thumbnail_url #=> "https://i1.ytimg.com/vi/36kL2alg7Jk/default.jpg"
playlist.published_at #=> 2012-11-27 21:23:38 UTC
playlist.public? #=> true
playlist.tags #=> []
playlist.channel_id #=> "UCxO1tY8h1AhOz0T4ENwmpow"
playlist.channel_title #=> "Fullscreen"

playlist.playlist_items.count #=> 1
playlist.playlist_items.first #=> #<Yt::Models::PlaylistItem @id=...>
```

*The methods above do not require authentication.*

```ruby
playlist.update title: 'title', description: 'desc', tags: ['new tag'], privacy_status: 'private'
playlist.add_video 'MESycYJytkU'
playlist.add_videos ['MESycYJytkU', 'MESycYJytkU']
playlist.delete_playlist_items title: 'Fullscreen Creator Platform' #=> [true]
```

*The methods above require to be authenticated as the playlist’s owner (see below).*

Yt::PlaylistItem
----------------

Use [Yt::PlaylistItem](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/PlaylistItem) to:

* read the attributes of a playlist item
* delete a playlist item

```ruby
item = Yt::PlaylistItem.new id: 'PLjW_GNR5Ir0GWEP_oveGBNjTvKkYyZfsna1TZDCBP-Z8'

item.title #=> "Titanium - David Guetta - Space Among Many Cover ft. Evan Chan and Glenna Roberts"
item.description #=> "CLICK to tweet this video: [...]"
item.description.has_link_to_channel? #=> true
item.thumbnail_url #=> "https://i1.ytimg.com/vi/W4GhTprSsOY/default.jpg"
item.published_at #=> 2012-12-22 19:38:02 UTC
item.public? #=> true
item.channel_id #=> "UCxO1tY8h1AhOz0T4ENwmpow"
item.channel_title #=> "Fullscreen"
item.playlist_id #=> "PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc"
item.position #=> 0
item.video_id #=> "W4GhTprSsOY"
item.video #=> #<Yt::Models::Video @id=...>
```

*The methods above do not require authentication.*

```ruby
item.delete #=> true
```

*The methods above require to be authenticated as the playlist’s owner (see below).*


Yt::Annotation
--------------

Use [Yt::Annotation](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Annotation) to:

* read the attributes of an annotation

```ruby
video = Yt::Video.new id: 'MESycYJytkU'
annotation = video.annotations.first

annotation.below? 70 #=> false
annotation.has_link_to_subscribe? #=> false
annotation.has_link_to_playlist? #=> true
```

*Annotations do not require authentication.*

Configuring your app
====================

In order to use Yt you must register your app in the [Google Developers Console](https://console.developers.google.com).

If you don’t have a registered app, browse to the console and select "Create Project":
![01-create-project](https://cloud.githubusercontent.com/assets/7408595/3373043/4224c894-fbb0-11e3-9f8a-4d96bddce136.png)

When your project is ready, select APIs & Auth in the menu and enable Google+, YouTube Analytics and YouTube Data API:
![02-select-api](https://cloud.githubusercontent.com/assets/7408595/3373046/4226ea34-fbb0-11e3-9a44-872871e8b297.png)

The next step is to create an API key. Depending on the nature of your app, you should pick one of the following strategies.

Apps that do not require user interactions
------------------------------------------

If you are building a read-only app that fetches public data from YouTube, then
all you need is a **Public API access**.

Click on "Create new Key" in the Public API section and select "Server Key":
![03-create-key](https://cloud.githubusercontent.com/assets/7408595/3373045/42258fcc-fbb0-11e3-821c-699c8a3ce7bc.png)
![04-create-server-key](https://cloud.githubusercontent.com/assets/7408595/3373044/42251db2-fbb0-11e3-93f9-8f06f8390b4e.png)

Once the key for server application is created, copy the API key and add it
to your code with the following snippet of code (replacing with your own key):

```ruby
Yt.configure do |config|
  config.api_key = 'AIzaSyAO8dXpvZcaP2XSDFBD91H8yQ'
end
```

Remember: this kind of app is not allowed to perform any destructive operation,
so you won’t be able to like a video, subscribe to a channel or delete a
playlist from a specific account. You will only be able to retrieve read-only
data.

Web apps that require user interactions
---------------------------------------

If you are building a web app that manages YouTube accounts, you need the
owner of each account to authorize your app. There are three scenarios:

Scenario 1. If you already have the account’s **access token**, then you are ready to go.
Just pass that access token to the account initializer, such as:

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
account.email #=> (retrieves the account’s e-mail address)
account.videos #=> (lists a video to an account’s playlist)
```

Scenario 2. If you don’t have the account’s access token, but you have the
**refresh token**, then it’s almost as easy.
In the [Google Developers Console](https://console.developers.google.com),
find the web application that was used to obtain the refresh token, copy the
Client ID and Client secret and add them to you code with the following snippet
of code (replacing with your own keys):

```ruby
Yt.configure do |config|
  config.client_id = '1234567890.apps.googleusercontent.com'
  config.client_secret = '1234567890'
end
```
Then you can manage a YouTube account by passing the refresh token to the
account initializer, such as:

```ruby
account = Yt::Account.new refresh_token: '1/1234567890'
account.email #=> (retrieves the account’s e-mail address)
account.videos #=> (lists a video to an account’s playlist)
```

Scenario 3. If you don’t have any account’s token, then you can get one by
having the user authorize your app through the Google OAuth page.

In the [Google Developers Console](https://console.developers.google.com),
click on "Create new Client ID" in the OAuth section and select "Web application":
![06-create-client-key](https://cloud.githubusercontent.com/assets/7408595/3373047/42379eba-fbb0-11e3-89c4-16b10e072de6.png)

Fill the "Authorized Redirect URI" textarea with the URL of your app where you
want to redirect users after they authorize their YouTube account.

Once the Client ID for web application is created, copy the Client ID and secret
and add them to your code with the following snippet of code (replacing with your own keys):

```ruby
Yt.configure do |config|
  config.client_id = '49781862760-4t610gtk35462g.apps.googleusercontent.com'
  config.client_secret = 'NtFHjZkJcwYZDfYVz9mp8skz9'
end
```

Finally, in your web app, add a link to the URL generated by running

```ruby
Yt::Account.new(scopes: scopes, redirect_uri: redirect_uri).authentication_url
```

where `redirect_uri` is the URL you entered in the form above, and `scopes` is
the list of YouTube scopes you want the user to authorize. Depending on the
nature of your app, you can pick one or more among `youtube`, `youtube.readonly` `userinfo.email`.

Every user who authorizes your app will be redirected to the `redirect_uri`
with an extra `code` parameter that looks something like `4/Ja60jJ7_Kw0`.
Just pass the code to the following method to authenticate and initialize the account:

```ruby
account = Yt::Account.new authorization_code: '4/Ja60jJ7_Kw0', redirect_uri: redirect_uri
account.email #=> (retrieves the account’s e-mail address)
account.videos #=> (lists a video to an account’s playlist)
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export YT_CLIENT_ID="1234567890.apps.googleusercontent.com"
export YT_CLIENT_SECRET="1234567890"
export YT_API_KEY="123456789012345678901234567890"
```

is equivalent to configuring your app with the initializer:

```ruby
Yt.configure do |config|
  config.client_id = '1234567890.apps.googleusercontent.com'
  config.client_secret = '1234567890'
  config.api_key = '123456789012345678901234567890'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `Yt.configure` takes precedence.

How to install
==============

To install on your system, run

    gem install yt

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'yt', '~> 0.7.5'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Yt is released.

Why you should use Yt…
-----------------------

… and not [youtube_it](https://github.com/kylejginavan/youtube_it)?
Because youtube_it does not support Google API V3 and the previous version
has already been deprecated by Google and will soon be dropped.

… and not [Google Api Client](https://github.com/google/google-api-ruby-client)?
Because Google Api Client is poorly coded, poorly documented and adds many
dependencies, bloating the size of your project.

… and not your own code? Because Yt is fully tested, well documented,
has few dependencies and helps you forget about the burden of dealing with
Google API!

How to test
===========

Yt comes with two different sets of tests:

1. tests in `spec/models`, `spec/collections` and `spec/errors` **do not hit** the YouTube API
1. tests in `spec/requests` **hit** the YouTube API and require authentication

The reason why some tests actually hit the YouTube API is because they are
meant to really integrate Yt with YouTube. YouTube API is not exactly
*the most reliable* API out there, so we need to make sure that the responses
match the documentation.

You don’t have to run all the tests every time you change code.
Travis CI is already set up to do this for when whenever you push a branch
or create a pull request for this project.

To only run tests against models, collections and errors (which do not hit the API), type:

```bash
rspec spec/models spec/collections spec/errors
```

To also run live-tests against the YouTube API, type:

```bash
rspec
```

This will fail unless you have set up a test YouTube application and some
tests YouTube accounts to hit the API. Once again, you probably don’t need
this, since Travis CI already takes care of running this kind of tests.

How to contribute
=================

Yt needs your support!
The goal of Yt is to provide a Ruby interface for all the methods exposed by
the [YouTube Data API (v3)](https://developers.google.com/youtube/v3) and by
the [YouTube Analytics API](https://developers.google.com/youtube/analytics).

If you find that a method is missing, fork the project, add the missing code,
write the appropriate tests, then submit a pull request, and it will gladly
be merged!

How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Yt gem](http://rubygems.org/gems/yt)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing on [Travis CI](https://travis-ci.org/Fullscreen/yt),
document the changes in HISTORY.md and README.md, bump the version, then run

    rake release

Remember that the yt gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.0.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)

Don’t hesitate to send code comments, issues or pull requests through GitHub!
All feedback is appreciated. A [googol](http://en.wikipedia.org/wiki/Googol) of thanks! :)
