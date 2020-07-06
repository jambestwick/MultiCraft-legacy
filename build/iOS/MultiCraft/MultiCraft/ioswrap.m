#import "VersionManager.h"
#import "ioswrap.h"

#import <AVFoundation/AVFoundation.h>
#import <Bugsnag/Bugsnag.h>
#import <Foundation/Foundation.h>
#import <MultiCraft-Swift.h>
#import <UIKit/UIKit.h>

/* Initialization iOS Specific Things */
void init_IOS_Settings()
{
	[Bugsnag startWithApiKey:CrashliticsApiKey]; // crash analytics
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil]; // don't stop background music
}

/* Handle Debug Logs */
void ioswrap_log(const char *message)
{
#if !NDEBUG
	NSLog(@"%s", message);
#endif
}

/* Get Path for Assets */
void ioswrap_paths(int type, char *dest, size_t destlen)
{
	NSArray *paths;

	if (type == PATH_DOCUMENTS)
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	else if (type == PATH_LIBRARY_SUPPORT || type == PATH_LIBRARY_CACHE)
		paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	else
		return;

	NSString *path = paths.firstObject;
	const char *path_c = path.UTF8String;

	if (type == PATH_DOCUMENTS)
		snprintf(dest, destlen, "%s", path_c);
	else if (type == PATH_LIBRARY_SUPPORT)
		snprintf(dest, destlen, "%s/Application Support", path_c);
	else // type == PATH_LIBRARY_CACHE
		snprintf(dest, destlen, "%s/Caches", path_c);
}


/* Unzip Assets */
void ioswrap_assets()
{
	MainWindow *window = [[MainWindow alloc] init];
	[window run];

	ProgressViewController *progressVC = [[ProgressViewController alloc] initWithNibName:@"ProgressViewController" bundle:nil];
	[progressVC presentIn:window.rootViewController];

	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);

	ZipManager *manager = [[ZipManager alloc] init];
	[manager runProcess:^(NSInteger progress) {
		[progressVC updateProgress:progress];
		CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);
	} :^(NSError * error) {
		UIAlertController *vc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unexpected issue, please restart the game!", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close game", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			exit(0);
		}];

		[vc addAction:cancel];
		[window.rootViewController presentViewController:vc animated:NO completion:nil];

		while (true)
			CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);
	}];

	[progressVC dismissView];
	window.backgroundColor = [UIColor blackColor];
}

void ioswrap_asset_refresh(void)
{
	char buf[256];
	ioswrap_paths(PATH_LIBRARY_SUPPORT, buf, sizeof(buf));
	NSString *destpath = [NSString stringWithUTF8String:buf];

	// set asset version to 1, will be extracted next time
	[VersionManager writeVersionWithPath:destpath ver:1];
}

/* Get Scale Factor */
float ioswrap_scale()
{
	return (float) [[UIScreen mainScreen] scale];
}

/* Input Dialog */
static int dialog_state;
static char dialog_text[512];

#define DIALOG_MULTILINE  1
#define DIALOG_SINGLELINE 2
#define DIALOG_PASSWORD   3

void ioswrap_show_dialog(void *uiviewcontroller, const char *accept, const char *hint, const char *current, int type)
{
	UIViewController *viewc = (__bridge UIViewController *) uiviewcontroller;

	if (type == DIALOG_MULTILINE) {
		MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
		vc.message = [NSString stringWithUTF8String:current];
		[vc setDidSendMessage:^(NSString *message) {
			dialog_state = 0;
			strncpy(dialog_text, message.UTF8String, sizeof(dialog_text));
		}];
		[vc presentIn:viewc];

		dialog_state = -1;
		dialog_text[0] = 0;
	} else {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Text Input", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];

		[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.text = [NSString stringWithUTF8String:current];
			if (type == DIALOG_PASSWORD)
				textField.secureTextEntry = YES;
		}];

		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			dialog_state = 0;
			strncpy(dialog_text, alert.textFields[0].text.UTF8String, sizeof(dialog_text));
		}]];

		dialog_state = -1;
		dialog_text[0] = 0;
		[viewc presentViewController:alert animated:YES completion:nil];
	}
}

int ioswrap_get_dialog(const char **text)
{
	int ret = dialog_state;
	if (text) {
		*text = dialog_text;
		dialog_state = -1; // reset
	}

	return ret;
}
