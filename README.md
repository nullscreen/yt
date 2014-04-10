Googol
======

Googol lets you interact with many resources provided by Google API V3.

[![Gem Version](https://badge.fury.io/rb/googol.svg)](http://badge.fury.io/rb/googol)
[![Dependency Status](https://gemnasium.com/fullscreeninc/googol.png)](https://gemnasium.com/fullscreeninc/googol)
[![Build Status](https://travis-ci.org/fullscreeninc/googol.png?branch=master)](https://travis-ci.org/fullscreeninc/googol)
[![Coverage Status](https://coveralls.io/repos/fullscreeninc/googol/badge.png)](https://coveralls.io/r/fullscreeninc/googol)
[![Code Climate](https://codeclimate.com/github/fullscreeninc/googol.png)](https://codeclimate.com/github/fullscreeninc/googol)


```ruby
channel = Googol::YoutubeResource.new url: 'youtube.com/remhq'
channel.id #=> 'UC7eaRqtonpyiYw0Pns0Au_g'
channel.title #=> "remhq"
channel.description #=> "R.E.M.'s Official YouTube Channel"
```

```ruby
video = Googol::YoutubeResource.new url: 'youtu.be/Kd5M17e7Wek'
video.id #=> 'Kd5M17e7Wek'
video.title #=> "R.E.M. - Tongue (Video)"
video.description #=> "© 2006 WMG\nTongue (Video)"
```

```ruby
account = Googol::GoogleAccount.new auth_params
account.email #=> 'user@google.com'
```

```ruby
account = Googol::YoutubeAccount.new auth_params

# like the video 'Tongue'  by R.E.M.
account.like! video_id: 'Kd5M17e7Wek'

# subscribes to R.E.M.’s channel
account.subscribe_to! channel_id: 'UC7eaRqtonpyiYw0Pns0Au_g' # => subscribes to R.E.M.’s channel

# add the video 'Tongue' to your 'Favorite Music Videos' playlist
playlist_id = account.find_or_create_playlist_by title: 'Favorite Music Videos'
account.add_to! playlist_id: playlist_id, video_id: 'Kd5M17e7Wek' # => adds 'Tongue' to your 'Favorite Music Videos' playlist
```

The full documentation is available at [rubydoc.info](http://rubydoc.info/github/fullscreeninc/googol/master/frames).

Available classes
=================

Googol exposes three different resources provided by Google API V3:
Google Accounts, Youtube Accounts and Youtube Resources.

Google accounts
---------------

Use `Googol::GoogleAccount` to send and retrieve data to Google,
impersonating an existing Google account.

Available instance methods are `id`, `email`, `verified_email`, `name`,
`given_name`, `family_name`, `link`, `picture`, `gender`, `locale`, and `hd`.

These methods require user authentication (see below).

Youtube accounts
----------------

Use `Googol::YoutubeAccount` to send and retrieve data to Youtube,
impersonating an existing Youtube account.

Available instance methods are `id`, `title`, `description`, `thumbnail_url`,
`like!`, `subscribe_to!`, `find_or_create_playlist_by`, and `add_to!`.

These methods require user authentication (see below).

Youtube resources
-----------------

Use `Googol::YoutubeResource` to retrieve read-only information about
public Youtube channels and videos.

Available instance methods are `id`, `title`, `description`, and `thumbnail_url`.

These methods require do not require user authentication.

Authentication
==============

In order to use Googol you must register your app in the [Google Developers Console](https://console.developers.google.com):

1. Create a new app and enable access to Google+ API and YouTube Data API V3
1. Generate a new OAuth client ID (web application) and write down the `client ID` and `client secret`
1. Generate a new Public API access key (for server application) and write down the `server key`

Run the following command to make these tokens available to Googol:

```ruby
require 'googol'
Googol::ClientTokens.client_id = '…'
Googol::ClientTokens.client_secret = '…'
Googol::ServerTokens.server_key = '…'
```

replacing the ellipses with the values from the Google Developers Console.

For actions that impersonate a Google or Youtube account, you also need to
obtain authorization from the owner of the account you wish to impersonate:

1. In your web site, add a link to the Google's OAuth login page. The URL is:

    ```ruby
    Googol::GoogleAccount.oauth_url(redirect_url) # to impersonate a Google Account
    Googol::YoutubeAccount.oauth_url(redirect_url) # to impersonate a Youtube Account
    ```

1. Upon authorization, the user is redirected to the URL passed as an argument, with an extra 'code' query parameter which can be used to impersonate the account:

    ```ruby
    account = Googol::GoogleAccount.new(code: code, redirect_uri: url) # to impersonate a Google Account
    account = Googol::YoutubeAccount.new(code: code, redirect_uri: url) # to impersonate a Youtube Account
    ```

1. To prevent the user from having to authorize the app every time, store the account’s refresh_token in your database:

    ```ruby
    refresh_token = account.credentials[:refresh_token] # Store to your DB
    ```

1. To impersonate an account that has already authorized your app, just use the refresh_token:

    ```ruby
    account = Googol::GoogleAccount.new(refresh_token: refresh_token) # to impersonate a Google Account
    account = Googol::YoutubeAccount.new(refresh_token: refresh_token) # to impersonate a Youtube Account
    ```

Remember to add every redirect URL that you plan to use in the Google Developers
Console, and to set a *Product name* in Consent screen (under API & Auth).

How to install
==============

To install on your system, run

    gem install googol

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'googol', '~> 0.2.0'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Googol is released.

Remember that you need to set up a Google app and include its credentials
in order for the gem to work (see above). In a Rails project, for instance,
you can do so by writing the following code in `config/initializer/googol.rb`:

    Googol::ClientTokens.client_id = '…'
    Googol::ClientTokens.client_secret = '…'
    Googol::ServerTokens.server_key = '…'

replacing the ellipses with your app values from the Google Developers Console.


Why you should use Googol…
--------------------------

… and not [youtube_it](https://github.com/kylejginavan/youtube_it)?
Because youtube_it does not support Google API V3 and the previous version
has already been deprecated by Google and will soon be dropped.

… and not [Google Api Client](https://github.com/google/google-api-ruby-client)?
Because Google Api Client is poorly coded, poorly documented and adds many
dependencies, bloating the size of your project.

… and not your own code? Because Googol is fully tested, well documented,
has few dependencies and helps you forget about the burden of dealing with
Google API!

How to test
===========

To run the tests, you must give the test app permissions to access your
Google and Youtube accounts. They are free, so feel free to create a fake one.

1. Run the following commands in a ruby session:

    ```ruby
    require 'googol'
    Googol::GoogleAccount.oauth_url  # => "https://accounts.google.com/o..."
    ```

1. Copy the last URL in a browser, and accept the terms. You will be redirected to a URL like http://example.com/?code=ABCDE

1. Copy the `code` parameter (ABCDE in the example above) and run:

    ```ruby
    account = Googol::GoogleAccount.new code: 'ABCDE'
    account.credentials[:refresh_token]
    ```

1. Copy the token returned by the last command (something like 1AUJZh2x1...) and store it in an environment variable before running the test suite:

    ```ruby
    export GOOGOL_TEST_GOOGLE_REFRESH_TOKEN="1AUJZh2x1..."
    ```

1. Repeat all the steps above replacing GoogleAccount with YoutubeAccount to authorize access to your Youtube account:

    ```ruby
    export GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN="2B6T5x23..."
    ```

1. Finally run the tests running `rspec` or `rake`. If you prefer not to set environment variables, pass the refresh token in the same line:

    ```ruby
    GOOGOL_TEST_GOOGLE_REFRESH_TOKEN="1AUJZh2x1..." GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN="2B6T5x23..." rspec
    ```

How to contribute
=================

Before you submit a pull request, make sure all the tests are passing and the
code is fully test-covered.

To release an updated version of the gem to Rubygems, run:

    rake release

Remember to *bump the version* before running the command, and to document
your changes in HISTORY.md and README.md if required.

The googol gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.0.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)


Don’t hesitate to send code comments, issues or pull requests through GitHub!
All feedback is appreciated. A [googol](http://en.wikipedia.org/wiki/Googol) of thanks! :)
