package mobi.MultiCraft;

/**
 * Callback for MainActivity init and runGame methods
 */
public interface IDialogHelperCallback {

	public void init();

	public void runGame();

	public void exit();

	public void showDialogTree(int bitMask);
}
