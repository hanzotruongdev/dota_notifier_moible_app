---
- [What is DotA Notifier] (#what-is-dota-notifier)
- [Features] (#features)
- [Usage and Installation] (#ussage-and-installation)
---


## What is Dota Notifier?

DotA Notifier is an app allows users following DotA2 Pro Players. 

You will never miss any live matches of your favorite Pro Players with this app.

## Features

1. Search Pro Player by name
2. Follow Pro Players you like, the app will notify you when you followed Pro Players go Live on DotaTV
3. Save the list of your followed Pro Players on your account, you can get notified on others devices after login without re-follow them again.

## Usage and Installation

There are two ways to use DotA Notifier:

### Published app available on playstore
You can download the app on [Google Playstore](https://play.google.com/store/apps/details?id=com.herokuapp.dotanotifier)

### Build your own version
1. Clone this repository
```
git clone git@github.com:noitq/dota_notifier_moible_app.git
```
2. Install the dependencies
```
flutter packages get
```
3. Replace all the api endpoints with your api endpoints.
To build your own api server, please check out the server code: https://github.com/noitq/dota_notifier_server

4. Build apk bundle
```
$ flutter build appbundle
```
