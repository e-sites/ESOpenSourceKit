//
//  ESOpenSourceLicensesView.swift
//  ESOpenSourceLicensesKit
//
//  Created by Bas van Kuijck on 19-08-15.
//  Copyright © 2015 e-sites. All rights reserved.
//

import Foundation
import UIKit

/**
A UIWebView presentation of the licenses html file.
Which is generated by the bashscript
*/
open class ESOpenSourceLicensesView : UIWebView {
    
    // MARK: - Constructor
    // ____________________________________________________________________________________________________________________
    
    /**
    A convenience initializer
    This will invoke init(frame:)
    
    - returns a ESOpenSourceLicensesView instance
    */
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    /**
    Returns an object initialized from data in a given unarchiver.
    
    - parameter: aDecoder	An unarchiver object.
    
    - returns:  `self`, initialized using the data in decoder.
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        self.backgroundColor = UIColor.white
        self.dataDetectorTypes = []
        reload()
    }
    
    
    // MARK: - Style
    // ____________________________________________________________________________________________________________________
    
    /**
    The font to be used for the headers
    Default: Helvetica Neue; 16pt
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 18/08/2015
    */
    public var headerFont = UIFont(name: "HelveticaNeue", size: 16)!
    
    /**
    The font to be used for the license text
    Default: Menlo; 12pt
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 18/08/2015
    */
    public var licenseFont = UIFont(name: "Menlo-Regular", size: 12)!
    
    /**
    The text color of the headers
    Default: Black
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    public var headerTextColor:UIColor = UIColor.black
    
    /**
    The text color of the license text
    Default: Black
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    public var licenseTextColor = UIColor.black
    
    /**
    The backgroundcolor of the license text
    Default: #EEE
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    public var licenseBackgroundColor = UIColor(white: 0.9333, alpha: 1.0)
    
    /**
    The border color of the license text
    Default: #DDD
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    public var licenseBorderColor = UIColor(white: 0.8666, alpha: 1.0)
    
    /**
    The width of the border of the license text
    Default 1.0
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date 19/08/2015
    */
    public var licenseBorderWidth:CGFloat = 1.0
    
    /**
    The padding in the view
    Default 10.0
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.2
    - date: 19/08/2015
    */
    public var padding:CGFloat = 10.0
    
    // MARK: - Reloading
    // ____________________________________________________________________________________________________________________
    
    /**
    Reloads the license text
    This should be done after a style attribute is changed
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    override open func reload() {
        do {
            var bundle:Bundle? = nil
            #if TESTS
                bundle = Bundle(for: type(of: self))
                #else
                // Try to find ESOpenSourceLicensesKit.bundle
                let ar = [ "Frameworks", "ESOpenSourceLicensesKit.framework", "ESOpenSourceLicensesKit" ]
                var bundlePath:String? = nil
                for i in 0...2 {
                    let nar = ar[i...2]
                    bundlePath = Bundle.main.path(forResource: nar.joined(separator: "/"), ofType: "bundle")
                    if (bundlePath != nil) {
                        break
                    }
                }
                if (bundlePath == nil) {
                    return
                }
                bundle = Bundle(path: bundlePath!)
            #endif
            
            
            let path = bundle!.path(forResource: "opensource-licenses", ofType: "html")!
            let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let regex = try NSRegularExpression(pattern: "<style>.+?</style>", options: .caseInsensitive)
            
            let bgRGB = _rgba(fromColor: self.backgroundColor!)
            let blockRGB = _rgba(fromColor: self.licenseBackgroundColor)
            let borderRGB = _rgba(fromColor: self.licenseBorderColor)
            let headerTextRGB = _rgba(fromColor: self.headerTextColor)
            let licenseTextRGB = _rgba(fromColor: self.licenseTextColor)
            
            let template = NSString(format: "<style> body { background-color: %@; margin:%.0fpx; } p { font-family:'%@'; margin-bottom:10px; display:block; background-color:%@; border:%.0fpx solid %@; font-size:%.0fpx; padding:5px; color:%@; } h2 { font-family: '%@'; font-size:%.0fpx; color:%@; } </style>",
                bgRGB, self.padding,
                self.licenseFont.fontName, blockRGB, self.licenseBorderWidth, borderRGB, self.licenseFont.pointSize, licenseTextRGB,
                self.headerFont.fontName, self.headerFont.pointSize, headerTextRGB)
            
            let modifiedString = regex.stringByReplacingMatches(in: contents as String, options: .withoutAnchoringBounds, range: NSMakeRange(0, contents.characters.count), withTemplate: template as String)
            self.loadHTMLString(modifiedString, baseURL: nil)
            
        } catch { }
    }
    
    // MARK: - Helpers
    // ____________________________________________________________________________________________________________________
    
    /**
    Helper function to convert a UIColor to an @"rgba()" string
    
    - parameter:  color	UIColor
   
    - returns: HTML String representation for the color > `rgba(#,#,#,#)`
    
    - author: Bas van Kuijck <bas@e-sites.nl>
    - since: 1.1
    - date: 19/08/2015
    */
    
    private func _rgba(fromColor color: UIColor) -> NSString {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return NSString(format: "rgba(%.0f, %.0f, %.0f, %.0f)", red * 255, green * 255, blue * 255, alpha)
    }
}
