## Save text from a UITextView to PDF Tutorial

#### The following tutorial code is put into ViewController.swift

#### Declare variables for setting the page size of the PDF after generating and create an outlet for a textview

```
var pageSize: CGSize! // set as a global variable
```

```
@IBOutlet var txtView: UITextView!
```

#### Create a button that as an action to generate the PDF

```
@IBAction func btnGeneratePDF(_: AnyObject)
{
    pageSize = CGSize(width: 850, height: 1100) // size of the page, 8.5 by 11 inch
    
    let path: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentDirectory: AnyObject = path.object(at: 0) as AnyObject
    
    let fileName = "MyDoc.pdf" // name of saved file
    var newFileName = ""
    let fileManager = FileManager.default
    var counter = 0
    
    let pdfPathWithFileName = documentDirectory.appending("/" + (fileName as String))
    var newPdfPathWithFileName = pdfPathWithFileName
    
    // for auto incrementing file if exists
    while fileManager.fileExists(atPath: newPdfPathWithFileName)
    {
        // logInfo { "file already exist. trying new filename" }
        counter += 1
        newFileName = "MyDoc(\(counter)).pdf"
        newPdfPathWithFileName = documentDirectory.appending("/" + (newFileName as String))
    }
    
    // lines written to get the document directory path for the generated pdf file.
    if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
    {
        print(documentsPath)
    }
    
    generatePDFs(filePath: newPdfPathWithFileName)
}
```

#### The logic for the function that generates the PDF
```
func generatePDFs(filePath: String)
{
    UIGraphicsBeginPDFContextToFile(filePath, CGRect.zero, nil)
    UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 768, height: 1024), nil)
    
    // conversion toPDF()
    drawBackground()
    drawText()
    
    UIGraphicsEndPDFContext()
}
```

#### Draws the custom background view to display the text & image in the PDF
```
func drawBackground()
{
    let context: CGContext = UIGraphicsGetCurrentContext()!
    let rect: CGRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
    
    context.setFillColor(UIColor.white.cgColor)
    context.fill(rect)
}
```

#### Draws the custom textview to display the text that will be entered into the PDF
```
func drawText()
{
    let context: CGContext = UIGraphicsGetCurrentContext()!
    let font = UIFont(name: "HelveticaNeue-UltraLight", size: CGFloat(20))!
    
    context.setFillColor(UIColor.orange.cgColor)
    
    // where the text begins and ends on the pdf page
    let textRect: CGRect = CGRect(x: 50, y: 50, width: pageSize.width - 180, height: pageSize.height - 100)
    let myString: NSString = txtView.text! as NSString
    let paraStyle = NSMutableParagraphStyle()
    
    paraStyle.lineSpacing = 6.0
    
    let fieldFont = UIFont(name: "Helvetica Neue", size: 30)
    let parameters: NSDictionary = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.font: fieldFont as Any]
    
    myString.draw(in: textRect, withAttributes: parameters as? [NSAttributedStringKey: Any])
}
```