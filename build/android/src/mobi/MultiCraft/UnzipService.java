package mobi.MultiCraft;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class UnzipService extends IntentService {
	public final String TAG = UnzipService.class.getSimpleName();
	public static final String ACTION_UPDATE = "mobi.MultiCraft.UPDATE";
	public static final String EXTRA_KEY_IN_FILE = "file";
	public static final String EXTRA_KEY_IN_LOCATION = "location";
	public static final String ACTION_PROGRESS = "progress";
	private NotificationManager mNotifyManager;
	private int id = 1;

	public UnzipService() {
		super("mobi.MultiCraft.UnzipService");
	}

	private void _dirChecker(String dir, String unzipLocation) {
		File f = new File(unzipLocation + dir);

		if (!f.isDirectory()) {
			f.mkdirs();
		}
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		mNotifyManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		Notification.Builder mBuilder = new Notification.Builder(this);
		mBuilder.setContentTitle(getString(R.string.notification_title))
				.setContentText(getString(R.string.notification_description)).setSmallIcon(R.drawable.update);
		String[] file = intent.getStringArrayExtra(EXTRA_KEY_IN_FILE);
		String location = intent.getStringExtra(EXTRA_KEY_IN_LOCATION);

		mNotifyManager.notify(id, mBuilder.build());
		int per = 0;
		for (String f : file) {
			try {

				ZipFile zipSize = new ZipFile(f);

				try {
					FileInputStream fin = new FileInputStream(f);
					ZipInputStream zin = new ZipInputStream(fin);
					ZipEntry ze;
					while ((ze = zin.getNextEntry()) != null) {
						if (ze.isDirectory()) {
							per++;
							_dirChecker(ze.getName(), location);
						} else {
							per++;
							int progress = 100 * per / zipSize.size();
							// send update
							publishProgress(progress);
							FileOutputStream f_out = new FileOutputStream(location + ze.getName());
							byte[] buffer = new byte[8192];
							int len;
							while ((len = zin.read(buffer)) != -1) {
								f_out.write(buffer, 0, len);
							}
							f_out.close();
							zin.closeEntry();
							f_out.close();
						}
					}
					zin.close();
				} catch (FileNotFoundException e) {
					Log.e(TAG, e.getMessage(), e.fillInStackTrace());
				}
			} catch (IOException e) {
				Log.e(TAG, e.getLocalizedMessage());
			}
		}
	}

	private void publishProgress(int progress) {
		Intent intentUpdate = new Intent(ACTION_UPDATE);
		intentUpdate.putExtra(ACTION_PROGRESS, progress);
		sendBroadcast(intentUpdate);
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		mNotifyManager.cancel(id);
		publishProgress(-1);
	}
}
