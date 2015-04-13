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

How to install
==============

To install on your system, run

    gem install yt

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'yt', '~> 0.14.3'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Yt is released.

Available resources
===================

Yt::Account
-----------

Use [Yt::Account](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Account) to:

* authenticate as a YouTube account
* read the attributes of the account
* access the channel managed by the account
* access the videos uploaded by the account
* create playlist
* upload a video
* list the channels subscribed to an account

```ruby
# Accounts can be initialized with access token, refresh token or an authorization code
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'

account.email #=> .. your e-mail address..
account.channel #=> #<Yt::Models::Channel @id=...>

account.videos.count #=> 12
account.videos.first #=> #<Yt::Models::Video @id=...>

account.upload_video 'my_video.mp4', title: 'My new video', privacy_status: 'private', category_id: 17
account.upload_video 'http://example.com/remote.m4v', title: 'My other video', tags: ['music']

account.create_playlist title: 'New playlist', privacy_status: 'unlisted' #=> true

account.subscribers.count #=> 2
account.subscribers.first #=> #<Yt::Models::Channel @id=...>
account.subscribers.first.title #=> 'Fullscreen'

```

*The methods above require to be authenticated as a YouTube account (see below).*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'

account.content_owners.count #=> 3
account.content_owners.first #=>  #<Yt::Models::ContentOwner @id=...>
```

*The methods above require to be authenticated as a YouTube Content Partner account (see below).*

Yt::ContentOwner
----------------

Use [Yt::ContentOwner](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/ContentOwner) to:

* authenticate as a YouTube content owner
* list the channels partnered with a YouTube content owner
* list the claims administered by the content owner
* list and delete the references administered by the content owner
* list the policies and policy rules administered by the content owner
* create assets

```ruby
# Content owners can be initialized with access token, refresh token or an authorization code
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'

content_owner.partnered_channels.count #=> 12
content_owner.partnered_channels.map &:title #=> ["Fullscreen", "Best of Fullscreen", ...]
content_owner.partnered_channels.where(part: 'statistics').map &:subscriber_count #=> [136925, 56945, ...]
content_owner.partnered_channels.includes(:viewer_percentages).map &:viewer_percentages #=> [{female: {'18-24' => 12.12,…}…}, {female: {'18-24' => 40.12,…}…}, …]


content_owner.claims.where(q: 'Fullscreen').count #=> 24
content_owner.claims.first #=> #<Yt::Models::Claim @id=...>
content_owner.claims.first.video_id #=> 'MESycYJytkU'
content_owner.claims.first.status #=> "active"

reference = content_owner.references.where(asset_id: "ABCDEFG").first #=> #<Yt::Models::Reference @id=...>
reference.delete #=> true

content_owner.policies.first #=> #<Yt::Models::Policy @id=...>
content_owner.policies.first.name #=> "Track in all countries"
content_owner.policies.first.rules.first #=> #<Yt::Models::PolicyRule @id=...>
content_owner.policies.first.rules.first.action #=> "monetize"
content_owner.policies.first.rules.first.included_territories #=> ["US", "CA"]

content_owner.create_asset type: 'web' #=> #<Yt::Models::Asset @id=...>
```

*All the above methods require authentication (see below).*

Yt::Channel
-----------

Use [Yt::Channel](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Channel) to:

* read the attributes of a channel
* access the videos of a channel
* access the playlists of a channel
* access the channels that the channel is subscribed to
* subscribe to and unsubscribe from a channel
* delete playlists from a channel
* retrieve the daily earnings, views, comments, likes, dislikes, shares, subscribers gained/lost, estimated/average video watch and impressions of a channel by day
* retrieve the views and estimated minutes watched by traffic source
* retrieve the views and estimated minutes watched by playback location
* retrieve the views and estimated minutes watched by embedded player location
* retrieve the views and estimated minutes watched by video
* retrieve the views and estimated minutes watched by playlist
* retrieve the viewer percentage of a channel by gender and age group

```ruby
# Channels can be initialized with ID or URL
channel = Yt::Channel.new url: 'youtube.com/fullscreen'

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

channel.subscribed_channels.count #=> 132
channel.subscribed_channels.first #=> #<Yt::Models::Channel @id=...>
```

*The methods above do not require authentication.*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: account

channel.subscribed? #=> false
channel.subscribe #=> true
```

*The methods above require to be authenticated as a YouTube account (see below).*

