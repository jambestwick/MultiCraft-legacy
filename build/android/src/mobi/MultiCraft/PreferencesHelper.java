package mobi.MultiCraft;

import android.content.Context;
import android.content.SharedPreferences;

public class PreferencesHelper {
    public static final String SETTINGS = "settings";
    public static final String TAG_SHORTCUT_CREATED = "createShortcut";
    public static final String TAG_BUILD_NUMBER = "buildNumber";
    private static boolean createShortcut;
    private static String buildNumber;
    private static SharedPreferences settings;

    public static boolean isCreateShortcut() {
        return createShortcut;
    }

    public static String getBuildNumber() {
        return buildNumber;
    }

    public static void loadSettings(final Context context) {
        settings = context.getSharedPreferences(SETTINGS, Context.MODE_PRIVATE);
        createShortcut = settings.getBoolean(TAG_SHORTCUT_CREATED, true);
        buildNumber = settings.getString(TAG_BUILD_NUMBER, "0");
    }

    public static void saveSettings(String tag, boolean bool) {
        SharedPreferences.Editor editor = settings.edit();
        editor.putBoolean(tag, bool);
        editor.apply();
    }

    public static void saveSettings(String tag, String value) {
        SharedPreferences.Editor editor = settings.edit();
        editor.putString(tag, value);
        editor.apply();
    }

}