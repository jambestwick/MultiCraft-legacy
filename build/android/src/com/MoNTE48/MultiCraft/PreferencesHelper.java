package com.MoNTE48.MultiCraft;

import android.content.Context;
import android.content.SharedPreferences;

public class PreferencesHelper {
	private static final String SETTINGS = "settings";
	public static final String TAG_SHORTCUT_CREATED = "createShortcut";
	public static final String TAG_HELP_SHOWED = "showHelp";
	private static boolean createShortcut, showHelp;

	public static boolean isCreateShortcut() {
		return createShortcut;
	}

	public static boolean isShowHelp() {
		return showHelp;
	}

	public static void loadSettings(Context c) {

		SharedPreferences settings = c.getSharedPreferences(SETTINGS,
				Context.MODE_PRIVATE);
		if (settings.getAll().size() == 0) {
			SharedPreferences.Editor editor = settings.edit();
			editor.clear();
			editor.commit();
			createShortcut = true;
			showHelp = true;
		} else {
			createShortcut = settings.getBoolean(TAG_SHORTCUT_CREATED, true);
			showHelp = settings.getBoolean(TAG_HELP_SHOWED, true);
		}

	}

	public static void saveSettings(Context c, String tag, boolean bool) {
		SharedPreferences settings = c.getSharedPreferences(SETTINGS,
				Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		editor.putBoolean(tag, bool);
		editor.commit();
	}
}
