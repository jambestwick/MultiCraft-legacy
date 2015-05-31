package com.MoNTE48.MultiCraft;

import static com.MoNTE48.MultiCraft.PreferencesHelper.TAG_SHORTCUT_CREATED;
import static com.MoNTE48.MultiCraft.PreferencesHelper.isCreateShortcut;
import static com.MoNTE48.MultiCraft.PreferencesHelper.saveSettings;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import mobi.MultiCraft.R;
import net.minetest.minetest.MtNativeActivity;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.WindowManager;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.MoNTE48.MultiCraft.Utilities.IUtilitiesCallback;

public class MainActivity extends Activity implements IUtilitiesCallback {
	private final String TAG = MainActivity.class.getName();
	public final String FILES = "Files.zip";
	public final String NOMEDIA = ".nomedia";
	private ProgressDialog mProgressDialog;
	private TextView mProgressTextView;
	private String unzipLocation = Environment.getExternalStorageDirectory()
			+ "/MultiCraft/";
	private File version;
	private Utilities util;
	private ProgressBar mProgressBar;
	private MyBroadcastReceiver myBroadcastReceiver;
	private MyBroadcastReceiver_Update myBroadcastReceiver_Update;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		util = new Utilities(this);
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		registerReceivers();
	}

	@Override
	protected void onStart() {
		super.onStart();
		if (util.getTotalMemoryInMB() < 800 || util.getCoresCount() < 2) {
			util.showMemoryDialog();
		} else {
			init();
		}
	}

	private void createDirAndNoMedia() {
		try {
			File folder = new File(unzipLocation);
			if (!(folder.exists()))
				folder.mkdirs();
			File myFile = new File(unzipLocation, NOMEDIA);
			if (!myFile.exists())
				myFile.createNewFile();
		} catch (IOException e) {
			Log.e(TAG, e.getMessage());
		}
	}

	private void addShortcut() {
		saveSettings(this, TAG_SHORTCUT_CREATED, false);
		Intent shortcutIntent = new Intent(getApplicationContext(),
				MainActivity.class);
		shortcutIntent.setAction(Intent.ACTION_MAIN);
		Intent addIntent = new Intent();
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, shortcutIntent);
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME,
				getString(R.string.app_name));
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE,
				Intent.ShortcutIconResource.fromContext(
						getApplicationContext(), R.drawable.ic_launcher));
		addIntent.setAction("com.android.launcher.action.INSTALL_SHORTCUT");
		getApplicationContext().sendBroadcast(addIntent);
	}

	@SuppressWarnings("deprecation")
	public void init() {
		PreferencesHelper.loadSettings(this);
		if (isCreateShortcut())
			addShortcut();
		mProgressTextView = (TextView) findViewById(R.id.progress_textView);
		mProgressBar = (ProgressBar) findViewById(R.id.PB1);
		Drawable draw;
		if (Build.VERSION.SDK_INT > 21) {
			draw = getResources().getDrawable(R.drawable.custom_progress_bar,
					null);
		} else {
			draw = getResources().getDrawable(R.drawable.custom_progress_bar);
		}

		mProgressBar.setProgressDrawable(draw);
		createDirAndNoMedia();
		version = new File(unzipLocation + "ver.txt");
		checkVersion();
	}

	@Override
	public void finishMe() {
		finish();
	}

	private void registerReceivers() {
		myBroadcastReceiver = new MyBroadcastReceiver();
		myBroadcastReceiver_Update = new MyBroadcastReceiver_Update();
		IntentFilter intentFilter = new IntentFilter(
				UnzipService.ACTION_MyIntentService);
		intentFilter.addCategory(Intent.CATEGORY_DEFAULT);
		registerReceiver(myBroadcastReceiver, intentFilter);
		IntentFilter intentFilter_update = new IntentFilter(
				UnzipService.ACTION_MyUpdate);
		intentFilter_update.addCategory(Intent.CATEGORY_DEFAULT);
		registerReceiver(myBroadcastReceiver_Update, intentFilter_update);
	}

	private void showSpinnerDialog(int message) {
		if (mProgressDialog == null) {
			mProgressDialog = new ProgressDialog(MainActivity.this);
			mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
			mProgressDialog.setCancelable(false);
		}
		mProgressDialog.setMessage(getString(message));
		mProgressDialog.show();
	}

	private void dismissProgressDialog() {
		if (mProgressDialog != null && mProgressDialog.isShowing()) {
			mProgressDialog.dismiss();
		}
	}

	private void checkVersion() {
		if (version.exists()) {
			switch (util.compareVersions(version)) {
			case OLD:
				new DeleteTask().execute(unzipLocation + "cache", unzipLocation
						+ "games/MultiCraft II", unzipLocation + "tmp");
				break;
			case CURRENT:
				startNativeActivity();
				break;
			}
		} else {
			new DeleteTask().execute(unzipLocation + "cache", unzipLocation
					+ "games/MultiCraft II", unzipLocation + "tmp");
		}
	}

	private void startNativeActivity() {
		showSpinnerDialog(R.string.loading);
		new Thread(new Runnable() {
			public void run() {
				Intent intent = new Intent(MainActivity.this,
						MtNativeActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
						| Intent.FLAG_ACTIVITY_CLEAR_TASK);
				startActivity(intent);
				if (isFinishing())
					return;
				dismissProgressDialog();
			}
		}).start();
		File file = new File(Environment.getExternalStorageDirectory(), FILES);
		if (file.exists())
			file.delete();
	}

	private void startUnzipService(String file) throws IOException {
		// Start MyIntentService
		Intent intentMyIntentService = new Intent(this, UnzipService.class);
		intentMyIntentService.putExtra(UnzipService.EXTRA_KEY_IN_FILE, file);
		intentMyIntentService.putExtra(UnzipService.EXTRA_KEY_IN_LOCATION,
				unzipLocation);
		startService(intentMyIntentService);

	}

	public class MyBroadcastReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			String result = intent.getStringExtra(UnzipService.EXTRA_KEY_OUT);
			if ("Success".equals(result))
				startNativeActivity();

		}
	}

	public class MyBroadcastReceiver_Update extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			int update = intent.getIntExtra(UnzipService.EXTRA_KEY_UPDATE, 0);
			mProgressBar.setProgress(update);
			mProgressTextView.setText(update + "%");
		}
	}

	private class DeleteTask extends AsyncTask<String, Void, Void> {
		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			showSpinnerDialog(R.string.rm_old);
		}

		@Override
		protected Void doInBackground(String... params) {
			for (String p : params) {
				deleteFiles(p);
			}
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			if (isFinishing())
				return;
			dismissProgressDialog();
			new CopyZip().execute(FILES);
		}

		private void deleteFiles(String path) {
			File file = new File(path);
			if (file.exists()) {
				String deleteCmd = "rm -r " + path;
				Runtime runtime = Runtime.getRuntime();
				try {
					runtime.exec(deleteCmd);
				} catch (IOException e) {
					Log.e(TAG, e.getLocalizedMessage());
				}
			}
		}
	}

	private class CopyZip extends AsyncTask<String, Void, String> {
		String zipName;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			showSpinnerDialog(R.string.copy);
		}

		@Override
		protected String doInBackground(String... params) {
			zipName = params[0];
			copyAssets(zipName);
			return "Done";

		}

		@Override
		protected void onPostExecute(String result) {
			if (isFinishing())
				return;
			dismissProgressDialog();
			if (util.getAvailableSpaceInMB() > 30) {
				try {
					startUnzipService(Environment.getExternalStorageDirectory()
							+ "/" + zipName);
				} catch (IOException e) {
					Log.e(TAG, e.getMessage());
				}
			} else
				util.showNotEnoughSpaceDialog();
		}

		private void copyAssets(String zipName) {
			InputStream in;
			OutputStream out;
			try {
				in = getAssets().open(zipName);
				out = new FileOutputStream(
						Environment.getExternalStorageDirectory() + "/"
								+ zipName);
				copyFile(in, out);
				in.close();
				out.flush();
				out.close();
			} catch (IOException e) {
				Log.e(TAG, "Failed to copy asset file: " + e.getMessage());
			}
		}

		private void copyFile(InputStream in, OutputStream out)
				throws IOException {
			byte[] buffer = new byte[1024];
			int read;
			while ((read = in.read(buffer)) != -1) {
				out.write(buffer, 0, read);
			}
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		dismissProgressDialog();
		unregisterReceiver(myBroadcastReceiver);
		unregisterReceiver(myBroadcastReceiver_Update);
	}
}