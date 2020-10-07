//
//  CornerRadius.swift
//  bar
//
//  Created by Viktor Golovach on 27.09.2020.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderrWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderrColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(newValue) {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }

    func addGradientBackgound(firstColor: UIColor, SecondColor: UIColor, topToBottom: Bool) {
        layoutIfNeeded()
        removeGradients()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, SecondColor.cgColor]
        gradient.locations = [0.0, 0.5]
        gradient.startPoint = CGPoint(x: 1.0, y: topToBottom ? 0.0 : 1.0)
        gradient.endPoint = CGPoint(x: topToBottom ? 1.0 : 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width + 2, height: bounds.size.height)
        gradient.name = "grad"
        layer.insertSublayer(gradient, at: 0)
    }

    func removeGradients() {
        layer.sublayers?.forEach { layer in
            if layer.name == "grad" {
                layer.removeFromSuperlayer()
            }
        }
    }

    func round(corners: CACornerMask, radii: Int, withBorder _: UIColor? = nil) {
        clipsToBounds = true
        layer.cornerRadius = CGFloat(radii)
        layer.maskedCorners = corners
    }

    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }

    @discardableResult
    func viewFromNibForClass<T>() -> T where T: UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else { fatalError("Could not load nib with type: \(type(of: self))") }
        view.frame = bounds
        addSubview(view)
        return view
    }
}
