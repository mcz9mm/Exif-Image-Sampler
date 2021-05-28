## About

This repository is a sample implementation using images.
For iOS implementation, please add the necessary processing to info.plist.

It has the following features
- Take a picture with the camera and get an image.
- Acquire images from the gallery of the local terminal.
- Display a list of images from the gallery
- Sample implementation of sending the selected image from the list via API.
- Reading Exif information
- Write Exif information (Image DescriptionTag)
　Note: 2-byte characters are not allowed.
- Save the image.
- Save the image - Delete the image

Note: Exif information is written in Kotlin using MethodChannel.