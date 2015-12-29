package mobi.MultiCraft;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Spanned;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnKeyListener;
import android.widget.EditText;
import net.MultiCraft.Official.R;

public class MultiCraftTextEntry extends Activity {
	public AlertDialog mTextInputDialog;
	public EditText mTextInputWidget;

	private final int MultiLineTextInput = 1;
	private final int SingleLinePasswordInput = 3;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Bundle b = getIntent().getExtras();
		String acceptButton = b.getString("EnterButton");
		// String hint = b.getString("hint");
		String hint = getString(R.string.name);
		String current = b.getString("current");
		int editType = b.getInt("editType");

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		mTextInputWidget = new EditText(this);
		mTextInputWidget.setHint(hint);
		mTextInputWidget.setText(current);
		mTextInputWidget.setMinWidth(300);
		if (editType == SingleLinePasswordInput) {
			mTextInputWidget.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
		} else {
			mTextInputWidget.setInputType(InputType.TYPE_CLASS_TEXT);
			mTextInputWidget.setFilters(new InputFilter[] { new InputFilter() {
				public CharSequence filter(CharSequence src, int start, int end, Spanned dst, int dstart, int dend) {
					if (src.equals("")) { // for backspace
						return src;
					}
					if (!src.toString().matches("[à-ÿÀ-ß]+")) {
						return src;
					}
					return "";
				}
			} });
		}

		builder.setView(mTextInputWidget);

		if (editType == MultiLineTextInput) {
			builder.setPositiveButton(acceptButton, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int whichButton) {
					pushResult(mTextInputWidget.getText().toString());
				}
			});
		}

		builder.setOnCancelListener(new DialogInterface.OnCancelListener() {
			public void onCancel(DialogInterface dialog) {
				pushResult(mTextInputWidget.getText().toString());
			}
		});

		mTextInputWidget.setOnKeyListener(new OnKeyListener() {
			@Override
			public boolean onKey(View view, int KeyCode, KeyEvent event) {
				if (KeyCode == KeyEvent.KEYCODE_ENTER) {

					pushResult(mTextInputWidget.getText().toString());
					return true;
				}
				return false;
			}
		});

		mTextInputDialog = builder.create();
		mTextInputDialog.show();
	}

	public void pushResult(String text) {
		Intent resultData = new Intent();
		resultData.putExtra("text", text);
		setResult(Activity.RESULT_OK, resultData);
		mTextInputDialog.dismiss();
		finish();
	}

}
