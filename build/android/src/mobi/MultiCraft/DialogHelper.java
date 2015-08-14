package mobi.MultiCraft;

import static mobi.MultiCraft.PreferencesHelper.TAG_HELP_SHOWED;
import static mobi.MultiCraft.PreferencesHelper.*;

import com.winsontan520.wversionmanager.library.WVersionManager;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Helpful utilities used in MainActivity
 */
public class DialogHelper {
	private Button positive, negative;
	private Dialog dialog;
	private Context mContext;
	private IDialogHelperCallback callerActivity;

	public DialogHelper(Context context) {
		mContext = context;
		callerActivity = (IDialogHelperCallback) context;
	}

	private void dialogInit(int panel, int positiveBtn, int negativeBtn, int messageText) {
		dialog = new Dialog(mContext);
		dialog.requestWindowFeature(panel);
		dialog.setContentView(R.layout.dialog_template);
		positive = (Button) dialog.findViewById(R.id.positive);
		negative = (Button) dialog.findViewById(R.id.negative);
		TextView message = (TextView) dialog.findViewById(R.id.message);
		positive.setText(positiveBtn);
		negative.setText(negativeBtn);
		message.setText(messageText);
		dialog.setCancelable(false);
		dialog.getWindow().setBackgroundDrawable(new ColorDrawable(R.color.semi_transparent));
	}

	@SuppressLint("InflateParams")
	public Dialog showHelpDialog(final int bitMask) {
		dialogInit(Window.FEATURE_NO_TITLE, R.string.ok, R.string.forget, R.string.dialog_instruction);
		positive.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
				saveSettings(mContext, TAG_HELP_SHOWED, false);
				callerActivity.showDialogTree(bitMask);
			}
		});
		negative.setVisibility(View.GONE);
		// dialog.show();
		return dialog;
	}

	public Dialog showMemoryDialog(final int bitMask) {
		dialogInit(Window.FEATURE_OPTIONS_PANEL, R.string.memory_continue, R.string.memory_close,
				R.string.memory_warning);
		positive.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
				Toast.makeText(mContext, R.string.memory_lags, Toast.LENGTH_SHORT).show();
				callerActivity.showDialogTree(bitMask);
			}
		});
		negative.setVisibility(View.GONE);
		// dialog.show();
		return dialog;
	}

	public Dialog showVersionDialog(int bitMask) {
		WVersionManager versionManager = new WVersionManager((Activity) mContext);
		versionManager.setVersionContentUrl("http://MultiCraft.mobi/ver/MultiCraft.txt");
		versionManager.checkVersion();
		versionManager.setUpdateNowLabel((String) mContext.getResources().getText(R.string.update_yes));
		versionManager.setRemindMeLaterLabel((String) mContext.getResources().getText(R.string.update_no));
		versionManager.setIgnoreThisVersionLabel((String) mContext.getResources().getText(R.string.update_ignore));
		return versionManager.showDialog(bitMask);
	}

	public Dialog showRateDialog(int bitMask) {
		return RateThisApp.showRateDialog(mContext, bitMask);
	}
	/*
	 * public void showCPUDialog() { dialogInit(Window.FEATURE_OPTIONS_PANEL,
	 * R.string.memory_continue, R.string.memory_close, R.string.cpu_warning);
	 * positive.setOnClickListener(new OnClickListener() {
	 * 
	 * @Override public void onClick(View v) { dialog.dismiss(); } });
	 * negative.setVisibility(View.GONE); dialog.show(); }
	 */

	public void showNotEnoughSpaceDialog() {
		dialogInit(Window.FEATURE_OPTIONS_PANEL, R.string.space_ok, R.string.memory_close, R.string.not_enough_space);
		negative.setVisibility(View.GONE);
		positive.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});
		dialog.show();
	}

}
