package com.mcz9mm.multiple_image_upload

import android.content.Context
import android.media.ExifInterface
import android.net.Uri
import java.io.File
import java.io.IOException

class ExifUtil {

    fun writeDescription(uriStr: String, value: String): String {
        val uri = Uri.parse(uriStr)
        val input = File(uri.path)
        try {
            val exifInterface = ExifInterface(input.path)
            val description = exifInterface.getAttribute(ExifInterface.TAG_IMAGE_DESCRIPTION)
            print(description)
            exifInterface.setAttribute(ExifInterface.TAG_IMAGE_DESCRIPTION, value)
            val newDescription = exifInterface.getAttribute(ExifInterface.TAG_IMAGE_DESCRIPTION)
            exifInterface.saveAttributes()
            print(newDescription)
            return input.path
        } catch (e: IOException) {
            print(e.message)
            return e.message!!
        }
    }
}