/**
  Extensions.swift
  Class with extensions, to add extra functionallity to some classes

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit
import Kingfisher

// MARK: - String
extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}

// MARK: - UIImageView
extension UIImageView {
    func download(image url: URL?) {
        guard let url = url else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}

// MARK: - URL
extension URL {
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return absoluteURL
        }
        return url
    }

    func appending(_ items: [String: String]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        for key in items.keys {
            let queryItem = URLQueryItem(name: key, value: items[key])
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return absoluteURL
        }
        return url
    }
}

// MARK: - UIViewController
var vSpinner: UIView?

extension UIViewController {
    func showSpinner(onView: UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }

        vSpinner = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "error".localized(), message: message.localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
