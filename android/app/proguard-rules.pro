# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-dontshrink
-dontoptimize
-ignorewarnings

#保护注解
-keepattributes *Annotation*
-keepattributes *JavascriptInterface*

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.content.pm
-keep public class * extends java.lang.Throwable {*;}
-keep public class * extends java.lang.Exception {*;}
-keep public class * extends java.lang.reflect {*;}
-keep public class * extends java.lang.**
-keep public class * extends android.preference.Preference
-keep public class * extends org.apache.http.**

-keep class org.apache.http.** {*;}

-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

-keepclassmembers class * implements android.os.Parcelable {
    static android.os.Parcelable$Creator CREATOR;
}

-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

-keepclassmembers class **.R$* {
  public static <fields>;
}

-dontnote com.android.vending.licensing.ILicensingService

-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclassmembers class * extends java.lang.Enum {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}


# adding this in to preserve line numbers so that the stack traces
# can be remapped
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature

-keep public interface com.fblock.lighthouse.trans.IResponse {*;}

# COMMON
-dontwarn okio.**
-dontwarn com.squareup.wire.**
-keep class okio.** {*;}
-keep class com.squareup.wire.** {*;}

-keep public class android.net.http.SslError

-dontwarn android.webkit.WebView
-dontwarn android.net.http.SslError
-dontwarn Android.webkit.WebViewClient

-keep public class com.fblock.lighthouse.R$*{
    public static final int *;
}

# MeiZuFingerprint
-keep class com.fingerprints.service.** { *; }

# SmsungFingerprint
-keep class com.samsung.android.sdk.** { *; }

#Wechat
-keep class com.tencent.mm.opensdk.** { *; }

-keep class com.tencent.wxop.** { *; }

-keep class com.tencent.mm.sdk.** { *; }

#netease captcha
-keep public class com.netease.nis.captcha.**{*;}

-keep public class android.webkit.**

-keepattributes SetJavaScriptEnabled
-keepattributes JavascriptInterface

-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keep class com.fblock.lighthouse.trans.data.** { *; }

#crashreporter
-keep class com.alibaba.motu.crashreporter.MotuCrashReporter{*;}
-keep class com.alibaba.motu.crashreporter.ReporterConfigure{*;}
-keep class com.alibaba.motu.crashreporter.IUTCrashCaughtListener{*;}
-keep class com.ut.mini.crashhandler.IUTCrashCaughtListener{*;}
-keep class com.alibaba.motu.crashreporter.utrestapi.UTRestReq{*;}
-keep class com.alibaba.motu.crashreporter.handler.nativeCrashHandler.NativeCrashHandler{*;}
-keep class com.alibaba.motu.crashreporter.handler.nativeCrashHandler.NativeExceptionHandler{*;}
-keep interface com.alibaba.motu.crashreporter.handler.nativeCrashHandler.NativeExceptionHandler{*;}
#crashreporter3.0以后 一定要加这个
-keep class com.uc.crashsdk.JNIBridge{*;}

#防止混淆AliRtcSDK公共类名称
-keep class com.serenegiant.**{*;}
-keep class org.webrtc.**{*;}

####################友盟数据统计############
-keep class com.umeng.** {*;}
-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
######################conan混淆配置#########################
-keepattributes *Annotation*
-keep class com.alivc.conan.DoNotProguard
-keep,allowobfuscation @interface com.alivc.conan.DoNotProguard
-keep @com.alivc.conan.DoNotProguard class *
-keepclassmembers class * {
    @com.alivc.conan.DoNotProguard *;
}
######################短视频混淆配置#########################
-keep class com.aliyun.**{*;}
-keep class com.duanqu.**{*;}
-keep class com.qu.**{*;}
-keep class com.alibaba.**{*;}
-keep class component.alivc.**{*;}
-keep class com.alivc.**{*;}
-keep enum com.aliyun.editor.AudioEffectType { *; }
######################播放器混淆配置#########################
-keep class com.cicada.**{*;}

######################glide 混淆配置#########################
-keep class com.bumptech.glide{*;}
-keep class com.bumptech.glide.**{*;}


