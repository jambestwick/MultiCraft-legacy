import UIKit

class BasePresentViewController: UIViewController {
	@objc func present(in viewController: UIViewController) {
		viewController.addChild(self)
		didMove(toParent: viewController)
		view.frame = viewController.view.bounds
		viewController.view.addSubview(view)

		guard let window = UIApplication.shared.keyWindow else { return }
		window.addSubview(view)
	}

	@objc func dismissView() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
