Birthdays
=========

I built a tool to analyze birthday posts on my Facebook wall.

Running Birthdays:
---
You should be able to build and run Birthdays out of the box. It was built with Xcode 5 on OS X Mavericks.

Output will appear in the Xcode developer console.

Using Custom Data:
---

1. Download the custom data (as described below).
2. Add the file to your Xcode project. Be sure that Xcode will copy the file to your application bundle.
3. Modify line 34 of BDAppDelegate.h to reflect the new filename.

Fetching Custom Data:
---

To fetch custom data, download a series of Facebook posts from the Graph API. The URL to use is:

    https://graph.facebook.com/feed/me

Don't forget to append an access token, like so:

    https://graph.facebook.com/feed/me?access_token=1234567890abcdef...

Additionally, note that You may have to paginate your data over multpiple HTTP requests. Once you have your entire data set in a JSON file, you'll be ready to ggo. 

License:
---
GPL License
