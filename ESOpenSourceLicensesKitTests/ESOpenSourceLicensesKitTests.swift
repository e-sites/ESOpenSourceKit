//
//  ESOpenSourceLicensesKitTests.swift
//  ESOpenSourceLicensesKit
//
//  Created by Bas van Kuijck on 21-08-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class ESOpenSourceLicensesKitTests : XCTestCase {

    /**
    Test if the ESOpenSourceLicensesViewController works
    */
    func testViewController() {
        let vc = ESOpenSourceLicensesViewController()
        XCTAssertNotNil(vc.openSourceLicensesView)
    }
    
    /**
    Test if ESOpenSourceLicensesView works
    */
    func testView() {
        let v = ESOpenSourceLicensesView()
        XCTAssertNotNil(v)
        XCTAssert(v.dataDetectorTypes == UIDataDetectorTypes())
        let expectation = self.expectation(description: "javascript-check")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            var response = v.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
            XCTAssertNotNil(response)
            response = v.stringByEvaluatingJavaScript(from: "document.title")
            XCTAssertEqual(response!, "Open Source Licenses")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 3) { _ in
        }
    }
    
    /**
    Test ESOpenSourceLicensesView colors and appearance
    */
    func testViewStyle() {
        let v = ESOpenSourceLicensesView()
        var rgba = _rgbaFromUIColor(v.backgroundColor!)
        XCTAssertNotNil(rgba)
        
        rgba = _rgbaFromUIColor(v.licenseTextColor)
        XCTAssertNotNil(rgba)
        
        rgba = _rgbaFromUIColor(v.licenseBorderColor)
        XCTAssertNotNil(rgba)
        
        rgba = _rgbaFromUIColor(v.licenseBackgroundColor)
        XCTAssertNotNil(rgba)
        
        rgba = _rgbaFromUIColor(v.headerTextColor)
        XCTAssertNotNil(rgba)
        
        rgba = _rgbaFromUIColor(v.licenseTextColor)
        XCTAssertNotNil(rgba)
        
        XCTAssertNotNil(v.licenseFont)
        XCTAssertNotNil(v.headerFont)
        XCTAssertGreaterThan(v.licenseBorderWidth, 0)
    }
    
    fileprivate func _rgbaFromUIColor(_ color: UIColor) -> NSString {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return NSString(format: "rgba(%.0f, %.0f, %.0f, %.0f)", red * 255, green * 255, blue * 255, alpha)
    }
}
