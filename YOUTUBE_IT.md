How to migrate from youtube_it
==============================

If you are used to access the YouTube API with [youtube_it](https://github.com/kylejginavan/youtube_it),
this guide will help you translate your code to use Yt instead.

This guide follows [youtube_it README.rdoc](https://github.com/kylejginavan/youtube_it/blob/f61ed0b00905e048dcbed12457d02f52ddbae45d/README.rdoc)
listing the original `youtube_it` commands and their equivalent `Yt` versions.

Establishing a client
---------------------

While `youtube_it` supports authentication with developer key, AuthSub and
OAuth, `Yt` only supports OAuth 2.0, because this is the only process that has
not been deprecated by YouTube Data API V3.

Another difference is that `youtube_it` authentication methods are invoked on
a generic `Client` class, while with `Yt` you can specify whether you want to
authenticate as a YouTube `Account` or as a `ContentOwner`.
Content owners are special [CMS accounts](https://cms.youtube.com) that can
manage multiple YouTube accounts at once.

Creating a client:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
# with yt
account = Yt::Account.new # or Yt::ContentOwner.new
```

Client with developer key:

```ruby
# with youtube_it
client = YouTubeIt::Client.new(:dev_key => "developer_key")
# with yt: not supported (must use OAuth 2.0)
```

Client with youtube account and developer key:

```ruby
# with youtube_it
client = YouTubeIt::Client.new(:username => "youtube_username", :password =>  "youtube_passwd", :dev_key => "developer_key")
# with yt: not supported (must use OAuth 2.0)
```

Client with AuthSub:

```ruby
# with youtube_it
client = YouTubeIt::AuthSubClient.new(:token => "token" , :dev_key => "developer_key")
# with yt: not supported (must use OAuth 2.0)
```

Client with OAuth:

```ruby
# with youtube_it
client = YouTubeIt::OAuthClient.new("consumer_key", "consumer_secret", "youtube_username", "developer_key")
client.authorize_from_access("access_token", "access_secret")
# with yt: not supported (must use OAuth 2.0)
```

Client with OAuth2:

```ruby
# with youtube_it
client = YouTubeIt::OAuth2Client.new(client_access_token: "access_token", client_refresh_token: "refresh_token", client_id: "client_id", client_secret: "client_secret", dev_key: "dev_key", expires_at: "expiration time")
client.refresh_access_token!
# with yt
Yt.configure do |config|
  config.client_id = 'client_id'
  config.client_secret = 'client_secret'
end
account = Yt::Account.new access_token: 'access_token', refresh_token: 'refresh_token'
```

Profiles
--------

With `youtube_it`, you can use multiple profiles in the same account:

```ruby
profiles = client.profiles(['username1','username2'])
profiles['username1'].username, "username1"
```

With `yt`, you can access all the channels managed by the same YouTube account:

```ruby
first_channel = Yt::Channel.new id: 'UCx12345', auth: account
second_channel = Yt::Channel.new id: 'UCy45678', auth: account
first_channel.title
```

Video queries
-------------

List videos by keyword:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:query => "penguin")
# with yt
videos = Yt::Collections::Videos.new
videos.where(q: 'penguin')
```

List videos by page:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:query => "penguin", :page => 2, :per_page => 15)
# with yt: pagination is automatically supported by collection, which iterates
# though all the pages, not just the first one
videos = Yt::Collections::Videos.new
videos.where(q: 'penguin')
```

List videos by region:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:query => "penguin", :restriction => "DE")
# with yt
# Note that some users report that regionCode does not work in YouTube API V3
# See https://code.google.com/p/gdata-issues/issues/detail?id=4110
videos = Yt::Collections::Videos.new
videos.where(q: 'penguin', region_code: 'DE')
```

List videos by author:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:query => "penguin",  :author => "liz")
# with yt: the 'author' filter was removed from YouTube API V3, so the
# request must be done using the channel of the requested author
channel = Yt::Channel.new id: 'UCxxxxxxxxx'
channel.videos.where(q: 'penguin')
```

List videos by categories:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:categories => [:news, :sports])
# with yt: the 'categories' filter was removed from YouTube API V3, so the
# request must be done using one category_id at the time
videos = Yt::Collections::Videos.new
videos.where(video_category_id: 25) #=> News
videos.where(video_category_id: 17) #=> Sports
```

List videos by tags:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:tags => ['tiger', 'leopard'])
client.videos_by(:categories => [:news, :sports], :tags => ['soccer', 'football'])
# with yt: not supported (was removed from YouTube API V3)
```

List videos by user:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:user => 'liz')
# with yt: the 'author' filter was removed from YouTube API V3, so the
# request must be done using the channel of the requested author
channel = Yt::Channel.new id: 'UCxxxxxxxxx'
channel.videos.where(q: 'penguin')
```