#cps
######################cps混淆配置#########################
-keep class com.taobao.** {*;}
-keep class com.alibaba.** {*;}
-keep class com.ta.**{*;}
-keep class com.ut.**{*;}
-dontwarn com.taobao.**
-dontwarn com.alibaba.**
-dontwarn com.ta.**
-dontwarn com.ut.**
-keepclasseswithmembernames class ** {
native <methods>;
}
-keepattributes Signature
-keep class sun.misc.Unsafe { *; }
-keep class com.alipay.** {*;}
-dontwarn com.alipay.**
-keep class anet.**{*;}
-keep class org.android.spdy.**{*;}
-keep class org.android.agoo.**{*;}
-dontwarn anet.**
-dontwarn org.android.spdy.**
-dontwarn org.android.agoo.**

######################oss混淆配置#########################
-keep class com.alibaba.sdk.android.oss.** { *; }
-dontwarn okio.**
-dontwarn org.apache.commons.codec.binary.**
-keep class org.apache.commons.**{ *;}
-keep class com.alibaba.sdk.*{ *;}

######################rongcloud混淆配置#########################
-keepattributes Exceptions,InnerClasses
-keepattributes Signature
-keep class io.rong.** {*;}
-keep class cn.rongcloud.** {*;}
-keep class * implements io.rong.imlib.model.MessageContent {*;}
-keep class io.rong.app.DemoNotificationReceiver {*;}
-dontwarn io.rong.push.**
-dontnote com.xiaomi.**
-dontnote com.google.android.gms.gcm.**
-dontnote io.rong.**

# Location
-keep class com.amap.api.**{*;}
-keep class com.amap.api.services.**{*;}

######################活体人脸检查混淆配置#########################
-keep class com.taobao.securityjni.**{*;}
-keep class com.taobao.wireless.security.**{*;}
-keep class com.ut.secbody.**{*;}
-keep class com.taobao.dp.**{*;}
-keep class com.alibaba.wireless.security.**{*;}
-keep class com.alibaba.security.rp.**{*;}
-keep class com.alibaba.sdk.android.**{*;}
-keep class com.alibaba.security.biometrics.**{*;}
-keep class android.taobao.windvane.**{*;}

######################RongIM#########################
-keepattributes Exceptions,InnerClasses

-keepattributes Signature

#RongRTCLib
-keep public class cn.rongcloud.** {*;}

#RongIMLib
-keep class io.rong.** {*;}
-keep class cn.rongcloud.** {*;}
-keep class * implements io.rong.imlib.model.MessageContent {*;}
-dontwarn io.rong.push.**
-dontnote com.xiaomi.**
-dontnote com.google.android.gms.gcm.**
-dontnote io.rong.**

-ignorewarnings
-keep class com.fblock.lighthouse.component.RongPushMessageReceiver {*;}

-keep class cn.rongcloud.rtc.core.**  { *; }
-keep class cn.rongcloud.rtc.engine.binstack.json.**  { *; }

-keep class com.blink.**  { *; }
-keep class com.bailingcloud.bailingvideo.engine.binstack.json.**  { *; }
-keep class bailingquic.**{*;}
-keep class go.**{*;}

######################mipush#########################
-dontwarn com.xiaomi.mipush.sdk.**
-keep public class com.xiaomi.mipush.sdk.* {*; }

######################oppo#########################
-keep public class * extends android.app.Service
-keep class com.heytap.msp.** { *;}

######################vivo#########################
-dontwarn com.vivo.push.**
-keep class com.vivo.push.**{*; }
-keep class com.vivo.vms.**{*; }

######################huawei push#########################
-keep class com.hianalytics.android.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}

-keep class com.huawei.gamebox.plugin.gameservice.**{*;}

-keep public class com.huawei.android.hms.agent.** extends android.app.Activity { public *; protected *; }
-keep interface com.huawei.android.hms.agent.common.INoProguard {*;}
-keep class * extends com.huawei.android.hms.agent.common.INoProguard {*;}

######################Matisse#########################
-dontwarn com.squareup.picasso.**

######################ucrop#########################
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

######################bugly#########################
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}