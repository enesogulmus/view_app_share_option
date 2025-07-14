package com.nsoftware.view_app_share_option

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class ViewAppShareOptionPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var sharedFile: String? = null

  private val supportedMimeTypes = arrayOf(
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "application/vnd.ms-powerpoint",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  )

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "view_app_share_option")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    if (call.method == "getSharedFile") {
      result.success(sharedFile)
      sharedFile = null
    } else {
      result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    handleIntent(activity?.intent)
    binding.addOnNewIntentListener {
      handleIntent(it)
      true
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    handleIntent(activity?.intent)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun handleIntent(intent: Intent?) {
    val uri = intent?.getParcelableExtra<Uri>(Intent.EXTRA_STREAM) ?: intent?.data ?: return

    try {
      val mimeType = activity?.contentResolver?.getType(uri)
      if (mimeType != null && supportedMimeTypes.contains(mimeType)) {
        val inputStream = activity?.contentResolver?.openInputStream(uri)
        var fileName = uri.lastPathSegment ?: "shared_file_${UUID.randomUUID()}"

        val extension = when (mimeType) {
          "application/pdf" -> "pdf"
          "application/msword" -> "doc"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" -> "docx"
          "application/vnd.ms-excel" -> "xls"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" -> "xlsx"
          "application/vnd.ms-powerpoint" -> "ppt"
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" -> "pptx"
          else -> ""
        }

        val finalFileName = if (fileName.contains(".")) {
          fileName.substringBeforeLast(".") + "." + extension
        } else {
          fileName + "." + extension
        }

        val file = File(activity?.cacheDir, finalFileName)
        FileOutputStream(file).use { output ->
          inputStream?.copyTo(output)
        }

        sharedFile = file.absolutePath
        // Opsiyonel: Flutter tarafına haber ver
        channel.invokeMethod("onFileShared", null)
      }
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }
}