List videos favorited by user:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:favorites, :user => 'liz')
# with yt: note that only *old* channels have a "Favorites" playlist, since
# "Favorites" has been deprecated by YouTube in favor of "Liked Videos".
channel = Yt::Channel.new id: 'UCxxxxxxxxx'
channel.related_playlists.find{|p| p.title == 'Favorites'}
```


Retrieve video by ID:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.video_by("FQK1URcxmb4")
# with yt
Yt::Video.new id: 'FQK1URcxmb4'
```

Retrieve video by URL:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.video_by("https://www.youtube.com/watch?v=QsbmrCtiEUU")
# with yt
Yt::Video.new url: 'https://www.youtube.com/watch?v=QsbmrCtiEUU'
```

Retrieve video of a user by ID:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.video_by_user("chebyte","FQK1URcxmb4")
# with yt
Yt::Video.new id: 'FQK1URcxmb4'
```

List most viewed videos:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:most_viewed)
# with yt
videos = Yt::Collections::Videos.new
videos.where(order: 'viewCount')
```

List most linked videos:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:most_linked, :page => 3)
# with yt: not supported (was removed from YouTube API V3)
```

List most popular video:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:top_rated, :time => :today).first
# with yt
videos = Yt::Collections::Videos.new
videos.where(chart: 'mostPopular').first
```

List *all* most popular videos:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:top_rated, :time => :today)
# with yt: YouTube API V3 only returns the top 50
videos = Yt::Collections::Videos.new
videos.where(chart: 'mostPopular')
```

List most popular video by region and category:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:top_rated,  :region => "RU", :category => "News").first
# with yt
videos = Yt::Collections::Videos.new
videos.where(chart: 'mostPopular', region_code: 'RU', video_category_id: 25).first
```

Advanced Queries (with boolean operators OR (either), AND (include), NOT (exclude)):

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:categories => { :either => [:news, :sports], :exclude => [:comedy] }, :tags => { :include => ['football'], :exclude => ['soccer'] })
# with yt: not supported (was removed from YouTube API V3)
```

Custom Query Params:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:query => "penguin", :safe_search => "strict")
client.videos_by(:query => "penguin", :duration => "long")
client.videos_by(:query => "penguin", :hd => "true")
client.videos_by(:query => "penguin", :region => "AR")
# with yt
videos = Yt::Collections::Videos.new
videos.where(q: 'penguin', safe_search: 'strict')
videos.where(q: 'penguin', duration: 'long')
videos.where(q: 'penguin', video_definition: 'high')
videos.where(q: 'penguin', region_code: 'AR')
```

Return videos with more than 1,000 views:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:fields => {:view_count => "1000"})
# with yt: the most similar method in YouTube API V3 is to return the results by view count
videos = Yt::Collections::Videos.new
videos.where(order: 'viewCount')
```

Filter by date (also with range):

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.videos_by(:fields => {:published  => (Date.today)})
client.videos_by(:fields => {:recorded   => (Date.today)})
client.videos_by(:fields => {:published  => ((Date.today - 30)..(Date.today))})
client.videos_by(:fields => {:recorded   => ((Date.today - 30)..(Date.today))})
# with yt (only published is available in YouTube API V3, not recorded date)
videos = Yt::Collections::Videos.new
videos.where(published_before: 0.days.ago.utc.iso8601(0), published_after: 30.day.ago.utc.iso8601(0))
```

Filter including private videos:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.my_video("FQK1URcxmb4")
client.my_videos(:query => "penguin")
# with yt
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: 'FQK1URcxmb4', auth: account
account.videos.where(q: 'penguin')
```

Video management
----------------

Upload video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_upload(File.open("test.mov"), :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test])
# with yt
account = Yt::Account.new access_token: 'access_token'
account.upload_video 'test.mov', title: 'test', description: 'some description', category_id: '22', tags: %w(cool blah test)
```

Upload remote video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_upload("http://url/myvideo.mp4", :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test])
# with yt
account = Yt::Account.new access_token: 'access_token'
account.upload_video 'http://url/myvideo.mp4', title: 'test', description: 'some description', category_id: '22', tags: %w(cool blah test)
```

