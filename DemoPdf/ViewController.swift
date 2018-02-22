//
//  ViewController.swift
//  DemoPdf
//
//  Created by Si-Yang Wu on 2018-02-21.
//  Copyright © 2018 Si-Yang Wu. All rights reserved.
//

import TraceLog
import UIKit

class ViewController: UIViewController
{
    // make the ordinary variable for pageSize of pdf we obtain after generating.
    var pageSize: CGSize!

    @IBOutlet var txtView: UITextView!

    // action method for generating into a pdf file.
    @IBAction func btnGeneratePDF(_: AnyObject)
    {
        logInfo { "entering: \(#function)" }
        pageSize = CGSize(width: 850, height: 1100) // size of the page, 8.5 by 11 inch
        // let fileName: NSString = "MyDoc.pdf"

        let path: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory: AnyObject = path.object(at: 0) as AnyObject

        let fileName = "MyDoc.pdf"

        logInfo { "fileName: \(fileName)" }

        let pdfPathWithFileName = documentDirectory.appending("/" + (fileName as String))
        var newPdfPathWithFileName = pdfPathWithFileName

        logInfo { "pdfPathWithFileName: \(pdfPathWithFileName)" }

        // added code for auto incrementing file if exists
        // ===========================================================================================================
        var newFileName = ""

        let fileManager = FileManager.default
        var counter = 0
        while fileManager.fileExists(atPath: newPdfPathWithFileName)
        {
            logInfo { "file already exist. trying new filename" }
            counter += 1
            newFileName = "MyDoc(\(counter)).pdf"
            newPdfPathWithFileName = documentDirectory.appending("/" + (newFileName as String))
//            guard (newURL.path) != newURL.path else
//            {
//                // Handle error (shouldn't happen anyway)
//                return
//            }
        }
        // ===========================================================================================================

        // lines written to get the document directory path for the generated pdf file.
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
        {
            print(documentsPath)
        }

        generatePDFs(filePath: newPdfPathWithFileName)
        logInfo { "leaving: \(#function)" }
    }

    // method to generate pdf file to display the text and image in pdf file.
    func generatePDFs(filePath: String)
    {
        logInfo { "entering: \(#function)" }
        UIGraphicsBeginPDFContextToFile(filePath, CGRect.zero, nil)
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 768, height: 1024), nil)

        // conversion toPDF()
        drawBackground()
        drawText()

        UIGraphicsEndPDFContext()
        logInfo { "leaving: \(#function)" }
    }

    // draw the custom background view to display the text and image in pdf.
    func drawBackground()
    {
        logInfo { "entering: \(#function)" }
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let rect: CGRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)

        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        logInfo { "leaving: \(#function)" }
    }

    // draw the custom textview to display the text enter into it into pdf.
    func drawText()
    {
        logInfo { "entering: \(#function)" }
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(20))!

        context.setFillColor(UIColor.orange.cgColor)

        let textRect: CGRect = CGRect(x: 50, y: 50, width: pageSize.width - 180, height: pageSize.height - 100)
        let myString: NSString = txtView.text! as NSString
        let paraStyle = NSMutableParagraphStyle()

        paraStyle.lineSpacing = 6.0

        let fieldFont = UIFont(name: "Helvetica Neue", size: 30)
        let parameters: NSDictionary = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.font: fieldFont as Any]

        myString.draw(in: textRect, withAttributes: parameters as? [NSAttributedStringKey: Any])
        logInfo { "leaving: \(#function)" }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        logInfo { "entering: \(#function)" }
        logInfo { "leaving: \(#function)" }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        logInfo { "entering: \(#function)" }
        logInfo { "leaving: \(#function)" }
    }
}
