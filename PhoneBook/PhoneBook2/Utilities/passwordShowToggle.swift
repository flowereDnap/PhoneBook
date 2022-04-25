
import UIKit


let button = UIButton(type: .custom)

extension UITextField {
    
    func enablePasswordToggle(){
      let font = UIFont.systemFont(ofSize: 14)
      let attributes = [NSAttributedString.Key.font: font, .foregroundColor: UIColor.black]
      let attributedQuote = NSAttributedString(string: "Show  ", attributes: attributes)
      button.setAttributedTitle(attributedQuote, for: .normal)
      let attributedQuote2 = NSAttributedString(string: "Hide  ", attributes: attributes)
      button.setAttributedTitle(attributedQuote2, for: .selected)
      button.setTitleColor(.black, for: .normal)
      button.setTitleColor(.black, for: .selected)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
      self.rightView = button
      self.rightViewMode = .always
      button.alpha = 0.4
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
  
  
}
