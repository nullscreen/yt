v0.9 - 2014/07/28
-----------------

* [breaking change] Rename rating.update to rating.set
* Add content_owner.references to retrieve ContentID references
* Add content_owner.policies to list ContentID policies
* Let 'update' methods understand both under_score and camelCased parameters
* Add claim.third_party?
* Add actual_start_time, actual_end_time, scheduled_start_time, scheduled_end_time for live-streaming videos
* Add privacy_status, public_stats_viewable, publish_at to the options that Video#update accepts
* Allow angle brackets when editing title, description, tags and replace them with similar characters allowed by YouTube
* Correctly parse duration of videos longer than 24 hours

v0.8 - 2014/07/18
-----------------

* [breaking change] channel.subscribe returns nil (not raise an error) when trying to subscribe to your own channel
* Add all the status fields to Video (upload status, failure reason, rejection reason, scheduled time, license, embeddable, public stats viewable)
* Add content_owner.claims to list the claims administered by a content owner.
* Allow content_owner.claims to be chained with .where, such as in account.videos.where(q: 'query')
* Add account.content_owners to list content owners associated with an account
* Add video.delete

v0.7 - 2014/06/18
-----------------

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

v0.6 - 2014/06/05
-----------------

* [breaking change] Rename Channel#earning to Channel#earnings_on
* [breaking change] Account#videos shows *all* videos owned by account (public and private)
* Add the .status association to *every* type of resource (Channel, Video, Playlist)
* Allow account.videos to be chained with .where, such as in account.videos.where(q: 'query')
* Retry request once when YouTube times out
* Handle annotations with "never" as the timestamp, without text, singleton positions, of private videos
* New methods for Video: hd?, stereoscopic?, captioned?, licensed?

v0.5 - 2014/05/16
-----------------

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

v0.4 - 2014/05/09
--------------------

* Complete rewrite, using ActiveSupport and separating models and collections
* New methods to handle annotations, details sets
* Supports also ActiveSupport 3 and Ruby 1.9.3 (not just AS4 + Ruby 2)
* Fix parsing annotation and timestamps longer than 1 hour
* Fix delegating tags from resources to snippets
* Two options to add videos to a playlist: fail or not if a video is missing or its account terminated
* Allow to configure Yt credentials through environment variables
* When updating a playlist, only changes the specified attributes

v0.3.0 - 2014/04/16
--------------------

* New and improved methods to handle subscriptions, playlists, playlist items
* `find_or_create_playlist_by` does not yield a block anymore
* `account.subscribe_to!` raises error in case of duplicate subscription, but `account.subscribe_to` does not

v0.2.1 - 2014/04/10
--------------------

* `account.subscribe_to!` does not raise error in case of duplicate subscription
* Accountable objects can be initialized with the OAuth access token if there's no need to get a fresh one with a refresh token

v0.2.0 - 2014/04/09
--------------------

* Replaced `account.perform!` with `account.like!`, `account.subscribe_to!`
* Added `account.add_to!` to add a video to an account’s playlist
* Added `account.find_or_create_playlist_by` to find or create an account’s playlist

v0.1.1 - 2014/04/09
--------------------

* Added support for Ruby 2.0.0

v0.1.0  - 2014/04/08
--------------------

* Support for authenticated resources: Youtube accounts and Google accounts
* Support for public Youtube resources: channels and videos
* Available actions for authenticated Youtube accounts: like a video, subscribe to a channel