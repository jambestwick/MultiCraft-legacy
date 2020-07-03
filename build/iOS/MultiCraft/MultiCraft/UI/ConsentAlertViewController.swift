import UIKit
import Nantes

private enum Constants {
	static let oldInfoStatusKey = "personalized_ad_status"
	static let newInfoStatusKey = "new_personalized_ad_status"
}

final class ConsentAlertViewController: BasePresentViewController, NantesLabelDelegate {
	@IBOutlet private weak var buttonRelevant: UIButton!
	@IBOutlet private weak var buttonAllow: UIButton!
	@IBOutlet private weak var viewContainer: UIView!
	@IBOutlet private weak var labelPrivacy: NantesLabel!
	@IBOutlet private weak var viewFirst: UIView!
	@IBOutlet private weak var viewSecond: UIView!
	@IBOutlet private weak var buttonAgree: UIButton!
	@IBOutlet private weak var containerHeight: NSLayoutConstraint!
	@IBOutlet private weak var buttonBack: UIButton!
	@IBOutlet private weak var imageAppIcon: UIImageView!
	@IBOutlet private weak var rightPadding: NSLayoutConstraint!
	@IBOutlet private weak var leftPadding: NSLayoutConstraint!

	private let privacyURL = URL(string: "https://www.appodeal.com/privacy-policy")!

	private var isShowFirstPage = true

	var finishTapped: (() -> Void)?

	private enum Status: String, Codable {
		case unknown
		case personalized
		case non_personalized

		var isConsent: Bool {
			switch self {
			case .personalized:
				return true
			default:
				return false
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		viewSecond.alpha = 0
		setupUI()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		setupContentHeight()
	}

	private func setupContentHeight() {
		let contentHeight = isShowFirstPage ? viewFirst.frame.size.height : viewSecond.frame.size.height
		containerHeight.constant = contentHeight
	}

	private func setupUI() {
		if UIScreen.main.bounds.size.width <= 667 {
			leftPadding.constant = 30
			rightPadding.constant = 30
		}

		imageAppIcon.image = Bundle.main.icon

		buttonAgree.layer.cornerRadius = 6
		buttonBack.layer.borderWidth = 1
		buttonBack.layer.borderColor = UIColor.lightGray.cgColor
		buttonBack.layer.cornerRadius = 6

		buttonAllow.layer.cornerRadius = 8
		buttonAllow.layer.borderWidth = 3
		buttonAllow.layer.borderColor = UIColor(220, 220, 220).cgColor
		buttonAllow.titleLabel?.numberOfLines = 2

		buttonRelevant.layer.cornerRadius = 8
		buttonRelevant.layer.borderWidth = 3
		buttonRelevant.layer.borderColor = UIColor(220, 220, 220).cgColor
		buttonRelevant.titleLabel?.numberOfLines = 2

		viewContainer.layer.shadowColor = UIColor.black.cgColor
		viewContainer.layer.shadowRadius = 6
		viewContainer.layer.shadowOpacity = 0.4
		viewContainer.layer.shadowOffset = .init(width: 0, height: 3)
		viewContainer.layer.cornerRadius = 8

		labelPrivacy.delegate = self
		let text = "Our partners will collect data and use a unique identifier on your device to show you ads. By agreeing, you confirm that you are 16 years old. You can learn how we and our partners collect and use data on Privacy Policy."
		labelPrivacy.text = text

		labelPrivacy.linkAttributes = [NSAttributedString.Key.underlineColor: NSUnderlineStyle.single.rawValue,
		                               NSAttributedString.Key.foregroundColor: UIColor(0, 98, 232)]


		labelPrivacy.activeLinkAttributes = [NSAttributedString.Key.backgroundColor: UIColor(white: 0.5, alpha: 0.5),
		                                     NSAttributedString.Key.underlineColor: NSUnderlineStyle.single.rawValue]

		labelPrivacy.lineSpacing = 3
		labelPrivacy.textColor = .lightGray
		labelPrivacy.addLink(to: privacyURL, withRange: (text as NSString).range(of: "Privacy Policy"))
	}

	@IBAction private func showMulticraftUses(_ sender: Any) {
		if UIApplication.shared.canOpenURL(privacyURL) {
			UIApplication.shared.openURL(privacyURL)
		}
	}

	@IBAction private func relevantTapped(_ sender: Any) {
		isShowFirstPage = false
		setupContentHeight()
		UIView.animate(withDuration: 0.3) {
			self.viewFirst.alpha = 0
			self.viewSecond.alpha = 1
			self.view.layoutIfNeeded()
		}
	}

	@IBAction private func showPrivacy(_ sender: Any) {
		if UIApplication.shared.canOpenURL(privacyURL) {
			UIApplication.shared.openURL(privacyURL)
		}
	}

	@IBAction private func allowTapped(_ sender: Any) {
		Self.setPersonalizedConsentStatus(.personalized)
		finishTapped?()
		dismissView()
	}

	@IBAction private func agreeTapped(_ sender: Any) {
		Self.setPersonalizedConsentStatus(.non_personalized)
		finishTapped?()
		dismissView()
	}

	@IBAction private func backTapped(_ sender: Any) {
		isShowFirstPage = true
		setupContentHeight()
		UIView.animate(withDuration: 0.3) {
			self.viewFirst.alpha = 1
			self.viewSecond.alpha = 0
			self.view.layoutIfNeeded()
		}
	}

	func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
		if UIApplication.shared.canOpenURL(link) {
			UIApplication.shared.openURL(link)
		}
	}
}

extension ConsentAlertViewController {
	private static var personalizedConsentStatus: Status {
		if let rawString = UserDefaults.standard.object(forKey: Constants.newInfoStatusKey) as? String {
			return Status(rawValue: rawString) ?? .unknown
		}
		return .unknown
	}

	private static func setPersonalizedConsentStatus(_ status: Status) {
		UserDefaults.standard.set(status.rawValue, forKey: Constants.newInfoStatusKey)
		UserDefaults.standard.synchronize()
	}

	@objc class func checkConsentStatus(in viewController: UIViewController, _ complete: @escaping (_ consent: Bool) -> Void) {
		struct Response: Codable {
			let is_request_in_eea_or_unknown: Bool
		}

		var status: Status = personalizedConsentStatus

		if let dict = UserDefaults.standard.object(forKey: Constants.oldInfoStatusKey) as? [String: Any] {
			if dict["consent_state"] as? String == "personalized" {
				status = .personalized
			} else if dict["consent_state"] as? String == "non_personalized" {
				status = .non_personalized
			}
		}

		if status == .unknown {
			URLSession.shared.dataTask(with: URL(string: "http://adservice.google.com/getconfig/pubvendors")!) { data, response, error in
				DispatchQueue.main.async {
					if let data = data {
						do {
							let res = try JSONDecoder().decode(Response.self, from: data)
							if res.is_request_in_eea_or_unknown {
								let vc = ConsentAlertViewController(nibName: "ConsentAlertViewController", bundle: nil)
								vc.finishTapped = {
									complete(personalizedConsentStatus.isConsent)
								}
								vc.present(in: viewController)
							} else {
								// if not EU, set .personalized status
								let status = Status.personalized
								setPersonalizedConsentStatus(status)
								complete(status.isConsent)
							}
						} catch {
							complete(true)
						}
					} else {
						complete(true)
					}
				}
			}.resume()
		} else {
			complete(status.isConsent)
		}
	}
}

extension Bundle {
	var icon: UIImage? {
		if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
			let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
			let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
			let lastIcon = iconFiles.last {
				return UIImage(named: lastIcon)
			}
		return nil
	}
}