```ruby
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
channel = Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: account

channel.delete_playlists title: 'New playlist' #=> [true]

channel.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}
channel.comments until: 2.days.ago #=> {Wed, 28 May 2014 => 9.0, Thu, 29 May 2014 => 4.0, …}
channel.likes from: 8.days.ago #=> {Tue, 27 May 2014 => 7.0, Wed, 28 May 2014 => 0.0, …}
channel.dislikes to: 2.days.ago #=> {Tue, 27 May 2014 => 0.0, Wed, 28 May 2014 => 1.0, …}
channel.shares since: 7.days.ago, until: 7.days.ago  #=> {Wed, 28 May 2014 => 3.0}
channel.subscribers_gained from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
channel.subscribers_lost from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
channel.favorites_added from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
channel.favorites_removed from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
channel.estimated_minutes_watched #=> {Sun, 22 Feb 2015=>2433258.0, Mon, 23 Feb 2015=>2634360.0, …}
channel.average_view_duration #=>  {Sun, 22 Feb 2015=>329.0, Mon, 23 Feb 2015=>326.0, …}
channel.average_view_percentage # {Sun, 22 Feb 2015=>38.858253094977265, Mon, 23 Feb 2015=>37.40014235438217, …}
channel.viewer_percentages #=> {female: {'18-24' => 12.12, '25-34' => 16.16,…}…}
channel.viewer_percentage(gender: :male) #=> 49.12

channel.views since: 7.days.ago, by: :traffic_source #=> {advertising: 10.0, related_video: 20.0, promoted: 5.0, subscriber: 1.0, channel: 3.0, other: 7.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :traffic_source #=> {annotation: 10.0, external_app: 20.0, external_url: 5.0, embedded: 1.0, search: 3.0}

channel.views since: 7.days.ago, by: :playback_location #=> {embedded: 34.0, watch: 467.0, channel: 462.0, other: 3.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :playback_location #=> {embedded: 34.0, watch: 467.0, channel: 462.0, other: 3.0}

channel.views since: 7.days.ago, by: :embedded_player_location #=> {"fullscreen.net"=>45.0, "linkedin.com"=>5.0, "mashable.com"=>1.0, "unknown"=>1.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :embedded_player_location #=> {"fullscreen.net"=>45.0, "linkedin.com"=>5.0, "mashable.com"=>1.0, "unknown"=>1.0}

channel.views since: 7.days.ago, by: :video #=> {#<Yt::Models::Video @id=...>: 10.0, #<Yt::Models::Video @id=...>: 20.0, …}
channel.estimated_minutes_watched since: 7.days.ago, by: :video #=> {#<Yt::Models::Video @id=...>: 10.0, #<Yt::Models::Video @id=...>: 20.0, …}

channel.views since: 7.days.ago, by: :playlist #=> {#<Yt::Models::Playlist @id=...>: 10.0, #<Yt::Models::Playlist @id=...>: 20.0, …}
channel.estimated_minutes_watched since: 7.days.ago, by: :playlist #=> {#<Yt::Models::Playlist @id=...>: 10.0, #<Yt::Models::Playlist @id=...>: 20.0, …}
```

*The methods above require to be authenticated as the channel’s account (see below).*

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
channel.subscribers_gained from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
channel.subscribers_lost from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
channel.estimated_minutes_watched #=> {Sun, 22 Feb 2015=>2433258.0, Mon, 23 Feb 2015=>2634360.0, …}
channel.average_view_duration #=>  {Sun, 22 Feb 2015=>329.0, Mon, 23 Feb 2015=>326.0, …}
channel.average_view_percentage # {Sun, 22 Feb 2015=>38.858253094977265, Mon, 23 Feb 2015=>37.40014235438217, …}
channel.viewer_percentages #=> {female: {'18-24' => 12.12, '25-34' => 16.16,…}…}
channel.viewer_percentage(gender: :female) #=> 49.12
channel.views since: 7.days.ago, by: :traffic_source #=> {advertising: 10.0, related_video: 20.0, promoted: 5.0, subscriber: 1.0, channel: 3.0, other: 7.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :traffic_source #=> {annotation: 10.0, external_app: 20.0, external_url: 5.0, embedded: 1.0, search: 3.0}
channel.views since: 7.days.ago, by: :playback_location #=> {embedded: 34.0, watch: 467.0, channel: 462.0, other: 3.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :playback_location #=> {embedded: 34.0, watch: 467.0, channel: 462.0, other: 3.0}
channel.views since: 7.days.ago, by: :embedded_player_location #=> {"fullscreen.net"=>45.0, "linkedin.com"=>5.0, "mashable.com"=>1.0, "unknown"=>1.0}
channel.estimated_minutes_watched since: 7.days.ago, by: :embedded_player_location #=> {"fullscreen.net"=>45.0, "linkedin.com"=>5.0, "mashable.com"=>1.0, "unknown"=>1.0}
channel.views since: 7.days.ago, by: :video #=> {#<Yt::Models::Video @id=...>: 10.0, #<Yt::Models::Video @id=...>: 20.0, …}
channel.estimated_minutes_watched since: 7.days.ago, by: :video #=> {#<Yt::Models::Video @id=...>: 10.0, #<Yt::Models::Video @id=...>: 20.0, …}
channel.views since: 7.days.ago, by: :playlist #=> {#<Yt::Models::Playlist @id=...>: 10.0, #<Yt::Models::Playlist @id=...>: 20.0, …}
channel.estimated_minutes_watched since: 7.days.ago, by: :playlist #=> {#<Yt::Models::Playlist @id=...>: 10.0, #<Yt::Models::Playlist @id=...>: 20.0, …}
channel.monetized_playbacks_on 5.days.ago #=> 123.0

