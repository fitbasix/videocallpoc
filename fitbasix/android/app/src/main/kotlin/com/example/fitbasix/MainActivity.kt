package com.example.fitbasix

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import android.content.Context
import android.os.Bundle
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine) //
        flutterEngine.getPlugins().add(SharedPreferencesPlugin())// missing this
    }
}
