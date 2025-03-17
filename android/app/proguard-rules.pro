# Flutter giữ lại tất cả class cần thiết
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Giữ lại tất cả các class của Google Play Services
-keep class com.google.android.gms.** { *; }
-keep class com.google.maps.** { *; }

# Giữ lại các class cần thiết cho Firebase (nếu có sử dụng Firebase)
-keep class com.google.firebase.** { *; }

# Giữ lại các class cần thiết cho JSON parsing
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-keep class org.json.** { *; }

# Bảo vệ các class liên quan đến API ẩn của Android
-keep class sun.misc.Unsafe { *; }
-keep class dalvik.system.VMStack { *; }
-keep class libcore.io.Memory { *; }

# Giữ lại code liên quan đến Retrofit (nếu có sử dụng)
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }

# Giữ lại các class UI của AndroidX
-keep class androidx.lifecycle.** { *; }
-keep class androidx.appcompat.** { *; }

# Ngăn chặn lỗi với reflection
-keepattributes *Annotation*

# Không tối ưu hoặc loại bỏ các class của Gson (nếu sử dụng)
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# Giữ lại các class liên quan đến WebView (nếu có sử dụng)
-keep class android.webkit.WebView { *; }
-keep class android.webkit.WebSettings { *; }

# Cho phép truy cập các method private để tránh lỗi với thư viện bên thứ ba
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Tránh lỗi do obfuscation với Google Maps
-keep class com.google.maps.android.** { *; }

# Chặn warning khi minify code
-dontwarn sun.misc.**
-dontwarn org.codehaus.mojo.**
-dontwarn com.google.android.gms.**

# Không xóa annotation (cần cho một số thư viện như Firebase)
-keepattributes *Annotation*

# Tối ưu hóa nhưng giữ lại các method native
-keepclasseswithmembernames class * {
    native <methods>;
}

# Chặn tối ưu hóa quá mức gây crash
-dontshrink
-dontoptimize
