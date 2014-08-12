# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.10.1 - 2014-08-11

* [BUGFIX] Make Yt work on Ruby 1.9.3 / ActiveSupport 3.0 again (was broken by 0.10.0)

## 0.10.0 - 2014-08-11

**How to upgrade**

If your code never calls the `size` method to count how many items a list of
results has (e.g., how many videos an account has), then you are good to go.

If it does, then be aware that `size` will now return try to the number of
items as specified in the "totalResults" field of the first page of the YouTube
response, rather than loading *all* the pages (possibly thousands) and counting
exactly how many items are returned.

If this is acceptable, then you are good to go.
If you want the old behavior, replace `size` with `count`:

```ruby
account = Yt::Account.new access_token: 'ya29...'
# old behavior
account.videos.size # => retrieved *all* the pages of the account’s videos
# new behavior
account.videos.size # => retrieves only the first page, returning the totalResults counter
account.videos.count # => retrieves *all* the pages of the account’s videos
```

* [ENHANCEMENT] Calling `size` on a collection does not load all the pages of the collection
* [ENHANCEMENT] Alias `policy.time_updated` to more coherent `policy.updated_at`

## 0.9.8 - 2014-08-11

* [FEATURE] Add `.content_owner` and `.linked_at` to channels managed by a CMS content owner

## 0.9.7 - 2014-08-02

* [BUGFIX] Correctly parse videos’ duration for videos longer than 24 hours

## 0.9.6 - 2014-08-02

* [ENHANCEMENT] Accept angle brackets characters in videos’ and playlists’ metadata

## 0.9.5 - 2014-08-02

* [FEATURE] Allow status attributes of a video to be updated

`video.update` now accepts three new attributes: `privacy_status`,
`public_stats_viewable` and `publish_at`.

## 0.9.4 - 2014-08-02

* [FEATURE] Expose metadata for live-streaming videos

New method are now available for `Video` instance to check their live-streaming
details: `actual_start_time`, `actual_end_time`, `scheduled_start_time`,
`scheduled_end_time` and `concurrent_viewers`.

## 0.9.3 - 2014-07-30

* [BUGFIX] Don’t cache `.where` conditions on multiple calls

For instance, invoking `account.videos.where(q: 'x').count` followed by
`account.videos.count` used to return the same result, because the `where`
conditions of the first request were wrongly kept for the successive request.

* [FEATURE] Check if a ContentID claim is third-party with `claim.third_party?`
* [ENHANCEMENT] `update` methods accept both underscore and camel-case attributes

For instance, either of the following syntaxes can now be used:
`video.update categoryId: "22"` or `video.update category_id: "22"`.

## 0.9.2 - 2014-07-29

* [FEATURE] List ContentID policies with `content_owner.policies`

## 0.9.1 - 2014-07-28

* [FEATURE] List ContentID references with `content_owner.references`
* [ENHANCEMENT] `playlist.update` accepts both `privacyStatus` and `privacy_status`

For instance, either of the following syntaxes can now be used:
`playlist.update privacyStatus: "unlisted"` or
`playlist.update privacy_status: "unlisted"`.

## 0.9.0 - 2014-07-28

**How to upgrade**

If your code never declares instances of `Yt::Rating`, or never calls the
`update` method on them, then you are good to go.

If it does, then *simply replace `update` with `set`*:

```ruby
rating = Yt::Rating.new
# old syntax
rating.update :like
# new syntax
rating.set :like
```

* [ENHANCEMENT] `rating.set` replaces `rating.update` to rate a video

## 0.8.5 - 2014-07-28

* [FEATURE] Delete a video with `video.delete`

## 0.8.4 - 2014-07-24

* [BUGFIX] Correctly parse annotations with timestamp written as `t='0'`

## 0.8.3 - 2014-07-24

* [FEATURE] List content owners managed by an account with `account.content_owners`

## 0.8.2 - 2014-07-23

* [FEATURE] List ContentID claims administered by a content owner with `content_owner.claims`

## 0.8.1 - 2014-07-22

* [FEATURE] Include all the video-related status information in `video.status`

New method are now available for `Video` instance to check their status
information: `public?`, `uploaded?`, `rejected?`, `failed?`, `processed?`,
`deleted?`, `uses_unsupported_codec?`, `has_failed_conversion?`, `empty?`,
`invalid?`, `too_small?`, `aborted?`, `claimed?`, `infringes_copyright?`,
`duplicate?`, `inappropriate?`, `too_long?`, `belongs_to_closed_account?`,
`infringes_trademark?`, `violates_terms_of_use?`, `has_public_stats_viewable?`,
`belongs_to_suspended_account?`, `scheduled?`, `scheduled_at`, `embeddable?`
`licensed_as_creative_commons?` and `licensed_as_standard_youtube?`.

## 0.8.0 - 2014-07-19

**How to upgrade**

If your code never declares instances of `Yt::Channel`, or never calls the
`subscribe` method on them, then you are good to go.

If it does, then be aware that `subscribe` will not raise an error anymore if
a YouTube user tries to subscribe to her/his own YouTube channel. Instead,
`subscribe` will simply return `nil`.

