import Foundation
import SSZipArchive
import Bugsnag

private enum Constants {
	static let percentProgressIndex: Int = 0
}

private struct Asset {
	let name: String
	let path: UnzipPath
	let versioned: Bool

	var destinationPath: String {
		switch path {
		case .documents:
			return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

		case .library:
			let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
			return (path as NSString).appendingPathComponent("Application Support")
		}
	}
}

private enum UnzipPath: Int {
	case documents
	case library
}

final class ZipManager: NSObject {
	private var assets: [Asset] = [.init(name: "assets", path: .library, versioned: true),
	                               .init(name: "worlds", path: .documents, versioned: false)]

	@objc func runProcess(_ progress: @escaping (_ percent: Int) -> Void, _ errorBlock: @escaping (Error) -> Void) {
		let versionRuntime = VersionManager.parseVersion()

		for (index, asset) in assets.enumerated() {
			let zippath = Bundle.main.path(forResource: asset.name, ofType: "zip") ?? ""
			let versionDisk = VersionManager.readVersion(withPath: asset.destinationPath)

			if !asset.versioned && versionDisk != 0 { // worlds
				continue
			}

			#if !DEBUG
			if versionDisk == versionRuntime {
				continue
			}
			#endif

			unzipFile(at: zippath, to: asset.destinationPath, vRuntime: versionRuntime, { (percent) in
				if index == Constants.percentProgressIndex {
					progress(percent)
				}
			}, errorBlock)
		}
	}
}

private extension ZipManager {
	func unzipFile(at path: String, to destination: String, vRuntime: UInt32, _ block: @escaping (_ percent: Int) -> Void, _ errorBlock :@escaping (Error) -> Void) {
		let fileManager = FileManager.default
		let files = (try? fileManager.contentsOfDirectory(atPath: destination)) ?? []

		for file in files {
			do {
				try fileManager.removeItem(atPath: (destination as NSString).appendingPathComponent(file))
			} catch {
				print(error)
			}
		}

		SSZipArchive.unzipFile(atPath: path, toDestination: destination, overwrite: true, password: ZIPPWD, progressHandler: { (file, zipInfo, progress, total) in
			block(progress * 100 / total)

		}) { (path, success, error) in
			if let error = error {
				Bugsnag.notifyError(error)
				errorBlock(error)
			} else {
				block(100)
			}
		}

		VersionManager.writeVersion(withPath: destination, ver: vRuntime)
	}
}
