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
        
        let filePath = Bundle.main.path(forResource: "Scanned-Docs", ofType: "pdf")!
      
        let url = URL(fileURLWithPath: filePath)
        
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
    
}