channel.content_owner #=> 'CMSname'
channel.linked_at #=> Wed, 28 May 2014
```

*The methods above require to be authenticated as the channel’s content owner (see below).*

Yt::Video
-----------

Use [Yt::Video](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Video) to:

* read the attributes of a video
* update the attributes of a video
* upload a thumbnail for a video
* access the annotations of a video
* delete a video
* like and dislike a video
* retrieve the daily earnings, views, comments, likes, dislikes, shares, subscribers gained/lost, impressions and monetized playbacks of a video by day
* retrieve the views of a video by traffic source
* retrieve the views of a video by playback location
* retrieve the views of a video by embedded player location
* retrieve the viewer percentage of a video by gender and age group
* retrieve data about live-streaming videos
* retrieve the advertising options of a video

```ruby
# Videos can be initialized with ID or URL
video = Yt::Video.new url: 'http://youtu.be/MESycYJytkU'

video.title #=> "Fullscreen Creator Platform"
video.description #=> "The new Fullscreen Creator Platform gives creators and brands a suite..."
video.description.has_link_to_channel? #=> true
video.thumbnail_url #=> "https://i1.ytimg.com/vi/MESycYJytkU/default.jpg"
video.published_at #=> 2013-07-09 16:27:32 UTC
video.tags #=> []
video.channel_id #=> "UCxO1tY8h1AhOz0T4ENwmpow"
video.channel_title #=> "Fullscreen"
video.category_id #=> "22"
video.live_broadcast_content #=> "none"

video.public? #=> true
video.uploaded? #=> false
video.rejected? #=> false
video.failed? #=> true
video.processed? #=> false
video.deleted? #=> false
video.uses_unsupported_codec? #=> true
video.has_failed_conversion? #=> false
video.empty? #=> false
video.invalid? #=> false
video.too_small? #=> false
video.aborted? #=> false
video.claimed? #=> false
video.infringes_copyright? #=> false
video.duplicate? #=> false
video.inappropriate? #=> false
video.too_long? #=> false
video.violates_terms_of_use? #=> false
video.infringes_trademark? #=> false
video.belongs_to_closed_account? #=> false
video.belongs_to_suspended_account? #=> false
video.scheduled? #=> true
video.scheduled_at #=> Tue, 27 May 2014 12:50:00
video.licensed_as_creative_commons? #=> true
video.licensed_as_standard_youtube? #=> false
video.embeddable? #=> false
video.has_public_stats_viewable? #=> false

video.duration #=> 86
video.hd? #=> true
video.stereoscopic? #=> false
video.captioned? #=> true
video.licensed? #=> false

video.actual_start_time #=> Tue, 27 May 2014 12:50:00
video.actual_end_time #=> Tue, 27 May 2014 12:54:00
video.scheduled_start_time #=> Tue, 27 May 2014 12:49:00
video.scheduled_end_time #=> Tue, 27 May 2014 12:55:00
video.concurrent_viewers #=> 0

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
account = Yt::Account.new access_token: 'ya29.1.ABCDEFGHIJ'
video = Yt::Video.new id: 'MESycYJytkU', auth: account

video.update title: 'A title', description: 'A description <with angle brackets>'
video.update tags: ['a tag'], categoryId: '21', license: 'creativeCommon'

video.upload_thumbnail 'my_thumbnail.jpg'
video.upload_thumbnail 'http://example.com/remote.png'

