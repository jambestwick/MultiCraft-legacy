package mobi.MultiCraft;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.StatFs;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.ProgressBar;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import static mobi.MultiCraft.PreferencesHelper.TAG_BUILD_NUMBER;
import static mobi.MultiCraft.PreferencesHelper.TAG_SHORTCUT_CREATED;
import static mobi.MultiCraft.PreferencesHelper.getBuildNumber;
import static mobi.MultiCraft.PreferencesHelper.isCreateShortcut;
import static mobi.MultiCraft.PreferencesHelper.loadSettings;
import static mobi.MultiCraft.PreferencesHelper.saveSettings;

public class MainActivity extends Activity {
    public final static String TAG = "Error";
    public final static String CREATE_SHORTCUT = "com.android.launcher.action.INSTALL_SHORTCUT";
    public final static String FILES = Environment.getExternalStorageDirectory() + "/Files.zip";
    public final static String WORLDS = Environment.getExternalStorageDirectory() + "/worlds.zip";
    public final static String GAMES = Environment.getExternalStorageDirectory() + "/games.zip";
    public final static String NOMEDIA = ".nomedia";
    private final static int REQUEST_STORAGE = 0;
    private ProgressDialog mProgressDialog;
    private String dataFolder = "/Android/data/mobi.MultiCraft/files/";
    private String unzipLocation = Environment.getExternalStorageDirectory() + dataFolder;
    private ProgressBar mProgressBar;
    private Utilities util;
    private BroadcastReceiver myReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int progress = intent.getIntExtra(UnzipService.ACTION_PROGRESS, 0);
            if (progress >= 0) {
                mProgressBar.setVisibility(View.VISIBLE);
                mProgressBar.setProgress(progress);
            } else {
                util.createNomedia();
                runGame();
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        setContentView(R.layout.activity_main);
        loadSettings(this);
        IntentFilter filter = new IntentFilter(UnzipService.ACTION_UPDATE);
        registerReceiver(myReceiver, filter);
        if (!isTaskRoot()) {
            finish();
            return;
        }


        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestStoragePermission();
        } else {
            init();
        }
    }

    public void makeFullScreen() {
        if (Build.VERSION.SDK_INT >= 19) {
            this.getWindow().getDecorView()
                    .setSystemUiVisibility(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        }
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            makeFullScreen();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        dismissProgressDialog();
        unregisterReceiver(myReceiver);
    }

    @Override
    protected void onResume() {
        super.onResume();
        makeFullScreen();
    }

    private void addShortcut() {
        saveSettings(TAG_SHORTCUT_CREATED, false);
        Intent shortcutIntent = new Intent(getApplicationContext(), MainActivity.class);
        shortcutIntent.setAction(Intent.ACTION_MAIN);
        Intent addIntent = new Intent();
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, shortcutIntent);
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME, getString(R.string.app_name));
        addIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE,
                Intent.ShortcutIconResource.fromContext(getApplicationContext(), R.drawable.ic_launcher));
        addIntent.setAction(CREATE_SHORTCUT);
        getApplicationContext().sendBroadcast(addIntent);
    }

    @SuppressWarnings("deprecation")
    public void init() {
        RateMe.onStart(this);
        if (isCreateShortcut())
            addShortcut();
        mProgressBar = (ProgressBar) findViewById(R.id.PB1);
        Drawable draw;
        draw = getResources().getDrawable(R.drawable.custom_progress_bar);
        mProgressBar.setProgressDrawable(draw);
        util = new Utilities();
        util.createDataFolder();
        util.checkVersion();
    }

    private void requestPermissionAfterExplain() {
        Toast.makeText(this, R.string.explain, Toast.LENGTH_LONG).show();
        ActivityCompat.requestPermissions(MainActivity.this,
                new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_STORAGE);
    }

    private void requestStoragePermission() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            requestPermissionAfterExplain();
        } else {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    REQUEST_STORAGE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {

        // Check if the only required permission has been granted
        if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            init();
        } else {
            requestStoragePermission();
        }
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

    public void runGame() {
        util.deleteZip(FILES);
        util.deleteZip(WORLDS);
        util.deleteZip(GAMES);
        if (RateMe.shouldShowRateDialog()) {
            hideViews();
            RateMe.showRateDialog(this);
            RateMe.setCallback(new RateMe.Callback() {
                @Override
                public void onPositive() {
                    finish();
                }

                @Override
                public void onNegative() {
                    Toast.makeText(MainActivity.this, R.string.sad, Toast.LENGTH_LONG).show();
                    startGameActivity();
                }

                @Override
                public void onCancelled() {
                    startGameActivity();
                }
            });
        } else {
            startGameActivity();
        }
    }

    private void hideViews() {
        mProgressBar.setVisibility(View.GONE);
        findViewById(R.id.imageView).setVisibility(View.GONE);
        findViewById(R.id.tv_progress_circle).setVisibility(View.GONE);
    }

    private void startGameActivity() {
        Intent intent = new Intent(MainActivity.this, GameActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    private void startUnzipService(String[] file) throws IOException {
        // Start MyIntentService
        Intent intentMyIntentService = new Intent(this, UnzipService.class);
        intentMyIntentService.putExtra(UnzipService.EXTRA_KEY_IN_FILE, file);
        intentMyIntentService.putExtra(UnzipService.EXTRA_KEY_IN_LOCATION, unzipLocation);
        startService(intentMyIntentService);

    }

    private class DeleteTask extends AsyncTask<String, Void, Void> {
        String location;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            showSpinnerDialog(R.string.rm_old);
        }

        @Override
        protected Void doInBackground(String... params) {
            location = params[0];
            for (String p : params) {
                util.deleteFiles(p);
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            if (isFinishing())
                return;
            dismissProgressDialog();
            if (unzipLocation.equals(location)) {
                new CopyZip().execute(FILES, WORLDS, GAMES);
            } else {
                new CopyZip().execute(FILES, GAMES);
            }
        }


    }

    private class CopyZip extends AsyncTask<String, Void, String> {
        String[] zips;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(String... params) {
            zips = params;
            for (String s : zips) {
                copyAssets(s);
            }
            return "Done";

        }

        @Override
        protected void onPostExecute(String result) {
            if (util.getAvailableSpaceInMB() > 15) {
                try {
                    startUnzipService(zips);
                } catch (IOException e) {
                    Log.e(TAG, "unzip failed: " + e.getMessage());
                }
            } else
                Toast.makeText(MainActivity.this, R.string.not_enough_space, Toast.LENGTH_LONG).show();
        }

        private void copyAssets(String zipName) {
            String filename = zipName.substring(zipName.lastIndexOf("/") + 1);
            InputStream in;
            OutputStream out;
            try {
                in = getAssets().open(filename);
                out = new FileOutputStream(zipName);
                copyFile(in, out);
                in.close();
                out.flush();
                out.close();
            } catch (IOException e) {
                Log.e(TAG, "Failed to copy asset file: " + e.getMessage());
            }
        }

        private void copyFile(InputStream in, OutputStream out) throws IOException {
            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
        }
    }

    private class Utilities {

        private void createDataFolder() {
            File folder = new File(unzipLocation);
            if (!(folder.exists()))
                folder.mkdirs();
        }

        private void deleteZip(String fileName) {
            File file = new File(fileName);
            if (file.exists())
                file.delete();
        }

        private void startDeletion(boolean isAll) {
            if (isAll) {
                new DeleteTask().execute(unzipLocation);
            } else {
                new DeleteTask().execute(unzipLocation + "games", unzipLocation + "debug.txt");
            }
        }

        @SuppressWarnings("deprecation")
        @SuppressLint("NewApi")
        private long getAvailableSpaceInMB() {
            final long SIZE_KB = 1024L;
            final long SIZE_MB = SIZE_KB * SIZE_KB;
            long availableSpace;
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            if (Build.VERSION.SDK_INT > 17) {
                availableSpace = stat.getAvailableBlocksLong() * stat.getBlockSizeLong();
            } else {
                availableSpace = (long) stat.getAvailableBlocks() * (long) stat.getBlockSize();
            }
            return availableSpace / SIZE_MB;
        }

        public void checkVersion() {
            if (getBuildNumber().equals(getString(R.string.ver))) {
                runGame();
            } else if (getBuildNumber().equals("0")) {
                saveSettings(TAG_BUILD_NUMBER, getString(R.string.ver));
                startDeletion(true);
            } else {
                saveSettings(TAG_BUILD_NUMBER, getString(R.string.ver));
                startDeletion(false);
            }
        }

        private void deleteFiles(String path) {
            File file = new File(path);
            if (file.exists()) {
                String deleteCmd = "rm -r " + path;
                Runtime runtime = Runtime.getRuntime();
                try {
                    runtime.exec(deleteCmd);
                } catch (IOException e) {
                    Log.e(TAG, "delete files failed: " + e.getLocalizedMessage());
                }
            }
        }

        public void createNomedia() {
            File myFile = new File(unzipLocation, NOMEDIA);
            if (!myFile.exists())
                try {
                    myFile.createNewFile();
                } catch (IOException e) {
                    Log.e(TAG, "nomedia has not been created: " + e.getMessage());
                }
        }
    }
}