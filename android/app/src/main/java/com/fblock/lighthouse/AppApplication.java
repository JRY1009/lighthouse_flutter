package com.fblock.lighthouse;

import android.app.Activity;
import com.tencent.tinker.loader.app.TinkerApplication;
import com.tencent.tinker.loader.shareutil.ShareConstants;


public class AppApplication extends TinkerApplication {

    public AppApplication() {
        super(ShareConstants.TINKER_ENABLE_ALL, "com.fblock.lighthouse.AppApplicationLike",
                "com.tencent.tinker.loader.TinkerLoader", false, true);
    }

    private Activity mCurrentActivity = null;

    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }
}