video.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}
video.comments until: 2.days.ago #=> {Wed, 28 May 2014 => 9.0, Thu, 29 May 2014 => 4.0, …}
video.likes from: 8.days.ago #=> {Tue, 27 May 2014 => 7.0, Wed, 28 May 2014 => 0.0, …}
video.dislikes to: 2.days.ago #=> {Tue, 27 May 2014 => 0.0, Wed, 28 May 2014 => 1.0, …}
video.shares since: 7.days.ago, until: 7.days.ago  #=> {Wed, 28 May 2014 => 3.0}
video.subscribers_gained from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
video.subscribers_lost from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
video.favorites_added from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
video.favorites_removed from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
video.average_view_duration #=>  {Sun, 22 Feb 2015=>329.0, Mon, 23 Feb 2015=>326.0, …}
video.average_view_percentage # {Sun, 22 Feb 2015=>38.858253094977265, Mon, 23 Feb 2015=>37.40014235438217, …}
video.estimated_minutes_watched #=> {Sun, 22 Feb 2015=>2433258.0, Mon, 23 Feb 2015=>2634360.0, …}
video.viewer_percentages #=> {female: {'18-24' => 12.12, '25-34' => 16.16,…}…}
video.viewer_percentage(gender: :female) #=> 49.12

video.views since: 7.days.ago, by: :traffic_source #=> {advertising: 10.0, related_video: 20.0, promoted: 5.0, subscriber: 1.0, channel: 3.0, other: 7.0}
video.views since: 7.days.ago, by: :playback_location #=> {:embedded=>6.0, :watch=>11.0}
video.views since: 7.days.ago, by: :embedded_player_location #=> {"fullscreen.net"=>45.0, "linkedin.com"=>5.0, "mashable.com"=>1.0, "unknown"=>1.0}

video.delete #=> true
```

*The methods above require to be authenticated as the video’s owner (see below).*

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
video = Yt::Video.new id: 'MESycYJytkU', auth: content_owner

video.earnings_on 5.days.ago #=> 12.23
video.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}
video.comments until: 2.days.ago #=> {Wed, 28 May 2014 => 9.0, Thu, 29 May 2014 => 4.0, …}
video.likes from: 8.days.ago #=> {Tue, 27 May 2014 => 7.0, Wed, 28 May 2014 => 0.0, …}
video.dislikes to: 2.days.ago #=> {Tue, 27 May 2014 => 0.0, Wed, 28 May 2014 => 1.0, …}
video.shares since: 7.days.ago, until: 7.days.ago  #=> {Wed, 28 May 2014 => 3.0}
video.subscribers_gained from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
video.subscribers_lost from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
video.favorites_added from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>1.0, Sun, 31 Aug 2014=>0.0}
video.favorites_removed from: '2014-08-30', to: '2014-08-31' #=> {Sat, 30 Aug 2014=>0.0, Sun, 31 Aug 2014=>0.0}
video.average_view_duration #=>  {Sun, 22 Feb 2015=>329.0, Mon, 23 Feb 2015=>326.0, …}
video.average_view_percentage # {Sun, 22 Feb 2015=>38.858253094977265, Mon, 23 Feb 2015=>37.40014235438217, …}
video.estimated_minutes_watched #=> {Sun, 22 Feb 2015=>2433258.0, Mon, 23 Feb 2015=>2634360.0, …}
video.impressions_on 5.days.ago #=> 157.0
video.monetized_playbacks_on 5.days.ago #=> 123.0

video.viewer_percentages #=> {female: {'18-24' => 12.12, '25-34' => 16.16,…}…}
video.viewer_percentage(gender: :female) #=> 49.12

video.views since: 7.days.ago, by: :traffic_source #=> {advertising: 10.0, related_video: 20.0, promoted: 5.0, subscriber: 1.0, channel: 3.0, other: 7.0}
video.views since: 7.days.ago, by: :playback_location #=> {:embedded=>6.0, :watch=>11.0}

video.ad_formats #=> ["standard_instream", "trueview_instream"]
```

*The methods above require to be authenticated as the video’s content owner (see below).*

Yt::Playlist
------------

Use [Yt::Playlist](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Playlist) to:

* read the attributes of a playlist
* update the attributes of a playlist
* access the items of a playlist
* add one or multiple videos to a playlist
* delete items from a playlist
* retrieve the views, playlist starts, average time in playlist and views per playlist start of a playlist by day

