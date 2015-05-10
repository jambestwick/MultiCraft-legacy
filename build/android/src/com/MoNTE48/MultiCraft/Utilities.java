package com.MoNTE48.MultiCraft;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Pattern;

import mobi.MultiCraft.R;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.MoNTE48.RateME.RateThisApp;
import com.winsontan520.wversionmanager.library.WVersionManager;

/**
 * Helpful utilities used in MainActivity
 */
public class Utilities {
	public enum VERSIONS {
		CURRENT, OLD
	}

	private final String TAG = Utilities.class.getName();
	private Context mContext;
	public static final String PREFS_NAME = "ShowFirstTime";

	public final String STABLE_VER = "1.0.1";

	/**
	 * Callback for MainActivity init method
	 *
	 */
	public interface IUtilitiesCallback {
		void init();
	}

	private IUtilitiesCallback callerActivity;

	public Utilities(Activity activity) {
		mContext = activity;
		callerActivity = (IUtilitiesCallback) activity;
	}

	@SuppressLint("InflateParams")
	public void showHelpDialog() {
		LayoutInflater inflater = LayoutInflater.from(mContext);
		View messageView = inflater.inflate(R.layout.instruction_dialog, null,
				false);
		final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
		builder.setView(messageView);
		builder.setPositiveButton(R.string.ok,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						RateThisApp.showRateDialogIfNeeded(mContext);
					}
				});
		builder.setNegativeButton(R.string.forget,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						String checkBoxResult = "checked";
						SharedPreferences settings = mContext
								.getSharedPreferences(PREFS_NAME, 0);
						SharedPreferences.Editor editor = settings.edit();
						editor.putString("skipMessage", checkBoxResult);
						editor.apply();
						RateThisApp.showRateDialogIfNeeded(mContext);
					}
				});
		SharedPreferences settings = mContext.getSharedPreferences(PREFS_NAME,
				0);
		String skipMessage = settings.getString("skipMessage", "NOT checked");
		if (!"checked".equalsIgnoreCase(skipMessage))
			builder.show();
	}

	public void showVersionDialog() {
		WVersionManager versionManager = new WVersionManager(
				(Activity) mContext);
		versionManager
				.setVersionContentUrl("http://185.61.149.209/ver/MC2.txt");
		versionManager.checkVersion();
		versionManager.setUpdateNowLabel((String) mContext.getResources()
				.getText(R.string.update_yes));
		versionManager.setRemindMeLaterLabel((String) mContext.getResources()
				.getText(R.string.update_no));
		versionManager.setIgnoreThisVersionLabel((String) mContext
				.getResources().getText(R.string.update_ignore));
	}

	public void showMemoryDialog(final Activity activity) {
		final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
		builder.setTitle(R.string.memory_title);
		builder.setMessage(R.string.memory_warning);
		builder.setPositiveButton(R.string.memory_continue,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						Toast.makeText(mContext, R.string.memory_lags,
								Toast.LENGTH_SHORT).show();
						callerActivity.init();
					}
				});
		builder.setNegativeButton(R.string.memory_close,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						activity.finish();
					}
				});
		builder.setCancelable(false);
		builder.show();
	}

	public void showNotEnoughSpaceDialog(final Activity activity) {
		final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
		builder.setTitle(R.string.memory_title);
		builder.setMessage(R.string.not_enough_space);
		builder.setPositiveButton(R.string.space_ok,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						activity.finish();
					}
				});
		builder.setCancelable(false);
		builder.show();
	}

	public long getTotalMemoryInMB() {
		long initial_memory;
		if (Build.VERSION.SDK_INT > 17) {
			ActivityManager actManager = (ActivityManager) mContext
					.getSystemService(Context.ACTIVITY_SERVICE);
			ActivityManager.MemoryInfo memInfo = new ActivityManager.MemoryInfo();
			actManager.getMemoryInfo(memInfo);
			initial_memory = memInfo.totalMem;
		} else {
			String str1 = "/proc/meminfo";
			String str2;
			String[] arrayOfString;

			try {
				FileReader localFileReader = new FileReader(str1);
				BufferedReader localBufferedReader = new BufferedReader(
						localFileReader, 8192);
				str2 = localBufferedReader.readLine();// meminfo
				arrayOfString = str2.split("\\s+");
				// total Memory
				initial_memory = Integer.valueOf(arrayOfString[1]) * 1024;
				localBufferedReader.close();
			} catch (IOException e) {
				return -1;
			}
		}
		return initial_memory / 1024 / 1024;
	}

	public int getCoresCount() {
		class CpuFilter implements FileFilter {
			@Override
			public boolean accept(final File pathname) {
				return Pattern.matches("cpu[0-9]+", pathname.getName());
			}
		}
		try {
			final File dir = new File("/sys/devices/system/cpu/");
			final File[] files = dir.listFiles(new CpuFilter());
			return files.length;
		} catch (final Exception e) {
			return Math.max(1, Runtime.getRuntime().availableProcessors());
		}
	}

	@SuppressWarnings("deprecation")
	public long getAvailableSpaceInMB() {
		final long SIZE_KB = 1024L;
		final long SIZE_MB = SIZE_KB * SIZE_KB;
		long availableSpace;
		StatFs stat = new StatFs(Environment.getExternalStorageDirectory()
				.getPath());
		if (Build.VERSION.SDK_INT > 17) {
			availableSpace = stat.getAvailableBlocksLong()
					* stat.getBlockSizeLong();
		} else {
			availableSpace = (long) stat.getAvailableBlocks()
					* (long) stat.getBlockSize();
		}
		return availableSpace / SIZE_MB;
	}

	public VERSIONS compareVersions(File file) {
		VERSIONS result;
		String line = null;
		try {
			line = new BufferedReader(new FileReader(file)).readLine();
		} catch (IOException e) {
			Log.e(TAG, e.getMessage());
		}

		if (line == null) {
			line = "-999";
		}
		if (line.equals(STABLE_VER)) {
			result = VERSIONS.CURRENT;
		} else
			result = VERSIONS.OLD;
		return result;
	}

}
