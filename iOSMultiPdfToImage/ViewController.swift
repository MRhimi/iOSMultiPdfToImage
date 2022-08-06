//
//  ViewController.swift
//  iOSMultiPdfToImage
//
//  Created by Kieron Cairns on 06/08/2022.
//

import UIKit
import PDFKit

class ViewController: UIViewController {

    @IBOutlet weak var btnSavePdf: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSavePdfAction(_ sender: Any) {
        print("Save PDF as Photo function hit")
        
        let image  = self.drawPDFfromURL()
        
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func drawPDFfromURL() -> UIImage? {
        
        let filePath = Bundle.main.path(forResource: "iOSDevelopment", ofType: "pdf")!
        
        let url = URL(fileURLWithPath: filePath)
        
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
       // guard let page = document.page(at: 1) else { return nil }
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        // calculating overall page size
        for index in 1...document.numberOfPages {
            print("index: \(index)")
            if let page = document.page(at: index) {
                let pageRect = page.getBoxRect(.mediaBox)
                width = max(width, pageRect.width)
                height = height + pageRect.height
            }
        }
        
        // now creating the image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let image = renderer.image { (ctx) in
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            for index in 1...document.numberOfPages {
                
                if let page = document.page(at: index) {
                    let pageRect = page.getBoxRect(.mediaBox)
                    ctx.cgContext.translateBy(x: 0.0, y: -pageRect.height)
                    ctx.cgContext.drawPDFPage(page)
                }
            }
            
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
        }
        return image
    }
    
}