```ruby
# Playlists can be initialized with ID or URL
playlist = Yt::Playlist.new url: 'youtube.com/playlist?list=PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc'

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
playlist.update title: 'A <title> with angle brackets', description: 'desc', tags: ['new tag'], privacy_status: 'private'
playlist.add_video 'MESycYJytkU', position: 2
playlist.add_videos ['MESycYJytkU', 'MESycYJytkU']
playlist.delete_playlist_items title: 'Fullscreen Creator Platform' #=> [true]

playlist.views_on 5.days.ago #=> 12.0
playlist.views since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}

playlist.playlist_starts_on 5.days.ago #=> 12.0
playlist.playlist_starts since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}

playlist.average_time_in_playlist_on 5.days.ago #=> 12.0
playlist.average_time_in_playlist since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}

playlist.views_per_playlist_start_on 5.days.ago #=> 12.0
playlist.views_per_playlist_start since: 7.days.ago #=> {Wed, 28 May 2014 => 12.0, Thu, 29 May 2014 => 3.0, …}

```

*The methods above require to be authenticated as the playlist’s owner (see below).*

Yt::PlaylistItem
----------------

Use [Yt::PlaylistItem](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/PlaylistItem) to:

* read the attributes of a playlist item
* update the position of an item inside a playlist
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
item.update position: 3 #=> true
item.delete #=> true
```

*The methods above require to be authenticated as the playlist’s owner (see below).*


Yt::Collections::Videos
-----------------------

Use [Yt::Collections::Videos](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Collections/Videos) to:

* search for videos

```ruby
videos = Yt::Collections::Videos.new
videos.where(order: 'viewCount').first.title #=>  "PSY - GANGNAM STYLE"
videos.where(q: 'Fullscreen CreatorPlatform', safe_search: 'none').size #=> 324
videos.where(chart: 'mostPopular', video_category_id: 44).first.title #=> "SINISTER - Trailer"
videos.where(id: 'MESycYJytkU,invalid').map(&:title) #=> ["Fullscreen Creator Platform"]
```

*The methods above do not require authentication.*


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

Yt::MatchPolicy
---------------

Use [Yt::MatchPolicy](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/MatchPolicy) to:

* update the policy used by an asset

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
match_policy = Yt::MatchPolicy.new asset_id: 'ABCD12345678', auth: content_owner
match_policy.update policy_id: 'aBcdEF6g-HJ' #=> true
```

Yt::Asset
---------

Use [Yt::Asset](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Asset) to:

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

Yt::Claim
---------

Use [Yt::Claim](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Claim) to:

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
```

*The methods above require to be authenticated as the video’s content owner (see below).*

Yt::Ownership
-------------

Use [Yt::Ownership](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/Ownership) to:

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

Use [Yt::AdvertisingOptionsSet](http://rubydoc.info/github/Fullscreen/yt/master/Yt/Models/AdvertisingOptionsSet) to:

* update the advertising settings of a video

```ruby
content_owner = Yt::ContentOwner.new owner_name: 'CMSname', access_token: 'ya29.1.ABCDEFGHIJ'
ad_options = Yt::AdvertisingOptionsSet.new video_id: 'MESycYJytkU', auth: $content_owner
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

Why you should use Yt…
======================

… and not [youtube_it](https://github.com/kylejginavan/youtube_it)?
Because youtube_it does not support YouTube API V3, and the YouTube API V2 has
been [officially deprecated as of March 4, 2014](https://developers.google.com/youtube/2.0/developers_guide_protocol_audience).
If you need help upgrading your code, check [YOUTUBE_IT.md](https://github.com/Fullscreen/yt/blob/master/YOUTUBE_IT.md),
a step-by-step comparison between youtube_it and Yt to make upgrade easier.

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

How to contribute
=================

Yt needs your support!
The goal of Yt is to provide a Ruby interface for all the methods exposed by
the [YouTube Data API (v3)](https://developers.google.com/youtube/v3) and by
the [YouTube Analytics API](https://developers.google.com/youtube/analytics).

If you find that a method is missing, fork the project, add the missing code,
write the appropriate tests, then submit a pull request, and it will gladly
be merged!

Don’t hesitate to send code comments, issues or pull requests through GitHub
and to spread the love on Twitter by following [@ytgem](https://twitter.com/intent/user?screen_name=ytgem) – 
all feedback is appreciated.

![yt4](https://cloud.githubusercontent.com/assets/7408595/3638115/0ef9d6bc-1037-11e4-831a-787204e9b979.png)
