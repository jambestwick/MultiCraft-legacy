package mobi.MultiCraft;

import com.winsontan520.wversionmanager.library.WVersionManager;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

public class PreferencesHelper {
	public static final int MEMORY_DIALOG = 1;
	public static final int VERSION_DIALOG = 1 << 1;
	public static final int RATE_DIALOG = 1 << 2;
	public static final int HELP_DIALOG = 1 << 3;
	public static final int[] DIALOGS = { MEMORY_DIALOG, VERSION_DIALOG, RATE_DIALOG, HELP_DIALOG };
	public static final String SETTINGS = "settings";
	public static final String TAG_SHORTCUT_CREATED = "createShortcut";
	public static final String TAG_HELP_SHOWED = "showHelp";
	public static final String TAG_RATE_SHOWED = "showRate";
	public static final String TAG_CPU_SHOWED = "showCpuCheck";
	public static final String TAG_VERSION_SHOWED = "showVersionCheck";
	private static boolean disabledADS, createShortcut;
	private static int bitMask;

	public static boolean isCreateShortcut() {
		return createShortcut;
	}

	public static int getBitMask() {
		return bitMask;
	}

	public static boolean isAdsDisabled() {
		return disabledADS;
	}

	public static void loadSettings(Context c) {
		saveSettings(c, TAG_CPU_SHOWED, PhoneInformation.getCoresCount() < 4);
		saveSettings(c, TAG_RATE_SHOWED, RateThisApp.shouldShowRateDialog());
		WVersionManager versionManager = new WVersionManager((Activity) c);
		versionManager.setVersionContentUrl("http://MultiCraft.mobi/ver/MultiCraft.txt");
		versionManager.checkVersion();
		SharedPreferences settings = c.getSharedPreferences(SETTINGS, Context.MODE_PRIVATE);
		createShortcut = settings.getBoolean(TAG_SHORTCUT_CREATED, true);
		boolean showHelp = settings.getBoolean(TAG_HELP_SHOWED, true);
		boolean showRate = settings.getBoolean(TAG_RATE_SHOWED, false);
		boolean showCPUCheck = settings.getBoolean(TAG_CPU_SHOWED, false);
		boolean showVersionCheck = settings.getBoolean(TAG_VERSION_SHOWED, false);
		bitMask = (showHelp ? HELP_DIALOG : 0) + (showCPUCheck ? MEMORY_DIALOG : 0) + (showRate ? RATE_DIALOG : 0)
				+ (showVersionCheck ? VERSION_DIALOG : 0);
	}

	public static void saveSettings(Context c, String tag, boolean bool) {
		SharedPreferences settings = c.getSharedPreferences(SETTINGS, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		editor.putBoolean(tag, bool);
		editor.apply();
	}

}