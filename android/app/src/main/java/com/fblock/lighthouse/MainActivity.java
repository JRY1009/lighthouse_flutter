package com.fblock.lighthouse;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.meituan.android.walle.WalleChannelReader;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL_LIGHTHOUSE = "fblock.lighthouse/methodchannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_LIGHTHOUSE).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("getChannel")) {
                            String channel = WalleChannelReader.getChannel(getApplication());

                            if (TextUtils.isEmpty(channel)) {
                                result.success("official");
                            } else {
                                result.success(channel);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }
}
