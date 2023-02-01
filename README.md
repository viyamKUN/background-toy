# background-toy


<p align='center'>
    <img src='./Docs/icon.png'>
</p>
<p align='center'>
Hi! I'm your virtual desktop friend.
(for mac)
</p>

## Overview

This is a **desktop pet program**, built with Swift and can be run and built using Xcode. In addition to providing alarm at a set time, it can also serve as a virtual companion that occasionally interacts with you.

## Screenshot

![.](./Docs/screenshot00.gif)

## Custom

### Custom Animation

You can customize the animation by editing the `animation.json` file.
You just need to update the `spriteFolderPath` with the path to the folder that holds your animation images. Ensure that you follow these guidelines:

Animation image names should be in the format of `{animation name}_{index}.png`.
You need to have at least one image for each idle, walk, grab, touch, and playing cursor animation.

Here's a sample animation.json file:

```
{
    "spriteFolderPath": "default",
    "clips": {
        "idle": {
            "count": 3,
            "playType": "pingpong"
        },
        "walk": {
            "count": 7,
            "playType": "restart"
        },
        "grab": {
            "count": 3,
            "playType": "pingpong"
        },
        "touch": {
            "count": 2,
            "playType": "restart"
        },
        "playingcursor": {
            "count": 6,
            "playType": "restart"
        }
    }
}
```

`playType` refers to how the animation is played, either "pingpong" (play backwards when the animation ends) or "restart" (restart when the animation ends).

### Custom Macro

You can set custom macros by editing the `macro.json` file.
The macros can execute processes, open web URLs, and print chat messages.

Here's a sample macro.json file:

```
{
    "test1": [
        {
            "type": "process",
            "payload": "/Applications/Discord.app"
        },
        {
            "type": "web",
            "payload": "https://www.google.com/"
        },
        {
            "type": "chat",
            "payload": "Hey! Let's play game."
        }
    ],
    "test2": [
        {
            "type": "web",
            "payload": "https://www.naver.com/"
        }
    ]
}
```

### Custom Chat

You can set custom chat messages by editing the `chat.json` file.
The chat messages are based on time and classified into morning, lunch, afternoon, evening, and night.
You can add as many lines as you wish.

Here's a sample chat.json file:

```
{
    "spriteFolderPath": "default",
    "clips": {
        "idle": {
            "count": 3,
            "playType": "pingpong"
        },
        "walk": {
            "count": 7,
            "playType": "restart"
        },
        "grab": {
            "count": 3,
            "playType": "pingpong"
        },
        "touch": {
            "count": 2,
            "playType": "restart"
        },
        "playingcursor": {
            "count": 6,
            "playType": "restart"
        }
    }
}
```

# Conclusion

This desktop pet program built with Swift is a fun and interactive tool for users. It offers various features including alarms, and macro execution, making it a well-rounded and customizable experience. The ability to change the animation, macro commands, and chat messages allows users to make the program their own. Whether it be a helpful reminder or a virtual friend, this program is sure to bring a touch of enjoyment to the user's desktop.
