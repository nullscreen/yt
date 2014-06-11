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
channel.description #=> "The first media company for the connected generation."
channel.public? #=> true
channel.videos.count #=> 12
```

```ruby
video = Yt::Video.new id: 'MESycYJytkU'
video.title #=> "Fullscreen Creator Platform"
video.public? #=> true
video.duration #=> 86
video.annotations.count #=> 1
```

The **full documentation** is available at [rubydoc.info](http://rubydoc.info/github/Fullscreen/yt/master/frames).

Available resources
===================

Yt::Account
-----------

Use [Yt::Account](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Account) to:

* authenticate as a YouTube account
* read attributes of the account
* access the YouTube channel of the account

```ruby
# An account can be initialized with access token, refresh token or an authorization code
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'

account.email #=> .. your e-mail address..
account.channel #=> #<Yt::Channel @id=...>
```

*All the above methods require authentication (see below).*

Yt::ContentOwner
----------------

Use [Yt::ContentOwner](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/ContentOwner) to:

* authenticate as a YouTube content owner
* list the channels partnered with a YouTube content owner

```ruby
# A content owner is an account, therefore can be initialized with access token, refresh token or an authorization code
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'

content_owner.partnered_channels.count #=> 12
content_owner.partnered_channels.first #=> #<Yt::Channel @id=...>
```

*All the above methods require authentication (see below).*

Yt::Channel
-----------

Use [Yt::Channel](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Channel) to:

* read attributes of a channel
* access the videos of a channel
* access the playlists of a channel
* subscribe to and unsubscribe from a channel
* create and delete playlists from a channel
* retrieve the estimated daily earnings of a channel

```ruby
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow'
channel.title #=> "Fullscreen"
channel.description.has_link_to_playlist? #=> false
channel.public? #=> true

channel.videos.count #=> 12
channel.videos.first #=> #<Yt::Video @id=...>

channel.playlists.count #=> 2
channel.playlists.first #=> #<Yt::Playlist @id=...>
```

*The methods above do not require authentication.*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: account

channel.subscribed? #=> false
channel.subscribe #=> true

channel.create_playlist title: 'New playlist' #=> true
channel.delete_playlists title: 'New playlist' #=> [true]

```

*The methods above require to be authenticated as a YouTube account (see below).*

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: content_owner

channel.earnings_on 5.days.ago #=> 12.23
channel.earnings since: 3.days.ago, until: 2.days.ago #=> {Wed, 28 May 2014 => 1.34, Thu, 29 May 2014 => 0.47}

channel.views_on 5.days.ago #=> 44
channel.views since: 3.days.ago, until: 2.days.ago #=> {Wed, 28 May 2014 => 12, Thu, 29 May 2014 => 3}
```

*The methods above require to be authenticated as the channel’s content owner (see below).*


Yt::Video
-----------

Use [Yt::Video](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Video) to:

* read attributes of a video
* access the annotations of a video
* like and dislike a video

```ruby
video = Yt::Video.new id: 'MESycYJytkU'
video.title #=> "Fullscreen Creator Platform"
video.duration #=> 63
video.description.has_link_to_subscribe? #=> false
video.public? #=> true

video.annotations.count #=> 1
video.annotations.first #=> #<Yt::Annotation @id=...>
```

*The methods above do not require authentication.*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
video = Yt::Video.new id: 'MESycYJytkU', auth: account

video.liked? #=> false
video.like #=> true
```

*The methods above require to be authenticated as a YouTube account (see below).*

Yt::Playlist
------------

Use [Yt::Playlist](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Playlist) to:

* read attributes of a playlist
* access the items of a playlist
* add one or multiple videos to a playlist
* delete items from a playlist

```ruby
playlist = Yt::Playlist.new id: 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc'
playlist.title #=> "Fullscreen Features"
playlist.public? #=> true

playlist.playlist_items.count #=> 1
playlist.playlist_items.first #=> #<Yt::PlaylistItem @id=...>
playlist.playlist_items.first.position #=> 0
playlist.playlist_items.first.video.title #=> "Fullscreen Creator Platform"
```

*The methods above do not require authentication.*

```ruby
playlist.add_video 'MESycYJytkU'
playlist.add_videos ['MESycYJytkU', 'MESycYJytkU']
playlist.delete_playlist_items title: 'Fullscreen Creator Platform' #=> [true]
```

*The methods above require to be authenticated as the playlist’s owner (see below).*


Yt::Annotation
--------------

Use [Yt::Annotation](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Annotation) to:

* read attributes of an annotation

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
Depending on the nature of your app, you should pick one of the following strategies.

Apps that do not require user interactions
------------------------------------------

