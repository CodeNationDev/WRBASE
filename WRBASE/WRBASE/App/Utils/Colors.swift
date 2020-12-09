//
import Foundation
import UIKit

extension UIColor {
    public static var blueCaixa1 = UIColor(named: "BlueCaixa1", in: .main, compatibleWith: nil)!
    public static var blueCaixa2 = UIColor(named: "BlueCaixa2", in: .main, compatibleWith: nil)!
    public static var blueCaixa3 = UIColor(named: "BlueCaixa3", in: .main, compatibleWith: nil)!
    public static var blueCaixa4 = UIColor(named: "BlueCaixa4", in: .main, compatibleWith: nil)!
    public static var genericWhite = UIColor(named: "GenericWhite", in: .main, compatibleWith: nil)!
    public static var genericBlack = UIColor(named: "GenericBlack", in: .main, compatibleWith: nil)!
    public static var lightboxBackgroundcolor = UIColor(named: "LightBoxBackgroundColor", in: .main, compatibleWith: nil)!
    public static var textLight = UIColor(named: "TextLight", in: .main, compatibleWith: nil)!
    public static var textDark = UIColor(named: "TextDark", in: .main, compatibleWith: nil)!
    public static var grayCaixa1 = UIColor(named: "GrayCaixa1", in: .main, compatibleWith: nil)!
    
    public func lightboxBackgroundcolor (alpha: CGFloat = 0.5 ) -> UIColor {
        UIColor(red: 0, green: 0, blue: 15, alpha: alpha)
    }
}
