# Flutter Exif-Image-Sampler
![Flutter](https://img.shields.io/badge/platform-Flutter-blue.svg) [![Twitter Follow](https://img.shields.io/twitter/follow/mcz9mm.svg?style=social)](https://twitter.com/mcz9mm)


## 📸 ScreenShots

| Photo List | Exif View|
|------|-------|
|<img src="https://user-images.githubusercontent.com/11751495/119928561-c1b8d100-bfb6-11eb-8011-5c3e343973d7.png" width="400">|<img src="https://user-images.githubusercontent.com/11751495/119928573-c7161b80-bfb6-11eb-8888-3b9fe1a5668b.png" width="400">|


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

Note: Exif information is written in Kotlin using MethodChannel.[(code here)](https://github.com/mcz9mm/Exif-Image-Sampler/blob/main/android/app/src/main/kotlin/com/mcz9mm/multiple_image_upload/ExifUtil.kt#L11)

## License
MIT license.
