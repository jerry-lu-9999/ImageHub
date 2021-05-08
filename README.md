#  ImageHub

Your ultimate place to store your images (or take some new ones! )

## API usage
https://api.flickr.com/services/feeds/photos_public.gne

## Description

This app is written in Swift (UIKit) and use the theme of another famous video collection website for reference. 

The device orientation is set to be protrait only for now.

There are three main controllers.

1. Navigation Controller
2. Collection ViewController (MainVC). It also contains the searchBarController
3. Detail View Controller for each picture (DetailVC)

The current app support displaying and searching the images by their title from Flicker API with a certain search term. In this case, it is "Eibsee" defined in Library.swift

## Build and Deployment Target

This project is built in Xcode 12.5, tested on iPhone 12 Simulator running iOS 14.5

## How to run

Simpily press the start button and all should execute well! 

## Current Issues

The current build pops up the following messages

```
ImageHub[34500:1072135] [] nw_protocol_get_quic_image_block_invoke dlopen libquic failed
```
I've encountered this warning multiple times across multiple projects when there are images in play

## Future functionalities

 future functionalities include

1. Add images from either the camera or the gallery. For now, the button and structure is ready but the code itself has not yet been implemented
2. Authentication with Face ID or Touch ID, which shall further introduce settings or UserDefault in the app
3. Group the photos by their dates or categories. 



