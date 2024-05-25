//
//  UIColor + Extension.swift
//  ColorMixing
//
//  Created by Алексей on 25.05.2024.
//

import UIKit

extension UIColor {
    static func blendColors(_ colors: UIColor...) -> UIColor {
        var reds = Array(repeating: CGFloat(0), count: colors.count)
        var greens = Array(repeating: CGFloat(0), count: colors.count)
        var blues = Array(repeating: CGFloat(0), count: colors.count)
        var a = Array(repeating: CGFloat(0), count: colors.count)
        
        var count = 0
        
        colors.forEach {
            $0.getRed(
                &reds[count],
                green: &greens[count],
                blue: &blues[count],
                alpha: &a[count]
            )
            count += 1
        }
        
        let blendedColor = UIColor(
            red: reds.reduce(0, +) / CGFloat(colors.count),
            green: greens.reduce(0, +) / CGFloat(colors.count),
            blue: blues.reduce(0, +) / CGFloat(colors.count),
            alpha: a.reduce(0, +) / CGFloat(colors.count)
        )
        
        return blendedColor
    }
}
