import UIKit

final class MainWindow: UIWindow {
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init() {
		super.init(frame: UIScreen.main.bounds)
	}

	@objc func run() {
		backgroundColor = UIColor(patternImage: UIImage(named: "icon_bg")!)
		rootViewController = UIViewController()
		makeKeyAndVisible()
	}
}
