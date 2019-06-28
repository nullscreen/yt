# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.32.4 - 2019-06-26

* [FEATURE] Add `ownership_effective` method to access asset ownership ("effective") via the asset object.
* [FEATURE] List content owners of others with `content_owner.content_owners`
* [FEATURE] Add `match_info` to insert claim request.
* [FEATURE] Add `upload_reference_file` method for Reference file upload (thank you @jcohenho)
* [FEATURE] Get one asset [by request](https://developers.google.com/youtube/partner/docs/v1/assets/get) (thank you @jcohenho)
* [FEATURE] Add `update` method to Yt::Claim (thank you @jcohenho)

## 0.32.3 - 2019-03-15

* [ENHANCEMENT] Add `Yt::URL` to get id, kind, and its resource (channel, video, playlist)
* [BUGFIX] Fix `subscription.insert` by adding a parameter
* [FEATURE] Add `file_name` attribute to `Yt::FileDetail` model

## 0.32.2 - 2018-05-25

* Use YouTube Analytics API v2 instead of v1. See announcement of v1 deprecation
https://developers.google.com/youtube/analytics/revision_history#april-26-2018

## 0.32.1 - 2017-08-14

* [FEATURE] Add `Yt::ContentOwner#bulk_report_jobs`
* [FEATURE] Add `Yt::BulkReportJob#bulk_reports`

## 0.32.0 - 2017-07-05

**How to upgrade**

If your code is expecting data from `reports` methods to always include historical data (the data from the period before joining), now you have to set `historical: true` specifically. It will not include historical data by default.

* [IMPROVEMENT] Include historical data with `historical: true` option.

## 0.31.2 - 2017-06-29

* [BUGFIX] Return lifetime data correctly even when the channel joined content owner after a while since it's created.

## 0.31.1 - 2017-06-03

* [FEATURE] Add `by: :youtube_product` option for reports.
* [FEATURE] Add `Yt::Collections::Reports::YOUTUBE_PRODUCTS` to list all YouTube products (KIDS, GAMING, etc) supported by YouTube Analytics API.
* [FEATURE] Add more operating system dimensions to `Yt::Collections::Reports::OPERATING_SYSTEMS`.

## 0.31.0 - 2017-06-02

**How to upgrade**

If your code calls `.uniques` it should be removed because this metric has been
no longer supported by YouTube API as of [October 31, 2016](https://developers.google.com/youtube/analytics/revision_history#september-27-2016).

* [REMOVAL] Remove `#uniques` method for channels, videos and video groups.

## 0.30.1 - 2017-04-14

* [IMPROVEMENT] Retry 3 times if YouTube responds with 503 Backend Error

## 0.30.0 - 2017-03-17

**How to upgrade**

If your code uses `Yt::Models::Configuration` then you must use
`Yt::Configuration` instead.

Both `Yt::Configuration` and `Yt::Config` have been moved in a separate
gem called `yt-support` that is required by default by the `yt` gem.

* [REMOVAL] Remove `Yt::Models::Configuration` (renamed as `Yt::Configuration`)

## 0.29.1 - 2017-02-26

* [FEATURE] Add `Video#length` to show the duration as an ISO 8601 time.

## 0.29.0 - 2017-02-17

**How to upgrade**

If your code uses `Yt::URL` then you must include the `yt-url` gem, since
`Yt::URL` has been extracted into a separate repository.
Please read the documentation of `Yt::URL` and notice that the `subscription`
pattern has been dropped, so URLs such as the following will not be recognized
anymore: `subscription_center?add_user=...`, `subscribe_widget?p=...`.

Note that this also removes the option of initializing a resource by URL.
You can achieve the same result with the `yt-url` gem, as detailed in its
documentation.

Finally note that this also remove the class `Yt::Description`. This class
was private API, so this change should not affect developers.

* [REMOVAL] Remove the option to initialize resources by URL.
* [REMOVAL] Remove `Yt::Resource.username`
* [REMOVAL] Remove `Yt::URL` (extracted into separate gem)
* [REMOVAL] Remove `Yt::Description` (now simply a String).

## 0.28.5 - 2017-01-18

* [BUGFIX] Don't crash when Yt::VideoGroup is initialized with a group of playlists.

## 0.28.4 - 2017-01-18

* [BUGFIX] Don't crash when Yt::VideoGroup is initialized with a group of playlists.

## 0.28.3 - 2017-01-09

* [FEATURE] Add `VideoGroup#channels` method to load all channels under a group.

## 0.28.2 - 2017-01-09

* [FEATURE] Add `channel_url` to video.

## 0.28.1 - 2016-10-24

* [FEATURE] New `card impressions` report for video groups.
* [FEATURE] New `card clicks` report for video groups.
* [FEATURE] New `card click rate` report for video groups.
* [FEATURE] New `card teaser impressions` report for video groups.
* [FEATURE] New `card teaser clicks` report for video groups.
* [FEATURE] New `card teaser click rate` report for video groups.

## 0.28.0 - 2016-10-18

**How to upgrade**

If your code calls `.earnings` and `.impressions`
then you must replace that code  with `.estimated_revenue` and
`.ad_impressions` since those metrics will no longer be supported by
YouTube API as of [November 4, 2016](https://developers.google.com/youtube/analytics/revision_history#august-10-2016).

* [REMOVAL] Remove `#earnings` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#impressions` method for channels, videos and video groups
* [FEATURE] Add `#estimated_revenue` method for channels, videos and video groups
* [FEATURE] Add `#ad_impressions` method for channels, videos and video groups

## 0.27.0 - 2016-10-07

**How to upgrade**

If your code calls any of the following `..._on` method to fetch metrics on
a specific day, you need to replace it with the equivalent method that does
not end with `_on`. For instance replace `views_on(3.days.ago)` with the
equivalent `views(since: 3.days.ago, until: 3.days.ago)`.

* [REMOVAL] Remove `#views_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#uniques_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#estimated_minutes_watched_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#viewer_percentage_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#comments_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#likes_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#dislikes_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#shares_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#subscribers_gained_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#subscribers_lost_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#videos_added_to_playlists_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#videos_removed_from_playlists_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#average_view_duration_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#average_view_percentage_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#annotation_clicks_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#annotation_click_through_rate_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#annotation_close_rate_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_impressions_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_clicks_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_click_rate_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_teaser_impressions_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_teaser_clicks_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#card_teaser_click_rate_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#earnings_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#impressions_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#monetized_playbacks_on` method for channels, playlists, videos and video groups
* [REMOVAL] Remove `#playback_based_cpm_on` method for channels, playlists, videos and video groups

## 0.26.3 - 2016-10-07

* [FEATURE] Add `by: :subscribed_status` option for reports, to return views (from a `content_owner.video`) by subscribed status.
* [FEATURE] Add `Yt::Collections::Reports::SUBSCRIBED_STATUSES` to list all subscribed statuses supported by YouTube Analytics API.

## 0.26.2 - 2016-10-05

* [ENHANCEMENT] Add newly available traffic sources: "Campaign card" and "End screen"

## 0.26.1 - 2016-10-05

* [FEATURE] New `card impressions` report for videos and channels.
* [FEATURE] New `card clicks` report for videos and channels.
* [FEATURE] New `card click rate` report for videos and channels.
* [FEATURE] New `card teaser impressions` report for videos and channels.
* [FEATURE] New `card teaser clicks` report for videos and channels.
* [FEATURE] New `card teaser click rate` report for videos and channels.

## 0.26.0 - 2016-10-05

**How to upgrade**

If your code calls `.favorites_added` and `.favorites_removed` on channels and
videos then you must remove that code since those metrics are not anymore
supported by YouTube API.

* [REMOVAL] Remove deprecated `favorites_added` metric for channels, videos, and video groups.
* [REMOVAL] Remove deprecated `favorites_removed` metric for channels, videos, and video groups

## 0.25.40 - 2016-09-19

* [IMPROVEMENT] Add `Yt::Claim#data` to access the policy of a claim

## 0.25.39 - 2016-06-15

* [FEATURE] Add `by: :operating_system` option for reports, to return views (from a `content_owner.video`) by operating system.
* [FEATURE] Add `Yt::Collections::Reports::DEVICE_TYPES` to list all device types supported by YouTube Analytics API.
* [FEATURE] Add `Yt::Collections::Reports::OPERATING_SYSTEMS` to list all operating systems supported by YouTube Analytics API.

## 0.25.38 - 2016-06-13

* [IMPROVEMENT] Don’t combine forContentOwner and publishedBefore parameters in Search#list since YouTube does not support this anymore.

## 0.25.37  - 2016-05-16

* [FEATURE] Add `VideoGroup#videos` to load all videos under a group of channels, as well as a group of videos.

## 0.25.36  - 2016-05-10

* [BUGFIX] Raise RequestError when authentication code is "invalid" or "already redeemed"
* [FEATURE] Make two methods `#explanation` and `#response_body` public for `Yt::Errors::RequestError`

## 0.25.35  - 2016-04-27

* [BUGFIX] Don’t try to eager load more than 50 assets at the time from claims

## 0.25.34  - 2016-04-20

* [FEATURE] Add `ad_breaks` and `tp_ad_server_video_id` attribute to AdvertisingOptionsSet

## 0.25.33 - 2016-04-15

* [FEATURE] Eager-loading claims from videos will also eager-load assets.
* [FEATURE] New method - `Claim#source` will return the source of the claim.

## 0.25.32 - 2016-04-12

* [BUGFIX] Fix where videos did not eager load claims or categories in subsequent requests.

## 0.25.31 - 2016-04-11

* [BUGFIX] Don’t try to instantiate video.claim if a video does not have a claim.

## 0.25.30 - 2016-04-07

* [FEATURE] Add ability for videos to eager load claims. For example, `$content_owner.videos.includes(:claim).first.claim.id`.

## 0.25.29 - 2016-04-07

* [BUGFIX] Previously, Yt was throttling queries for `quotaExceeded` responses from YouTube. However, matching `quotaExceeded` was too specific and would not have caught other limit exceeding responses from YouTube. This change will allow Yt to throttle other responses that contains `Exceeded` or `exceeded`.

## 0.25.28 - 2016-04-05

* [BUGFIX] If no asset ID is set, calling ContentOwner#assets will now use the path, /youtube/partner/v1/assetSearch, instead of '/youtube/partner/v1/assets'

## 0.25.27 - 2016-03-28

* [FEATURE] Add `comment_threads` association to Yt::Video.
* [FEATURE] Add `top_level_comment` and delegate its attributes (`text_display`, `author_display_name`, `like_count`, `updated_at`) to Yt::CommentThread.

## 0.25.26 - 2016-03-24

* [FEATURE] Add Yt::Comment resource.

## 0.25.25 - 2016-03-24

* [FEATURE] Add Yt::CommentThread resource.

## 0.25.24 - 2016-03-02

* [BUGFIX] When `videos.where(..)` returns more than one page, don’t retain the items for the next request.

## 0.25.23 - 2016-02-23

* [IMPROVEMENT] Retry 3 times after a server error, to bypass temporary glitches by YouTube.
* [IMPROVEMENT] Don’t combine forMine and publishedBefore parameters in Search#list since YouTube does not support this anymore.

## 0.25.22 - 2016-02-04

* [IMPROVEMENT] Deal with channels with more than 500 videos in a better way

## 0.25.21 - 2016-02-04

* [BUGFIX] Add required 'require' to have `.with_indifferent_access` in geography

## 0.25.20 - 2016-01-24

* [FEATURE] Add (undocumented) playback location dimensions SEARCH and BROWSE

## 0.25.19 - 2016-01-15

* [FEATURE] Add `:group_items` to Yt::VideoGroup (list items of a group)
* [FEATURE] Add `:includes(:video)` to `Yt::VideoGroup#group_items` (eagerly loads all the videos)

## 0.25.18 - 2016-01-08

* [FEATURE] Add Yt::COUNTRIES and Yt::US_STATES
* [FEATURE] Add YouTube Analytics Video Groups
* [FEATURE] Add `:video_groups` to Yt::Account (list video-groups created by an account)
* [FEATURE] Add `:video_groups` to Yt::ContentOwner (list video-groups on behalf of a content owner)
* [FEATURE] Add reports by video-group

## 0.25.17 - 2016-01-05

* [FEATURE] Add `:videos` to Yt::ContentOwner to list videos in network with a content owner

## 0.25.16 - 2015-12-19

* [FEATURE] Add `access_token_was_refreshed` to Yt::Account

## 0.25.15 - 2015-12-17

* [FEATURE] Add `revoke_access` to Yt::Account

## 0.25.14 - 2015-12-16

* [ENHANCEMENT] Add `:display_name` to each content owner returned by account.content_owners
* [BUGFIX] Don’t raise error when raising MissingAuth without any scope

## 0.25.13 - 2015-12-04

* [BUGFIX] Fix previous fix to Video#update with publishAt (typo)

## 0.25.12 - 2015-12-03

* [BUGFIX] Fix Video#update with publishAt

## 0.25.11 - 2015-11-05

* [ENHANCEMENT] Add "youtube.com/v/..." as possible URL for YouTube videos
* [ENHANCEMENT] Add eager loading to channel.playlists

## 0.25.10 - 2015-10-29

* [FEATURE] Add Playlist#item_count

## 0.25.9 - 2015-10-07

* [ENHANCEMENT] Add newly available traffic source: "Playlist page"

## 0.25.8 - 2015-09-10

* [FEATURE] Retry the same request up to 3 times if YouTube responds with "quotaExceeded"

## 0.25.7 - 2015-09-10

* [FEATURE] Retry the same request once if YouTube responds with "quotaExceeded"

## 0.25.6 - 2015-09-03

* [FEATURE] New channel/video reports: `videos_added_to_playlists`, `videos_removed_from_playlists`.

## 0.25.5 - 2015-08-12

* [BUGIX] Correctly parse the YouTube response when requesting a refresh token with the wrong credentials.

## 0.25.4 - 2015-07-27

* [FEATURE] Add `channel.related_playlist` and `account.related_playlists` to access "Liked Videos", "Uploads", etc.

## 0.25.3 - 2015-07-23

* [BUGFIX] Don’t run an infinite loop when calling `.playlist_items.includes(:video)` on a playlist with only private or deleted videos

## 0.25.2 - 2015-07-22

* [FEATURE] Add .includes(:video) to .playlist_items to eager-load video data of a list of playlist items.

## 0.25.1 - 2015-07-06

* [ENHANCEMENT] `Yt::Video.new` accepts embedded video url.

## 0.25.0 - 2015-06-29

**How to upgrade**

If your code expects 10 videos when calling a report `by: :video` or
`by: :related_video`, beware that those reports now return 25 videos.
If you only need the first 10, just add `.first(10)` to your result.
For instance: `channel.views(by: :video).first(10).to_h`.

* [ENHANCEMENT] Return 25 results on reports by video / related video.
* [FEATURE] New `playback_based_cpm` report for channels and videos.

## 0.24.10 - 2015-06-25

* [BUGFIX] Don't break reports `by: :playlist` when trying to fetch their part by limiting to result to 50 playlists.

## 0.24.9 - 2015-06-19

* [BUGFIX] Let more than `max_results` videos be retrieved even when a `published_before` where condition is specified.

## 0.24.8 - 2015-06-18

* [FEATURE] New `by: :week` option for reports.
* [FEATURE] New Video#age_restricted? method

## 0.24.7 - 2015-06-08

* [ENHANCEMENT] Add `:videos` option to limit channel reports to subset of videos

## 0.24.6 - 2015-06-08

* [ENHANCEMENT] When grouping by day, return results in chronological order

## 0.24.5 - 2015-06-08

* [ENHANCEMENT] When grouping by device type, return results sorted by descending views

## 0.24.4 - 2015-06-05

* [ENHANCEMENT] When grouping by traffic source, country, state or playback location, return results sorted by descending views

## 0.24.3 - 2015-06-05

* [ENHANCEMENT] Add newly available traffic sources

## 0.24.1 - 2015-06-01

* [BUGFIX] Don't raise error when YouTube returns a deleted video while eager loading

## 0.24.0 - 2015-05-21

**How to upgrade**

If your code expects the `estimated_minutes_watched`
or the `average_view_duration` report to return a `Float`, beware that they now
return an `Integer` (since that is what YouTube returns).
In case you still need to parse a float, just append `.to_f` to the result.

* [ENHANCEMENT] Return Integer on `estimated_minutes_watched` reports
* [ENHANCEMENT] Return Integer on `average_view_duration` reports
* [FEATURE] New `by: :referrer` option for reports.

## 0.23.2 - 2015-05-20

* [FEATURE] Accept `:includes` in reports by video, related video and playlist to preload parts.

## 0.23.1 - 2015-05-19

* [FEATURE] New `by: :month` option for reports.
* [FEATURE] New `.reports` method to fetch multiple metrics at once.

## 0.23.0 - 2015-05-18

**How to upgrade**

If your code expects reports to return results **by day** then you **must** add
the `by: :day` option to your report method. The new default is `by: :range`.
For instance `channel.views` would return

  {Wed, 8 May 2014 => 12.4, Thu, 9 May 2014 => 3.2, Fri, 10 May 2014 => …}

and now returns the same as calling `channel.views by: :range`:

  {total: 3450}

Additionally, if you expect reports **by day** then you **must** specify the
`:since` option to your report method. Previously, this value was set to
`5.days.ago`, but now is required. `:until` still defaults to `Date.today`.

Finally, if you expect reports for the entire range, notice that the default
 `:since` option is now set to the date when YouTube opened. Therefore calling a
method like `channel.views` now returns the **lifetime** views of a channel.

* [ENHANCEMENT] Change default from `by: :day` to `by: :range`.
* [ENHANCEMENT] Require `:since` options for any report by day.
* [ENHANCEMENT] Change default range for reports by range to lifetime.

## 0.22.2 - 2015-05-15

* [FEATURE] New `by: :search_term` option for reports.
* [FEATURE] New `in: {state: 'XX'}` option to limit reports to a US state
* [FEATURE] New `uniques by: :day` report

## 0.22.1 - 2015-05-13

* [FEATURE] New `by: :country` option for channel, video and playlist reports
* [FEATURE] New `by: :state` option for channel, video and playlist reports
* [FEATURE] New `:in` option to limit reports to a country

## 0.22.0 - 2015-04-30

**How to upgrade**

If your code expects any of the following method to return Float values, then
be aware that they now return Integer. You can still call `to_f` if you do need
a Float: views, `comments`, `likes`, `dislikes`, `shares`, `subscribers_gained`,
`subscribers_lost`, `favorites_added`, `favorites_removed`, `annotations`,
`impressions`, `monetized_playbacks`, `playlist_starts`.

* [ENHANCEMENT] Return `Integer` values for reports that can never return decimal digits.
* [FEATURE] New `by: :range` option for reports, to return a metric without dimensions (that is, for the whole range)

## 0.21.0 - 2015-04-30

**How to upgrade**

If your code doesn’t use `PolicyRule#ACTIONS`, then you are good to go.
If it does, then you should redefine the constant in your own app.

* [REMOVAL] Remove `PolicyRule#ACTIONS` (was `%q(block monetize takedown track)`).
* [BUGFIX] Make `account.playlists` and `account.channel.playlists` behave the same.

## 0.20.0 - 2015-04-29

**How to upgrade**

If your code doesn’t use any of the following constants that were public but
undocumented, then you are good to go.

If it does, then you should redefine those constants in your own app, since
it’s not Yt’s goal to validate the values posted to YouTube API.

* [REMOVAL] Remove `Asset#STATUSES` (was `%q(active inactive pending)`).
* [REMOVAL] Remove `Claim#STATUSES` (was `%q(active appealed disputed inactive pending potential takedown unknown)`).
* [REMOVAL] Remove `Claim#CONTENT_TYPES` (was `%q(audio video audiovisual)`).
* [REMOVAL] Remove `Reference#STATUSES` (was `%q(activating active checking computing_fingerprint deleted duplicate_on_hold inactive live_streaming_processing urgent_reference_processing)`).
* [REMOVAL] Remove `Reference#CONTENT_TYPES` (was `%q(audio video audiovisual)`).
* [REMOVAL] Remove `Status#PRIVACY_STATUSES` (was `%q(private public unlisted)`).

## 0.19.0 - 2015-04-28

**How to upgrade**

If your code never calls `partnered_channels.includes(:viewer_percentages)` on
a Yt::ContentOwner, then you are good to go.

If it does, then be aware that viewer percentage is not eager-loaded anymore,
so the call above is equivalent to `partenered_channels`. The reason is that
viewer percentage *requires* a time-range, and using a default range of the
last 3 months can generate more confusion than added value.

Also if your code still uses the deprecated:

- `.viewer_percentages` method, replace with `.viewer_percentage`.
- `policy.time_updated` method, replace with `policy.updated_at`.
- `video.uploaded?` method, replace with `video.uploading?`.

* [REMOVAL] Remove `.includes(:viewer_percentages)` on `content_owner.partnered_channels`.
* [REMOVAL] Remove deprecated `viewer_percentages` (use `viewer_percentage` instead)
* [REMOVAL] Remove deprecated `policy.time_updated` (use `updated_at` instead)
* [REMOVAL] Remove deprecated `video.uploaded?` (use `uploading?` instead)

## 0.18.0 - 2015-04-28

**How to upgrade**

If your code never calls `public?`, `private?` or `unlisted?` on a Status
object, then you are good to go.

If it does, then call the same methods on the parent Resource object instead.
For instance, replace `video.status.private?` with `video.private?`.

* [ENHANCEMENT] Don’t over-delegate privacy status methods of Resource.

## 0.17.0 - 2015-04-28

**How to upgrade**

If your code never calls video-specific methods on `video.status`, then you are
good to go.

If it does, then call the same methods on `video`, rather than `video.status`.
For instance, replace `video.status.deleted?` with `video.deleted?`.

* [ENHANCEMENT] Don’t over-delegate methods of Video.
* [ENHANCEMENT] Complete documentation of Yt::Video.

## 0.16.0 - 2015-04-27

**How to upgrade**

If your code never calls `video.uploaded?`, then you are good to go.

If it does, then replace your calls with `video.uploading?`.
In fact, the YouTube constant `uploaded` identifies the status where a
video is **being uploaded**.

* [ENHANCEMENT] Rename `uploaded?` to `uploading?` to avoid confusion.

## 0.15.3 - 2015-04-27

* [FEATURE] New `file_size`, `file_type`, `container` methods for Yt::Video.
* [BUGFIX] Retrieve `category_id` also for videos obtained through a search.
* [FEATURE] Add .includes(:category) to .videos in order to eager-load category title and ID of a collection of videos

## 0.15.2 - 2015-04-27

* [FEATURE] New `embed_html` method for Yt::Video.

## 0.15.1 - 2015-04-19

* [FEATURE] New `annotation clicks` report for videos and channels.
* [FEATURE] New `annotation click-through rate` report for videos and channels.
* [FEATURE] New `annotation close rate` report for videos and channels.

## 0.15.0 - 2015-04-19

**How to upgrade**

If your code never calls the `viewer_percentage(gender: [:female|:male])` method
on a Channel or Video object, then you are good to go.

If it does, then replace your calls to `viewer_percentage(gender: :female)`
with `viewer_percentage(by: gender)[:female]`, and do the same for `:male`.

Note that the _plural_ `viewer_percentages` method still works but it’s
deprecated: you should use `viewer_percentage` instead.

* [ENHANCEMENT] Remove `:gender` option in `viewer_percentage` in favor of a more generic `:by`
* [FEATURE] New `by: :gender` option for reports, to return viewer percentage by gender
* [FEATURE] New `by: :age_group` option for reports, to return viewer percentage by age group
* [ENHANCEMENT] The viewer percentage report now accepts start/end date options (like any other report)
* [DEPRECATION] Deprecate `viewer_percentages` in favor of `viewer_percentage`.

## 0.14.7 - 2015-04-17

* [FEATURE] New `by: :device_type` option for reports, to return views and estimated watched minutes (channels) by device

## 0.14.6 - 2015-04-17

* [BUGFIX] Rescue OpenSSL::SSL::SSLErrorWaitReadable only on version of Ruby that define it.

## 0.14.5 - 2015-04-15

* [BUGFIX] Raise `Yt::Errors::RequestError` when passing an invalid path or URL to `upload_thumbnail`

## 0.14.4 - 2015-04-14

* [FEATURE] New `by: :embedded_player_location` option for reports, to return views and estimated watched minutes (channels) by URL where the player was embedded
* [FEATURE] New `by: :playback_location` option for reports, to return views and estimated watched minutes (channels) by watch/embedded/channel/external app/mobile.
* [FEATURE] New `by: :related_video` option for reports, to return views and estimated watched minutes (channels) by the video that linked there.

## 0.14.3 - 2015-04-09

* [BUGFIX] Don't let request errors crash Yt in Ruby 1.9.3.

## 0.14.2 - 2015-04-08

* [FEATURE] Make `Annotation#text` a public method.
* [FEATURE] Make `data` a public method for Snippet, Status, ContentDetail and StatisticsSet.
* [FEATURE] Add .includes to .videos, so you can eager load snippet, status, statistics and content details for a collection of videos

## 0.14.1 - 2015-03-30

* [FEATURE] New `monetized playbacks` report for channels.
* [FEATURE] New `estimated watched minutes` report for videos.
* [FEATURE] New video reports: `average_view_duration`, `average_view_percentage`.
* [FEATURE] New `by: :playlist` option for reports, to return views and estimated watched minutes (channels) by playlist.
* [FEATURE] New playlist reports: `views`, `playlist_starts`, `average_time_in_playlist`, `views_per_playlist_start`.


## 0.14.0 - 2015-03-25

* [FEATURE] New `by: :traffic_source` option for reports, to return views (channels/videos) and estimated watched minutes (channels) by traffic source.
* [FEATURE] New `by: :video` option for reports, to return views and estimated watched minutes (channels) by video.

## 0.13.12 - 2015-03-23

* [FEATURE] New channel/video reports: `favorites_added`, `favorites_removed`.

## 0.13.11 - 2015-02-27

* [FEATURE] New channel reports: `subscribers_gained`, `subscribers_lost`.
* [FEATURE] New video reports: `subscribers_gained`, `subscribers_lost`.
* [FEATURE] New channel reports: `estimated_minutes_watched`, `average_view_duration`, `average_view_percentage`.

## 0.13.10 - 2015-02-17

* [FEATURE] New `video.upload_thumbnail` to upload the thumbnail for a video.

## 0.13.9 - 2015-02-16

* [ENHANCEMENT] Accept `force: true` in `authentication_url` to force approval prompt.

## 0.13.8 - 2015-01-15

* [FEATURE] AssetSearch resources available.
* [FEATURE] Access asset metadata (`effective` and `mine`) via the asset object.
* [ENHANCEMENT] Support `isManualClaim` parameter in claims#insert.

## 0.13.7 - 2014-10-27

* [FEATURE] New video reports: monetized playbacks.

## 0.13.6 - 2014-10-08

* [ENHANCEMENT] Accept `includes(:viewer_percentages)` in `.partnered_channels` to eager-load multiple viewer percentages at once.
* [ENHANCEMENT] Accept `where` in ViewerPercentages to collect data for multiple channels at once.
* [ENHANCEMENT] Accept `part` in the `where` clause of Channels, so statistics can be loaded at once.

## 0.13.5 - 2014-10-06

* [ENHANCEMENT] Add `advertising_options_set` and `ad_formats` to video

## 0.13.4 - 2014-10-01

* [ENHANCEMENT] Accept `policy` (with custom set of rules) in `content_owner.create_claim`

## 0.13.3 - 2014-10-01

* [BUGFIX] Rescue OpenSSL::SSL::SSLErrorWaitReadable raised by YouTube servers.

## 0.13.2 - 2014-10-01

* [FEATURE] Add `release!` to Ownership.

## 0.13.1 - 2014-09-18

* [BUGFIX] Make list videos by id work for exactly 50 ids.

## 0.13.0 - 2014-09-11

**How to upgrade**

If your code never calls the `create_playlist` on a Channel object, then you
are good to go.

If it does, then replace your calls to `channel.create_playlist` with
`account.create_playlist`, that is, call `create_playlist` on the channel’s
account instead.

* [ENHANCEMENT] Remove `create_playlist` from Channel (still exists on Account)
* [ENHANCEMENT] Accept `category_id` in `upload_video`.

## 0.12.2 - 2014-09-09

* [ENHANCEMENT] Accept `part` in the `where` clause of Videos, so statistics and content details can be eagerly loaded.

## 0.12.1 - 2014-09-04

* [ENHANCEMENT] Add `position` option to add_video (to specify where in a playlist to add a video)
* [FEATURE] Add `update` to PlaylistItem (to change the position of the item in the playlist)

## 0.12.0 - 2014-08-31

**How to upgrade**

If your code never calls the `delete` method directly on a Subscription
object (to delete subscriptions by id), then you are good to go.

If it does, then be aware that trying to delete an unknown subscription will
now raise a RequestError, and will not accept `ignore_errors` as an option:

    account = Yt::Account.new access_token: 'ya29...'
    subscription = Yt::Subscription.new id: '--unknown-id--', auth: account
    # old behavior
    subscription.delete ignore_errors: true # => false
    # new behavior
    subscription.delete # => raises Yt::Errors::RequestError "subscriptionNotFound"

Note that the `unsubscribe` and `unsubscribe!` methods of `Channel` have not
changed, so you can still try to unsubscribe from a channel and not raise an
error by using the `unsubscribe` method:

    account = Yt::Account.new access_token: 'ya29...'
    channel = Yt::Channel.new id: 'UC-CHANNEL-ID', auth: account
    channel.unsubscribe # => returns falsey if you were not subscribed
    channel.unsubscribe! # => raises Yt::Errors::RequestError if you were not subscribed

* [ENHANCEMENT] Replace `has_many :subscriptions` with `has_one :subscription` in Channel
* [FEATURE] Add `subscribed_channels` to Channel (list which channels the channel is subscribed to)
* [FEATURE] Add `subscribers` to Account (list which channels are subscribed to an account)

## 0.11.6 - 2014-08-28

* [BUGFIX] Make Resource.new(url: url).title hit the right endpoint

## 0.11.5 - 2014-08-27

* [BUGFIX] Make videos.where(id: 'jNQXAC9IVRw').first.id return 'jNQXAC9IVRw'

## 0.11.4 - 2014-08-27

* [ENHANCEMENT] Add Video search even by id, chart or rating
* [FEATURE] Add `ActiveSupport::Notification` to inspect HTTP requests

## 0.11.3 - 2014-08-21

* [FEATURE] Add `update` method to Asset model

## 0.11.2 - 2014-08-20

* [FEATURE] Add AdvertisingOptionsSet with `update` to change the advertising settings of a video
* [FEATURE] Add `content_owner.create_claim` and `claim.delete`
* [FEATURE] Add `update` method to Ownership to change owners of an asset
* [FEATURE] Add `asset.ownership` to list the owners of an asset
* [FEATURE] Add `content_owner.create_asset` and Asset model

## 0.11.1 - 2014-08-17

* [ENHANCEMENT] Add Video search even without a parent account or channel

For instance, to search for the most viewed video on the whole YouTube, run:

    videos = Yt::Collections::Videos.new
    videos.where(order: 'viewCount').first.title #=>  "PSY - GANGNAM STYLE"

## 0.11.0 - 2014-08-17

**How to upgrade**

When a request to YouTube fails, Yt used to print out a verbose error message,
including the response body and the request that caused the error (in curl
format). This output could include sensitive data (such as the authentication
token). For security reasons, Yt will not print it out anymore by default.

If this is acceptable, then you are good to go.
If you want the old behavior, set the `log_level` of Yt to `:debug`:

    Yt.configure do |config|
      config.log_level = :debug
    end

* [ENHANCEMENT] Add `log_level` to Yt.configuration

## 0.10.5 - 2014-08-17

* [ENHANCEMENT] Use PATCH rather than PUT to partially update a MatchPolicy

## 0.10.4 - 2014-08-15

* [BUGFIX] List tags of videos retrieved with channel.videos and account.videos

## 0.10.3 - 2014-08-12

* [FEATURE] Add methods to insert and delete ContentID references
* [FEATURE] Add `.match_reference_id` to Claim model

## 0.10.2 - 2014-08-11

* [FEATURE] Add `MatchPolicy` class with `.update` to change the policy used by an asset

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

    account = Yt::Account.new access_token: 'ya29...'
    # old behavior
    account.videos.size # => retrieved *all* the pages of the account’s videos
    # new behavior
    account.videos.size # => retrieves only the first page, returning the totalResults counter
    account.videos.count # => retrieves *all* the pages of the account’s videos

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

    rating = Yt::Rating.new
    # old syntax
    rating.update :like
    # new syntax
    rating.set :like

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

    account = Yt::Account.new access_token: 'ya29...'
    channel = account.channel
    # old behavior
    channel.subscribe # => raised an error
    # new behavior
    channel.subscribe # => nil
    channel.subscribe! # => raises an error

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