Upload video with a developer tag:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_upload(File.open("test.mov"), :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test], :dev_tag => 'tagdev')
# with yt: not supported (was removed from YouTube API V3)
```

Upload video from URL:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_upload("http://media.railscasts.com/assets/episodes/videos/412-fast-rails-commands.mp4", :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test])
# with yt
account = Yt::Account.new access_token: 'access_token'
account.upload_video 'http://media.railscasts.com/assets/episodes/videos/412-fast-rails-commands.mp4', title: 'test', description: 'some description', category_id: '22', tags: %w(cool blah test)
```

Upload private video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_upload(File.open("test.mov"), :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test], :private => true)
# with yt
account = Yt::Account.new access_token: 'access_token'
account.upload_video 'test.mov', privacy_status: :private, title: 'test', description: 'some description', category_id: '22', tags: %w(cool blah test)
```

Update video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_update("FQK1URcxmb4", :title => "new test",:description => 'new description', :category => 'People',:keywords => %w[cool blah test])
# with yt: only provides the values that need to be updated; the remaining ones
# will automatically be kept as they are
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: 'FQK1URcxmb4', auth: account
video.update title: 'new test', description: 'new description'
```

Delete video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_delete("FQK1URcxmb4")
# with yt
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: 'FQK1URcxmb4'
video.delete
```

My videos:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.my_videos
# with yt
account = Yt::Account.new access_token: 'access_token'
account.videos
```