If you are building a read-only app that fetches public data from YouTube, then
generate a **Public API access** key in the Google Console.
Next, add the following snippet of code to the initializer of your app:

```ruby
Yt.configure do |config|
  config.api_key = '123456789012345678901234567890'
end
```

replacing the value above with your own key for server application.

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
account.playlists.first.add_video 'MESycYJytkU' #=> (adds a video to an account’s playlist)
```

Scenario 2. If you don’t have the account’s access token, but you have the
**refresh token**, then it’s almost as easy.
Open the [Google Developers Console](https://console.developers.google.com),
find the client ID and client secret of the **web application** that you used to obtain the
refresh token, then add the following snippet of code to the initializer of your app:

```ruby
Yt.configure do |config|
  config.client_id = '1234567890.apps.googleusercontent.com'
  config.client_secret = '1234567890'
end
```

replacing the values above with the client ID and secret for web application.
Then you can manage a YouTube account by passing the refresh token to the
account initializer, such as:

```ruby
account = Yt::Account.new refresh_token: '1/1234567890'
account.email #=> (retrieves the account’s e-mail address)
account.playlists.first.add_video 'MESycYJytkU' #=> (adds a video to an account’s playlist)
```

Scenario 3. If you don’t have any account’s token, then you can get one by
having the user authorize your app through the Google OAuth page. First,
build the the Google OAuth page URL with the following code:

```ruby
Yt::Account.new(scopes: scopes, redirect_uri: redirect_uri).authentication_url
```

where `scopes` is the list of scopes you want the user to authorize, and
`redirect_uri` is the page of your web app the user should come back after
authorizing (remember, this must be added to the Google Console as well).
Sample scopes are: `youtube`, `youtube.readonly` `userinfo.email`.

After authorizing your app, the user will be redirected to `redirect_uri`
with an extra `code` parameter that looks something like `4/Ja60jJ7_Kw0`.
Just pass the code to the following method to authenticate and initialize the account:

```ruby
account = Yt::Account.new authorization_code: '4/Ja60jJ7_Kw0'
account.email #=> (retrieves the account’s e-mail address)
account.playlists.first.add_video 'MESycYJytkU' #=> (adds a video to an account’s playlist)
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export YT_CLIENT_SCENARIO="device_app"
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

    gem 'yt', '~> 0.6.2'

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

1. tests in `spec/models` and `spec/collections` **do not hit** the YouTube API
1. tests in `spec/associations` **hit** the YouTube API and require authentication

To run all the tests, type:

```bash
rspec
```

The reason why some tests actually hit the YouTube API is because they are
meant to really integrate Yt with YouTube. YouTube API is not exactly
*the most reliable* API out there, so we need to make sure that the responses
match the documentation.

You don’t have to run all the tests every time you change code.
Travis CI is already set up to do this for when whenever you push a branch
or create a pull request for this project.

Testing models and collections
------------------------------

To only run tests against models and collections (which do not hit the API), type:

```bash
rspec spec/models spec/collections
```

Testing associations
--------------------

To only run tests against associations (which hit the API), type:

```bash
rspec spec/associations
```

This test will fail at first. As documented by the error message, you will need
an app registered in the [Google Developers Console](https://console.developers.google.com)
to proceed.

Browse to the Console, then create a new app that you will only use for testing.

Under the "APIs" tab of this app, enable 'Google+ API', 'Youtube Analytics
API' and 'YouTube Data API v3'.

Under the "Credentials" tab of this app, create a new 'Key for server
application' and a new 'Client ID' and 'Client Secret' for **native** application.

It’s important that you pick 'native application' instead of 'web application',
otherwise running your tests will require you to open a browser and launch a
local webserver… and you don’t need to do any of that.

Finally, copy the given values and set the following environment variables:

```bash
export YT_TEST_DEVICE_CLIENT_ID="1234567890.apps.googleusercontent.com"
export YT_TEST_DEVICE_CLIENT_SECRET="1234567890"
export YT_TEST_SERVER_API_KEY="123456789012345678901234567890"
```

[ TODO:
  Complete this section.
  Explain how get and store the refresh token, making sure all the required scopes are authorized:
  'https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'
]



How to contribute
=================

Before you submit a pull request, make sure all the tests are passing and the
code is fully test-covered.

To release an updated version of the gem to Rubygems, run:

    rake release

Remember to *bump the version* before running the command, and to document
your changes in HISTORY.md and README.md if required.

The yt gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.0.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)

Don’t hesitate to send code comments, issues or pull requests through GitHub!
All feedback is appreciated. A [googol](http://en.wikipedia.org/wiki/Googol) of thanks! :)
