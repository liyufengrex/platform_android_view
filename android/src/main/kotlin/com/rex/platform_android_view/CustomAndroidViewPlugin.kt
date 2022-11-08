package com.rex.platform_android_view

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CustomAndroidViewPlugin: FlutterPlugin, ActivityAware {

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding.platformViewRegistry
      .registerViewFactory(
        VIEW_TYPE_ID,
        CustomViewFactory(flutterPluginBinding.binaryMessenger)
      )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    CustomShared.activity = null
    CustomShared.binding = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    CustomShared.activity = binding.activity
    CustomShared.binding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    CustomShared.activity = null
    CustomShared.binding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    CustomShared.activity = binding.activity
    CustomShared.binding = binding
  }

  override fun onDetachedFromActivity() {
    CustomShared.activity = null
    CustomShared.binding = null
  }

  companion object {
    private const val VIEW_TYPE_ID = "com.rex.custom.android/customView"
  }
}
