package net.minetest.minetest;

import android.app.NativeActivity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.view.WindowManager;

import com.MoNTE48.MultiCraft.Utilities;
import com.MoNTE48.MultiCraft.Utilities.IUtilitiesCallback;
import com.MoNTE48.RateME.RateThisApp;

public class MtNativeActivity extends NativeActivity implements
		IUtilitiesCallback {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		m_MessagReturnCode = -1;
		m_MessageReturnValue = "";
		RateThisApp.onStart(this);
		startDialogs();
	}

	private void startDialogs() {
		final Handler handler = new Handler();
		handler.postDelayed(new Runnable() {
			@Override
			public void run() {
				Utilities util = new Utilities(MtNativeActivity.this);
				util.showHelpDialog();
				SharedPreferences settings = MtNativeActivity.this
						.getSharedPreferences(Utilities.PREFS_NAME, 0);
				String skipMessage = settings.getString("skipMessage",
						"NOT checked");
				if ("checked".equalsIgnoreCase(skipMessage)) {
					if (RateThisApp.shouldShowRateDialog()) {
						RateThisApp
								.showRateDialogIfNeeded(MtNativeActivity.this);
					} else
						util.showVersionDialog();
				}
			}
		}, 1000);

	}

	public void copyAssets() {
	}

	public void showDialog(String acceptButton, String hint, String current,
			int editType) {
		Intent intent = new Intent(this, MinetestTextEntry.class);
		Bundle params = new Bundle();
		params.putString("acceptButton", acceptButton);
		params.putString("hint", hint);
		params.putString("current", current);
		params.putInt("editType", editType);
		intent.putExtras(params);
		startActivityForResult(intent, 101);
		m_MessageReturnValue = "";
		m_MessagReturnCode = -1;
	}

	public static native void putMessageBoxResult(String text);

	public int getDialogState() {
		return m_MessagReturnCode;
	}

	public String getDialogValue() {
		m_MessagReturnCode = -1;
		return m_MessageReturnValue;
	}

	public float getDensity() {
		return getResources().getDisplayMetrics().density;
	}

	public int getDisplayWidth() {
		return getResources().getDisplayMetrics().widthPixels;
	}

	public int getDisplayHeight() {
		return getResources().getDisplayMetrics().heightPixels;
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == 101) {
			if (resultCode == RESULT_OK) {
				String text = data.getStringExtra("text");
				m_MessagReturnCode = 0;
				m_MessageReturnValue = text;
			} else {
				m_MessagReturnCode = 1;
			}
		}
	}

	static {
		System.loadLibrary("openal");
		System.loadLibrary("ogg");
		System.loadLibrary("vorbis");
		System.loadLibrary("ssl");
		System.loadLibrary("crypto");
	}

	private int m_MessagReturnCode;
	private String m_MessageReturnValue;

	@Override
	public void init() {

	}
}