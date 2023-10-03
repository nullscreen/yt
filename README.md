Yt - a Ruby client for the YouTube API
======================================================

Yt helps you write apps that need to interact with YouTube.

The **source code** is available on [GitHub](https://github.com/Fullscreen/yt) and the **documentation** on [RubyDoc](http://www.rubydoc.info/gems/yt/frames).

[![Build Status](http://img.shields.io/travis/Fullscreen/yt/master.svg)](https://travis-ci.org/Fullscreen/yt)
[![Coverage Status](http://img.shields.io/coveralls/Fullscreen/yt/master.svg)](https://coveralls.io/r/Fullscreen/yt)
[![Dependency Status](http://img.shields.io/gemnasium/Fullscreen/yt.svg)](https://gemnasium.com/Fullscreen/yt)
[![Code Climate](https://codeclimate.com/github/Fullscreen/yt.png)](https://codeclimate.com/github/Fullscreen/yt)
[![Online docs](http://img.shields.io/badge/docs-✓-green.svg)](http://www.rubydoc.info/gems/yt/frames)
[![Gem Version](http://img.shields.io/gem/v/yt.svg)](http://rubygems.org/gems/yt)

After [registering your app](#configuring-your-app), you can run commands like:

```ruby
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow'
channel.title #=> "Fullscreen"
channel.public? #=> true
channel.videos.count #=> 12
```

```ruby
video = Yt::Video.new id: 'jNQXAC9IVRw'
video.title #=> "Fullscreen Creator Platform"
video.comment_count #=> 308
video.hd? #=> true
video.annotations.count #=> 1
video.comment_threads #=> #<Yt::Collections::CommentThreads ...>
# Use #take to limit the number of pages need to fetch from server
video.comment_threads.take(99).map(&:author_display_name) #=> ["Paul", "Tommy", ...]
```

The **full documentation** is available at [rubydoc.info](http://www.rubydoc.info/gems/yt/frames).

How to install
==============

To install on your system, run

    gem install yt

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'yt', '~> 0.32.0'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Yt is released.

Available resources
===================

Yt::Account
-----------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/accounts.html) for the list of methods available for `Yt::Account`.


Yt::ContentOwner
----------------

Use [Yt::ContentOwner](http://www.rubydoc.info/gems/yt/Yt/Models/ContentOwner) to:

* authenticate as a YouTube content owner
* list the channels partnered with a YouTube content owner
* list the claims administered by the content owner
* list and delete the references administered by the content owner
* list the policies and policy rules administered by the content owner
* create assets
* list assets

```ruby
# Content owners can be initialized with access token, refresh token or an authorization code
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'

content_owner.partnered_channels.count #=> 12
content_owner.partnered_channels.map &:title #=> ["Fullscreen", "Best of Fullscreen", ...]
content_owner.partnered_channels.where(part: 'statistics').map &:subscriber_count #=> [136925, 56945, ...]

content_owner.claims.where(q: 'Fullscreen').count #=> 24
content_owner.claims.first #=> #<Yt::Models::Claim @id=...>
content_owner.claims.first.video_id #=> 'jNQXAC9IVRw'
content_owner.claims.first.status #=> "active"

reference = content_owner.references.where(asset_id: "ABCDEFG").first #=> #<Yt::Models::Reference @id=...>
reference.delete #=> true

content_owner.policies.first #=> #<Yt::Models::Policy @id=...>
content_owner.policies.first.name #=> "Track in all countries"
content_owner.policies.first.rules.first #=> #<Yt::Models::PolicyRule @id=...>
content_owner.policies.first.rules.first.action #=> "monetize"
content_owner.policies.first.rules.first.included_territories #=> ["US", "CA"]

content_owner.create_asset type: 'web' #=> #<Yt::Models::Asset @id=...>

content_owner.assets.first #=> #<Yt::Models::AssetSnippet:0x007ff2bc543b00 @id=...>
content_owner.assets.first.id #=> "A4532885163805730"
content_owner.assets.first.title #=> "Money Train"
content_owner.assets.first.type #=> "web"
content_owner.assets.first.custom_id #=> "MoKNJFOIRroc"

```

*All the above methods require authentication (see below).*

Yt::Channel
-----------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/channels.html) for the list of methods available for `Yt::Channel`.

Yt::Video
---------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/videos.html) for the list of methods available for `Yt::Video`.

Yt::Playlist
------------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/playlists.html) for the list of methods available for `Yt::Playlist`.

Yt::PlaylistItem
----------------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/playlist_items.html) for the list of methods available for `Yt::PlaylistItem`.

Yt::CommentThread
----------------

Use [Yt::CommentThread](http://www.rubydoc.info/gems/yt/Yt/Models/CommentThread) to:

* Show details of a comment_thread.

```ruby
Yt::CommentThread.new id: 'z13vsnnbwtv4sbnug232erczcmi3wzaug'

comment_thread.video_id #=> "1234"
comment_thread.total_reply_count #=> 1
comment_thread.can_reply? #=> true
comment_thread.public? #=> true

comment_thread.top_level_comment #=> #<Yt::Models::Comment ...>
comment_thread.text_display #=> "funny video!"
comment_thread.like_count #=> 9
comment_thread.updated_at #=> 2016-03-22 12:56:56 UTC
comment_thread.author_display_name #=> "Joe"
```

Yt::Comment
----------------

Use [Yt::Comment](http://www.rubydoc.info/gems/yt/Yt/Models/Comment) to:

* Get details of a comment.

```ruby
Yt::Comment.new id: 'z13vsnnbwtv4sbnug232erczcmi3wzaug'

comment.text_display #=> "awesome"
comment.author_display_name #=> "Jack"
comment.like_count #=> 1
comment.updated_at #=> 2016-03-22 12:56:56 UTC
comment.parent_id #=> "abc1234" (return nil if the comment is not a reply)
```

Yt::BulkReportJob
----------------

Use [Yt::BulkReportJob](http://www.rubydoc.info/gems/yt/Yt/Models/BulkReportJob) to:

* Get details of a bulk report job.

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
bulk_report_job = content_owner.bulk_report_jobs.first

bulk_report_job.report_type_id #=> "content_owner_demographics_a1"
```

Yt::BulkReport
----------------

Use [Yt::BulkReport](http://www.rubydoc.info/gems/yt/Yt/Models/BulkReport) to:

* Get details of a bulk report.

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
bulk_report_job = content_owner.bulk_report_jobs.first
bulk_report = bulk_report_job.bulk_reports.first

bulk_report.start_time #=> 2017-08-11 07:00:00 UTC
bulk_report.end_time #=> 2017-08-12 07:00:00 UTC
bulk_report.download_url #=> "https://youtubereporting.googleapis.com/v1/..."
```

Yt::Collections::Videos
-----------------------

Use [Yt::Collections::Videos](http://www.rubydoc.info/gems/yt/Yt/Collections/Videos) to:

* search for videos

```ruby
videos = Yt::Collections::Videos.new
videos.where(order: 'viewCount').first.title #=>  "PSY - GANGNAM STYLE"
videos.where(q: 'Fullscreen CreatorPlatform', safe_search: 'none').size #=> 324
videos.where(chart: 'mostPopular', video_category_id: 44).first.title #=> "SINISTER - Trailer"
videos.where(id: 'jNQXAC9IVRw,invalid').map(&:title) #=> ["Fullscreen Creator Platform"]
```

*The methods above do not require authentication.*


Yt::Annotation
--------------

Check [nullscreen.github.io/yt](http://nullscreen.github.io/yt/annotations.html) for the list of methods available for `Yt::Annotation`.


Yt::MatchPolicy
---------------

Use [Yt::MatchPolicy](http://www.rubydoc.info/gems/yt/Yt/Models/MatchPolicy) to:

* update the policy used by an asset

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
match_policy = Yt::MatchPolicy.new asset_id: 'ABCD12345678', auth: content_owner
match_policy.update policy_id: 'aBcdEF6g-HJ' #=> true
```

Yt::Asset
---------

Use [Yt::Asset](http://www.rubydoc.info/gems/yt/Yt/Models/Asset) to:

* read the ownership of an asset
* update the attributes of an asset

```ruby

content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
asset = Yt::Asset.new id: 'ABCD12345678', auth: content_owner
asset.ownership #=> #<Yt::Models::Ownership @general=...>
asset.ownership.obtain! #=> true
asset.general_owners.first.owner #=> 'CMSname'
asset.general_owners.first.everywhere? #=> true
asset.ownership.release! #=> true

asset.update metadata_mine: {notes: 'Some notes'} #=> true
```

* to retrieve metadata for an asset (e.g. title, notes, description, custom_id)

```ruby
content_owner = Yt::ContentOwner.new(...)
asset = content_owner.assets.where(id: 'A969176766549462', fetch_metadata: 'mine').first
asset.metadata_mine.title #=> "Master Final   Neu La Anh Fix"

asset = content_owner.assets.where(id: 'A969176766549462', fetch_metadata: 'effective').first
asset.metadata_effective.title #=> "Neu la anh" (different due to ownership conflicts)
```

```ruby
asset = content_owner.assets.where(id: 'A125058570526569', fetch_ownership: 'effective').first
asset.ownership_effective.general_owners.first.owner # => "XOuN81q-MeEUVrsiZeK1lQ"
```

* to search for an asset

```ruby
content_owner.assets.where(labels: "campaign:cpiuwdz-8oc").size #=> 417
content_owner.assets.where(labels: "campaign:cpiuwdz-8oc").first.title #=> "Whoomp! (Supadupafly) (Xxl Hip House Mix)"
```

Yt::Claim
---------

Use [Yt::Claim](http://www.rubydoc.info/gems/yt/Yt/Models/Claim) to:

* read the attributes of a claim
* view the history of a claim
* update the attributes of an claim

```ruby

content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
claim = Yt::Claim.new id: 'ABCD12345678', auth: content_owner
claim.video_id #=> 'va141cJga2'
claim.asset_id #=> 'A1234'
claim.content_type #=> 'audiovisual'
claim.active? #=> true

claim.claim_history #=> #<Yt::Models::ClaimHistory ...>
claim.claim_history.events[0].type #=> "claim_create"

claim.delete #=> true

data = {
  is_manual_claim: true,
  content_type: 'audiovisual',
  asset_id: 'A123123123123123',
  policy: { id: 'S123123123123123' },
  video_id: 'myvIdeoIdYT',
  match_info: {
    match_segments: [
      {
        manual_segment: {
          start: '00:00:20.000',
          finish: '00:01:20.000'
        }
      },
      {
        manual_segment: {
          start: '00:02:30.000',
          finish: '00:03:50.000'
        }
      }
    ]
  }
}

content_owner.claims.insert(data)
```

*The methods above require to be authenticated as the video’s content owner (see below).*

Yt::Ownership
-------------

Use [Yt::Ownership](http://www.rubydoc.info/gems/yt/Yt/Models/Ownership) to:

* update the ownership of an asset

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
ownership = Yt::Ownership.new asset_id: 'ABCD12345678', auth: $content_owner
new_general_owner_attrs = {ratio: 100, owner: 'CMSname', type: 'include', territories: ['US', 'CA']}
ownership.update general: [new_general_owner_attrs]
```

*The methods above require to be authenticated as the video’s content owner (see below).*

Yt::AdvertisingOptionsSet
-------------------------

Use [Yt::AdvertisingOptionsSet](http://www.rubydoc.info/gems/yt/Yt/Models/AdvertisingOptionsSet) to:

* update the advertising settings of a video

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
ad_options = Yt::AdvertisingOptionsSet.new video_id: 'jNQXAC9IVRw', auth: $content_owner
ad_options.update ad_formats: %w(standard_instream long) #=> true
```

*The methods above require to be authenticated as the video’s content owner (see below).*

Instrumentation
===============

Yt leverages [Active Support Instrumentation](http://edgeguides.rubyonrails.org/active_support_instrumentation.html) to provide a hook which developers can use to be notified when HTTP requests to YouTube are made.  This hook may be used to track the number of requests over time, monitor quota usage, provide an audit trail, or track how long a specific request takes to complete.

Subscribe to the `request.yt` notification within your application:

```ruby
ActiveSupport::Notifications.subscribe 'request.yt' do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  event.payload[:request_uri] #=> #<URI::HTTPS URL:https://www.googleapis.com/youtube/v3/channels?id=UCxO1tY8h1AhOz0T4ENwmpow&part=snippet>
  event.payload[:method] #=> :get
  event.payload[:response] #=> #<Net::HTTPOK 200 OK readbody=true>

  event.end #=> 2014-08-22 16:57:17 -0700
  event.duration #=> 141.867 (ms)
end
```

Configuring your app
====================

In order to use Yt you must register your app in the [Google Developers Console](https://console.developers.google.com).

If you don’t have a registered app, browse to the console and select "Create Project":
![01-create-project](https://cloud.githubusercontent.com/assets/7408595/3373043/4224c894-fbb0-11e3-9f8a-4d96bddce136.png)

When your project is ready, select APIs & Auth in the menu and individually enable Google+, YouTube Analytics and YouTube Data API:
![02-select-api](https://cloud.githubusercontent.com/assets/4453997/8442701/5d0f77f4-1f35-11e5-93d8-07d4459186b5.png)
![02a-enable google api](https://cloud.githubusercontent.com/assets/4453997/8442306/0f714cb8-1f33-11e5-99b3-f17a4b1230fe.png)
![02b-enable youtube api](https://cloud.githubusercontent.com/assets/4453997/8442304/0f6fd0e0-1f33-11e5-981a-acf90ccd7409.png)
![02c-enable youtube analytics api](https://cloud.githubusercontent.com/assets/4453997/8442305/0f71240e-1f33-11e5-9b60-4ecea02da9be.png)

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

How to test
===========

To run tests:

```bash
rspec
```

We recommend RSpec >= 3.8.

Yt comes with two different sets of tests:

1. Unit tests in `spec/models`, `spec/collections` and `spec/errors`
2. Legacy integration tests in `spec/requests`

Coming soon will be a new set of high-level integration tests.

Integration tests are recorded with VCR. Some of the tests refer to
fixture data that an arbitrary account may not have access to. If you
need to modify one of these tests or re-record the cassette, we'd
suggest working against your own version of the testing setup. Then in
your pull request, we can help canonize your test/fixtures.

Some of the integration tests require authentication. These can be set
with the following environment variables:

* `YT_TEST_CLIENT_ID`
* `YT_TEST_CLIENT_SECRET`
* `YT_TEST_API_KEY`
* `YT_TEST_REFRESH_TOKEN`

How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Yt gem](http://rubygems.org/gems/yt)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing on [Travis CI](https://travis-ci.org/Fullscreen/yt),
document the changes in CHANGELOG.md and README.md, bump the version, then run

    rake release

Remember that the yt gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.0.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)

How to contribute
=================

Yt needs your support!
The goal of Yt is to provide a Ruby interface for all the methods exposed by
the [YouTube Data API (v3)](https://developers.google.com/youtube/v3) and by
the [YouTube Analytics API](https://developers.google.com/youtube/analytics).

If you find that a method is missing, fork the project, add the missing code,
write the appropriate tests, then submit a pull request, and it will gladly
be merged!

