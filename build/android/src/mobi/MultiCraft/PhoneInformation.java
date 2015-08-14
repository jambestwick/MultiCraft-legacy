package mobi.MultiCraft;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Pattern;

import android.annotation.SuppressLint;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;

public class PhoneInformation {

	public static long getTotalMemoryInMB() {
		long initial_memory;
		/*
		 * if (Build.VERSION.SDK_INT > 17) { ActivityManager actManager =
		 * (ActivityManager)
		 * mContext.getSystemService(Context.ACTIVITY_SERVICE);
		 * ActivityManager.MemoryInfo memInfo = new
		 * ActivityManager.MemoryInfo(); actManager.getMemoryInfo(memInfo);
		 * initial_memory = memInfo.totalMem; } else {
		 */
		String str1 = "/proc/meminfo";
		String str2;
		String[] arrayOfString;

		try {
			FileReader localFileReader = new FileReader(str1);
			BufferedReader localBufferedReader = new BufferedReader(localFileReader, 8192);
			str2 = localBufferedReader.readLine();// meminfo
			arrayOfString = str2.split("\\s+");
			// total Memory
			initial_memory = Integer.valueOf(arrayOfString[1]) * 1024;
			localBufferedReader.close();
		} catch (IOException e) {
			return -1;
		}
		// }
		return initial_memory / 1024 / 1024;
	}

	public static int getCoresCount() {
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

	@SuppressLint("NewApi")
	@SuppressWarnings("deprecation")
	public static long getAvailableSpaceInMB() {
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

	@SuppressLint("DefaultLocale")
	public static boolean getCPUArch() {
		String arch = System.getProperty("os.arch");
		return arch.toLowerCase().matches(".*x86.*");
	}

}
