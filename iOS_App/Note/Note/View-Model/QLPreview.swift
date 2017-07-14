import UIKit
import QuickLook

class QLPreview: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    var previewUrl:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: QLPreview delegate methods
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        print("Getting item")
        return self.previewUrl! as QLPreviewItem
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("\(self) deinit")
    }
}
