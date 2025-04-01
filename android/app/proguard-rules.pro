# Keep Play Core classes (required for dynamic delivery)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }

# Keep Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.app.** { *; }