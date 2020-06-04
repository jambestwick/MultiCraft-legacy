import UIKit

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}

	convenience init(_ red: Int, _ green: Int, _ blue: Int) {
		self.init(red: red, green: green, blue: blue)
	}

	convenience init(netHex: Int) {
		self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
	}
}

final class ProgressViewController: BasePresentViewController {
	@IBOutlet private weak var progressSize: NSLayoutConstraint!
	@IBOutlet private weak var labelProgress: UILabel!
	@IBOutlet private weak var viewProgress: UIView!
	@IBOutlet private weak var viewProgressIndicator: UIView!

	override func viewDidLayoutSubviews() {
		let height = view.frame.size.width * 0.55 / 8
		viewProgress.constraints.first(where: {$0.firstAttribute == .height})?.constant = height
		viewProgress.layer.cornerRadius = height / 2
		viewProgress.layer.borderWidth = 3
		viewProgress.layer.borderColor = UIColor.black.cgColor
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@objc func updateProgress(_ progress: Int) {
		if viewProgress.isHidden {
			viewProgress.isHidden = false
		}
		labelProgress.text = "\(NSLocalizedString("Loading...", comment: "")) \(progress)%"
		progressSize.constant = CGFloat(progress) * viewProgress.frame.size.width / 100

		let color = UIColor(255 - progress * 2, progress * 2, 25)
		viewProgressIndicator.backgroundColor = color
	}
}
