package mobi.MultiCraft;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnKeyListener;
import android.widget.EditText;


public class InputDialogActivity extends Activity {
    private AlertDialog alertDialog;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle b = getIntent().getExtras();
        int editType = b.getInt("editType");
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        LayoutInflater inflater = this.getLayoutInflater();
        View dialogView = inflater.inflate(R.layout.dialog, null);
        builder.setView(dialogView);
        final EditText editText = (EditText) dialogView.findViewById(R.id.editText);
        if (editType == 3) {
            editText.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_TEXT);
        }
        editText.setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(View view, int KeyCode, KeyEvent event) {
                if (KeyCode == KeyEvent.KEYCODE_ENTER) {
                    pushResult(editText.getText().toString());
                    return true;
                }
                return false;
            }
        });

        alertDialog = builder.create();
        alertDialog.show();
    }

    public void pushResult(String text) {
        Intent resultData = new Intent();
        resultData.putExtra("text", text);
        setResult(Activity.RESULT_OK, resultData);
        alertDialog.dismiss();
        finish();
    }

}