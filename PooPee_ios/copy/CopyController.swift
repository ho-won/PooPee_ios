import UIKit
import Alamofire

class CopyController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusColor(color: colors.primary)
        
        _init()
        setListener()
    }
    
    func _init() {
        
    }
    
    func refresh() {
        
    }
    
    func setListener() {
        
    }
    
    /**
     * [POST]
     */
    func task() {
        var params: Parameters = Parameters()
        params.put("", "")
        
        BaseTask().request(url: NetDefine.TEST_API, method: .post, params: params
            , onSuccess: { response in
                
        }
            , onFailed: { statusCode in
                
        })
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        finish()
    }
    
}
