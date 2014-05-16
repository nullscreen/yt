v0.5 - 2014/05/16
-----------------

* More complete custom exception Yt::Error, with code, body and curl
* Replace `:ignore_not_found` and `:ignore_duplicates` with `:ignore_errors`
* Allow resources to be initialized with a url, such as Yt::Resource.new url: 'youtube.com/fullscreen'
* Add `has_one :id` to resources, to retrieve the ID of resources initialized by URL
* Raise an error if some `has_one` associations are not found (id, snippet, details set, user info)
* Don't check for the right :scope if Account is initialized with credentials

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