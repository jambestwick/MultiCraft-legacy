import UIKit

final class MessageViewController: BasePresentViewController {
	@objc var didSendMessage: ((String) -> Void)?

	@IBOutlet private weak var textView: UITextView!

	@objc var message: String = ""

	override func viewDidLoad() {
		super.viewDidLoad()

		textView.text = message
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.placeholder = NSLocalizedString("Text Input", comment: "")
		textView.becomeFirstResponder()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
	}

	@IBAction private func sendTapped(_ sender: Any) {
		if textView.text.isEmpty == false {
			didSendMessage?(textView.text)
		}

		dismissView()
	}
}

private extension MessageViewController {
	@objc func keyboardWillShow(_ notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			textView.constraints.first(where: { $0.firstAttribute == .height })?.constant = view.frame.size.height - keyboardSize.height
		}
	}
}
