
import UIKit

class LoadingViewController: UIViewController {
 
  static weak var parentView: UIViewController!
  static let serialNetQ =
  DispatchQueue(
    label: "net.loader.queue")
  
  static func load(complation: @escaping ()->(), parentView: UIViewController = LoadingViewController.parentView) {
      let loadingVC = LoadingViewController.getView()

    DispatchQueue.global(qos: .userInteractive).sync{
      print("order:", 1.1)
      DispatchQueue.main.async {
        parentView.present(loadingVC, animated: false, completion: nil)
      }
        
    }
    
    DispatchQueue.global(qos: .userInteractive).sync{
      print("order:", 1.2)
      complation()
    }
    
    
    DispatchQueue.global(qos: .userInteractive).sync{
      print("order:", 1.3)
      DispatchQueue.main.async {
        parentView.dismiss(animated: true)
      }
     
    }
  }
  
  static var isShown = false

  static func getView()-> LoadingViewController{
    let vc = LoadingViewController()
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    return vc
  }
  
  var loadingActivityIndicator: UIActivityIndicatorView = {
      let indicator = UIActivityIndicatorView()
      
      indicator.style = .large
      indicator.color = .white
          
      // The indicator should be animating when
      // the view appears.
      indicator.startAnimating()
          
      // Setting the autoresizing mask to flexible for all
      // directions will keep the indicator in the center
      // of the view and properly handle rotation.
      indicator.autoresizingMask = [
          .flexibleLeftMargin, .flexibleRightMargin,
          .flexibleTopMargin, .flexibleBottomMargin
      ]
          
      return indicator
  }()
  
  var blurEffectView: UIVisualEffectView = {
      let blurEffect = UIBlurEffect(style: .dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      
      blurEffectView.alpha = 0.8
      
      // Setting the autoresizing mask to flexible for
      // width and height will ensure the blurEffectView
      // is the same size as its parent view.
      blurEffectView.autoresizingMask = [
          .flexibleWidth, .flexibleHeight
      ]
      
      return blurEffectView
  }()
  
  override func viewDidLoad() {
      super.viewDidLoad()
    

      view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      
      // Add the blurEffectView with the same
      // size as view
      blurEffectView.frame = self.view.bounds
      view.insertSubview(blurEffectView, at: 0)
      
      // Add the loadingActivityIndicator in the
      // center of view
      loadingActivityIndicator.center = CGPoint(
          x: view.bounds.midX,
          y: view.bounds.midY
      )
      view.addSubview(loadingActivityIndicator)
  }
  
  
}