package com.mcz9mm.multiple_image_upload

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    companion object {
        private const val CHANNEL = "mcz9mm.flutter.dev/multiple_image_upload"
        private const val METHOD_GET_LIST = "writeExifData"
    }

    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            if (methodCall.method == METHOD_GET_LIST) {
                val description = methodCall.argument<String>("description").toString()
                val uriStr = methodCall.argument<String>("uri").toString()
                val resultUri = ExifUtil().writeDescription(uriStr, description)
                result.success(resultUri)
            }
            else
                result.notImplemented()
        }
    }
}
