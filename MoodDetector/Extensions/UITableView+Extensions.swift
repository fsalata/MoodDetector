//
//  UITableView+Extensions.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(of type: T.Type) {
        let nib = UINib(nibName: String(describing: type.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T: UITableViewCell>(of type: T.Type,
                                                for indexPath: IndexPath,
                                                configure: @escaping ((T) -> Void) = { _ in }) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath)
        
        if let cell = cell as? T {
            configure(cell)
        }
        
        return cell
    }
}