My video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.my_video(video_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
Yt::Video.new id: video_id, auth: account
```

Profile details:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.profile(user)
# with yt
account = Yt::Account.new access_token: 'access_token'
account.user_info
```

List comments:

```ruby
# with youtube_it
client = YouTubeIt::Client.new
client.comments(video_id)
# with yt: not supported (was removed from YouTube API V3)
```

Add a comment:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.add_comment(video_id, "test comment!")
# with yt: not supported (was removed from YouTube API V3)
```

Add a reply comment:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.add_comment(video_id, "test reply!", :reply_to => another_comment)
# with yt: not supported (was removed from YouTube API V3)
```

Delete a comment:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.delete_comment(video_id, comment_id)
# with yt: not supported (was removed from YouTube API V3)
```

List Favorites:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.favorites(user) # default: current user
# with yt: note that only *old* channels have a "Favorites" playlist, since
# "Favorites" has been deprecated by YouTube in favor of "Liked Videos".
account = Yt::Account.new access_token: 'access_token'
account.related_playlists.find{|p| p.title == 'Favorites'}
```

Add Favorite:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.add_favorite(video_id)
# with yt: "like" a video to mark as favorite with YouTube API V3
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: video_id, auth: account
video.like
```

Delete Favorite:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.delete_favorite(favorite_entry_id)
# with yt: "unlike" a video to remove from favorites with YouTube API V3
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: video_id, auth: account
video.unlike
```

-->

Like a video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.like_video(video_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: video_id, auth: account
video.like
```

Dislike a video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.dislike_video(video_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: video_id, auth: account
video.dislike
```

List Subscriptions (channels an account is subscribed to):

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.subscriptions(user) # default: current user
# with yt
account = Yt::Account.new access_token: 'access_token'
account.subscribed_channels
```

Subscribe to a channel:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.subscribe_channel(channel_name)
# with yt
account = Yt::Account.new access_token: 'access_token'
channel = Yt::Channel.new id: channel_id, auth: account
channel.subscribe
```

Unsubscribe from a channel:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.unsubscribe_channel(subscription_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
channel = Yt::Channel.new id: channel_id, auth: account
channel.unsubscribe
```

List New Subscription Videos:


```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.new_subscription_videos(user) # default: current user
# with yt: not supported (was removed from YouTube API V3)
```

List Playlists:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.playlists(user) # default order, by position
client.playlists(user, "title") # order by title
# with yt: available without order; ordering was removed from YouTube API V3
account = Yt::Account.new access_token: 'access_token'
account.playlists
```

Select Playlist:

```ruby
# with youtube_it
client.playlist(playlist_id)
# with yt
Yt::Playlist.new id: playlist_id
```

Select All Videos From A Playlist:

```ruby
# with youtube_it
playlist = client.playlist(playlist_id)
playlist.videos
# with yt
playlist = Yt::Playlist.new id: playlist_id
playlist.playlist_items.map &:video
```

Create Playlist:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
playlist = client.add_playlist(:title => "new playlist", :description => "playlist description")
# with yt
account = Yt::Account.new access_token: 'access_token'
account.create_playlist title: 'new playlist', description: 'playlist description'
```

Delete Playlist:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.delete_playlist(playlist_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
playlist = Yt::Playlist.new id: playlist_id, auth: account
playlist.delete
```

Add Video To Playlist:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.add_video_to_playlist(playlist_id, video_id, position)
# with yt
account = Yt::Account.new access_token: 'access_token'
playlist = Yt::Playlist.new id: playlist_id, auth: account
playlist.add_video video_id, position: position
```

Remove Video From Playlist:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.delete_video_from_playlist(playlist_id, playlist_entry_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
playlist_item = Yt::PlaylistItem.new id: playlist_entry_id, auth: account
playlist_item.delete
```

Update Position Video From Playlist:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.update_position_video_from_playlist(playlist_id, playlist_entry_id, position)
# with yt
account = Yt::Account.new access_token: 'access_token'
playlist_item = Yt::PlaylistItem.new id: playlist_entry_id, auth: account
playlist_item.update position: position
```

Select All Videos From your Watch Later Playlist:

```ruby
# with youtube_it
watcher_later = client.watcherlater(user) #default: current user
watcher_later.videos
# with yt
account = Yt::Account.new access_token: 'access_token'
watch_later = account.related_playlists.find{|p| p.title == 'Watch Later'}
watch_later.playlist_items.map{|item| item.video}
```

Add Video To Watcher Later Playlist:

```ruby
# with youtube_it
client.add_video_to_watchlater(video_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
watch_later = account.related_playlists.find{|p| p.title == 'Watch Later'}
watch_later.add_video video_id
```

Remove Video From Watch Later Playlist:

```ruby
# with youtube_it
client.delete_video_from_watchlater(watchlater_entry_id)
# with yt
account = Yt::Account.new access_token: 'access_token'
watch_later = account.related_playlists.find{|p| p.title == 'Watch Later'}
watch_later.delete_playlist_items video_id: video_id
```

<!-- TODO: Add using https://developers.google.com/youtube/v3/docs/search/list#relatedToVideoId

List Related Videos:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
video = client.video_by("https://www.youtube.com/watch?v=QsbmrCtiEUU&feature=player_embedded")
video.related.videos
# with yt:
```

-->

Add Response Video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
video.add_response(original_video_id, response_video_id)
# with yt: not supported (was removed from YouTube API V3)
```

Delete Response Video:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
video.delete_response(original_video_id, response_video_id)
# with yt: not supported (was removed from YouTube API V3)
```

List Response Videos:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
video = client.video_by("https://www.youtube.com/watch?v=QsbmrCtiEUU&feature=player_embedded")
video.responses.videos
# with yt: not supported (was removed from YouTube API V3)
```

Batch videos (list multiple videos):

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.videos(['video_id_1', 'video_id_2',...])
# with yt
Yt::Collections::Videos.new.where(id: 'video_id_1,video_id_2')
```

Access control list
-------------------

While `youtube_it` allows users to give and revoke permissions to rate, comment,
respond, list, embed and syndicate uploaded videos, `Yt` does not.

The reason is that most of these permissions have been deprecated in YouTube
Data API V3. The only parameter that can still be passed when updating a
video is 'embeddable'; however many users have reported that updating this
setting through the API simply does not work.
See https://code.google.com/p/gdata-issues/issues/detail?id=4861

Block users from commenting on a video:

```ruby
# with youtube_it
client = YouTubeIt::Client.new(:username => "youtube_username", :password =>  "youtube_passwd", :dev_key => "developer_key")
client.video_upload(File.open("test.mov"), :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test], :comment => "denied")
# with yt: not supported (was removed from YouTube API V3; only the embeddable setting can be specified)
```

Block users from embedding a video:

```ruby
# with youtube_it
client = YouTubeIt::Client.new(:username => "youtube_username", :password =>  "youtube_passwd", :dev_key => "developer_key")
client.video_upload(File.open("test.mov"), :title => "test",:description => 'some description', :category => 'People',:keywords => %w[cool blah test], :embed => "denied")
# with yt: not supported (it is documented in YouTube API V3 but looks like it is not working)
```

Partial updates
---------------

While `youtube_it` uses a separate method to specify that an UPDATE request
should not modify any field that has not been explicitly specified, `Yt`
applies this behavior by default

Change the title of a video, but not its privacy status or its description:

```ruby
# with youtube_it
client = # new client initialized with either OAuth or AuthSub
client.video_partial_update(video_id, :title => 'new title')
# with yt
account = Yt::Account.new access_token: 'access_token'
video = Yt::Video.new id: video_id, auth: account
video.update title: 'new title'
```

<!--

TODO

== User Activity
 You can get user activity with the followings params:

 $ client.activity(user) #default current user

-->