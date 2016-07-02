# Project 4 - *Twitter*

**Twitter** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **24** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow
- [X] The current signed in user will be persisted across restarts
- [X] User can view last 20 tweets from their home timeline
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [X] User can pull to refresh.
- [X] User should display the relative timestamp for each tweet "8m", "7h"
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap the profile image in any tweet to see another user's profile
   - [X] Contains the user header view: picture and tagline
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers
   - [X] Profile view should include that user's timeline
- [X] User can navigate to view their own profile
   - [X] Contains the user header view: picture and tagline
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers

The following **optional** features are implemented:

- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet
- [X] Links in tweets are clickable
- [X] User can switch between timeline, mentions, or profile view through a tab bar
- [ ] Pulling down the profile page should blur and resize the header image.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How did you view new tweets on timeline without taking up client space?
2. How do you make links the color you want it to be?

## Video Walkthrough

Here's a walkthrough of implemented user stories:

- [Landscape](https://youtu.be/flqjzXSkfVY) - includes links
- [Portrait](https://youtu.be/5THn67ng6WU) - includes user profiles

## Notes

This app had a lot of tiny features to implement that took a lot of time. I was happy with most of my autolayout and developed a solid understanding of how to use it. Once more, I wish I had a little more time to implement the features I want/fix some bugs/made my code A LOT cleaner, but I'm happy with the product, and I can't believe I made it with only three weeks of instruction!

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright 2016 Angela Chen

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