If this is acceptable, then you are good to go.
If you want the old behavior, replace `subscribe` with `subscribe!`:

```ruby
account = Yt::Account.new access_token: 'ya29...'
channel = account.channel
# old behavior
channel.subscribe # => raised an error
# new behavior
channel.subscribe # => nil
channel.subscribe! # => raises an error
```

* [ENHANCEMENT] `channel.subscribe` does not raise error when trying to subscribe to one’s own channel

## 0.7 - 2014/06/18

* [breaking change] Rename DetailsSet to ContentDetail
* Add statistics_set to Video (views, likes, dislikes, favorites, comments)
* Add statistics_set to Channel (views, comments, videos, subscribers)
* More snippet methods for Video (channel_id, channel_title, category_id, live_broadcast_content)
* More snippet methods for Playlist (channel_id, channel_title)
* More snippet methods for PlaylistItem (channel_id, channel_title, playlist_id, video_id)
* More status methods for PlaylistItem (privacy_status, public?, private?, unlisted?)
* Add video.update to update title, description, tags and categoryId of a video
* Sort channel.videos by most recent first
* Extract Reports (earnings, views) into module with macro `has_report`
* New channel reports: comments, likes, dislikes, shares and impressions
* Allow both normal and partnered channels to retrieve reports about views, comments, likes, dislikes, shares
* Make reports available also on Video (not just Channel)
* New account.upload_video to upload a video (either local or remote).
* Make channel.videos access more than 500 videos per channel
* Add viewer percentage (age group, gender) to Channel and Video reports

## 0.6 - 2014/06/05

* [breaking change] Rename Channel#earning to Channel#earnings_on
* [breaking change] Account#videos shows *all* videos owned by account (public and private)
* Add the .status association to *every* type of resource (Channel, Video, Playlist)
* Allow account.videos to be chained with .where, such as in account.videos.where(q: 'query')
* Retry request once when YouTube times out
* Handle annotations with "never" as the timestamp, without text, singleton positions, of private videos
* New methods for Video: hd?, stereoscopic?, captioned?, licensed?

## 0.5 - 2014/05/16

* More complete custom exception Yt::Error, with code, body and curl
* Replace `:ignore_not_found` and `:ignore_duplicates` with `:ignore_errors`
* Allow resources to be initialized with a url, such as Yt::Resource.new url: 'youtube.com/fullscreen'
* Add `has_one :id` to resources, to retrieve the ID of resources initialized by URL
* Raise an error if some `has_one` associations are not found (id, snippet, details set, user info)
* Don't check for the right :scope if Account is initialized with credentials
* Move models in Yt::Models but still auto-include them in the main namespace
* New Authentication model to separate `access_token` and `refresh_token` from Account
* New types of Errors that render more verbose errors and the failing request in cURL syntax
* Separate Error class for 500 error, so they can be easily found in app logs
* New Earning collection to retrieve estimated earning for YouTube-partnered channels
* Rename error classes so they match the corresponding Net::HTTP errors (e.g. Unauthorized)
* Separate Error class for 403 Error
* Retry once YouTube earning queries that return error 400 "Invalid query. Query did not conform to the expectations"
* Update RSpec to 3.0 (only required in development/testing)
* New ContentOwner subclass of Account with access to partnered channels
* Automatically refresh the access token when it expires or becomes invalid
* Retry once YouTube earning queries that return error 503
* Wait 3 seconds and retry *every* request that returns 500, 503 or 400 with "Invalid query"
* New Views collection to retrieve view count for YouTube-partnered channels

## 0.4 - 2014/05/09

* Complete rewrite, using ActiveSupport and separating models and collections
* New methods to handle annotations, details sets
* Supports also ActiveSupport 3 and Ruby 1.9.3 (not just AS4 + Ruby 2)
* Fix parsing annotation and timestamps longer than 1 hour
* Fix delegating tags from resources to snippets
* Two options to add videos to a playlist: fail or not if a video is missing or its account terminated
* Allow to configure Yt credentials through environment variables
* When updating a playlist, only changes the specified attributes

## 0.3.0 - 2014/04/16

* New and improved methods to handle subscriptions, playlists, playlist items
* `find_or_create_playlist_by` does not yield a block anymore
* `account.subscribe_to!` raises error in case of duplicate subscription, but `account.subscribe_to` does not

## 0.2.1 - 2014/04/10

* `account.subscribe_to!` does not raise error in case of duplicate subscription
* Accountable objects can be initialized with the OAuth access token if there's no need to get a fresh one with a refresh token

## 0.2.0 - 2014/04/09

* Replaced `account.perform!` with `account.like!`, `account.subscribe_to!`
* Added `account.add_to!` to add a video to an account’s playlist
* Added `account.find_or_create_playlist_by` to find or create an account’s playlist

## 0.1.1 - 2014/04/09

* Added support for Ruby 2.0.0

## 0.1.0  - 2014/04/08

* Support for authenticated resources: Youtube accounts and Google accounts
* Support for public Youtube resources: channels and videos
* Available actions for authenticated Youtube accounts: like a video, subscribe to a channel