//
//  Const+Font.swift
//  Quick-pg
//
//  Created by Evgeniy on 29/04/2019.
//  Copyright © 2019 Evgeniy. All rights reserved.
//

import UIKit

enum Fonts {
    // MARK: - Core Sans AR

    static func CoreSansARMedium(ofSize size: CGFloat) -> UIFont? {
        return coreSansARMedium?.withSize(size)
    }

    static func CoreSansARBold(ofSize size: CGFloat) -> UIFont? {
        return coreSansARBold?.withSize(size)
    }

    static func CoreSansARExtraBold(ofSize size: CGFloat) -> UIFont? {
        return coreSansARExtraBold?.withSize(size)
    }

    static func CoreSansARHeavy(ofSize size: CGFloat) -> UIFont? {
        return coreSansARHeavy?.withSize(size)
    }

    // MARK: - Open Sans

    static func OpenSansRegular(ofSize size: CGFloat) -> UIFont? {
        return openSansRegular?.withSize(size)
    }

    static func OpenSansSemibold(ofSize size: CGFloat) -> UIFont? {
        return openSansSemibold?.withSize(size)
    }

    static func OpenSansBold(ofSize size: CGFloat) -> UIFont? {
        return openSansBold?.withSize(size)
    }

    // MARK: - Montserrat

    static func MontserratMedium(ofSize size: CGFloat) -> UIFont? {
        return montserratMedium?.withSize(size)
    }

    static func MontserratSemibold(ofSize size: CGFloat) -> UIFont? {
        return montserratSemibold?.withSize(size)
    }

    static func MontserratSemiboldItalic(ofSize size: CGFloat) -> UIFont? {
        return montserratSemiboldItalic?.withSize(size)
    }

    // MARK: - Core Sans AR

    private static let coreSansARMedium: UIFont? = UIFont(name: "CoreSansAR-55Medium", size: 22)

    private static let coreSansARBold: UIFont? = UIFont(name: "CoreSansAR-65Bold", size: 22)

    private static let coreSansARExtraBold: UIFont? = UIFont(name: "CoreSansAR-75ExtraBold", size: 22)

    private static let coreSansARHeavy: UIFont? = UIFont(name: "CoreSansAR-85Heavy", size: 22)

    // MARK: - Open Sans

    private static let openSansRegular: UIFont? = UIFont(name: "OpenSans-Regular", size: 22)

    private static let openSansSemibold: UIFont? = UIFont(name: "OpenSans-SemiBold", size: 22)

    private static let openSansBold: UIFont? = UIFont(name: "OpenSans-Bold", size: 22)

    // MARK: - Montserrat

    private static let montserratMedium: UIFont? = UIFont(name: "Montserrat-Medium", size: 18)

    private static let montserratSemibold: UIFont? = UIFont(name: "Montserrat-SemiBold", size: 18)

    private static let montserratSemiboldItalic: UIFont? = UIFont(name: "Montserrat-SemiBoldItalic", size: 18)
}
