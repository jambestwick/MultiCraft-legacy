import UIKit

class BasePresentViewController: UIViewController {
	@objc func present(in viewController: UIViewController) {
		viewController.addChild(self)
		didMove(toParent: viewController)
		view.frame = viewController.view.bounds
		viewController.view.addSubview(view)
	}

	@objc func dismissView() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
