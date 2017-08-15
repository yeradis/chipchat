# Chit Chat
chip chat, chit chat, what else? Another app to talk about meaningless subjects

To handle dependencies, i´m using Carthage, so, before trying to play with this you need to pull dependencies:

```
carthage update
```

DISCLAIMER: This is not a fully functional chat app, its just a `Chat Interview Test`

What you will find here:

- Tests (XCTests, OCMock)
- NO VIPER, NO MVVM, NO VIP, just the usual MVC but no soo Massive ;)
- +90% of Code Coverage, yes, this includes testing network calls, some ui calls cheking items at the list, with the usual hack "[viewcontroller view]" to fire everying inside
- Usage of custom UICollectionViewCell
- etc...

pd: check the pdf under `docs` folder

Below is the wire frames you will be given

First View will include an given image and login details like left. 
You need to enter a name and this will be your name for the rest of the app.

`first image here`

In the second view you will display the chat. 

`second image here`

Fetch the contents of "https://s3-eu- west-1.amazonaws.com/rocket-interview/ chat.json" 
and display them according to the wireframe.

Please do choose any name expect “Carrie - Anthony - Eleanor - Rodney - Oliva - Merve or Lily ” 
These names are already reserved for your “friends”.
(Friendly recommendation to not cause any confusion afterwards.) 
When you type in some text to current chat your chat bubble should appear like dark grey one 
as shown at the bottom.

Logout button on the top right : 
If user doesn't logout, App should show the chat screen directly without login page, when ever it launches.

