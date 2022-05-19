
import UIKit


let button = UIButton(type: .custom)
let button2 = UIButton(type: .custom)
let button3 = UIButton(type: .custom)

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
  
  func enablePasswordToggle2(){
    let font = UIFont.systemFont(ofSize: 14)
    let attributes = [NSAttributedString.Key.font: font, .foregroundColor: UIColor.black]
    let attributedQuote = NSAttributedString(string: "Show  ", attributes: attributes)
    button2.setAttributedTitle(attributedQuote, for: .normal)
    let attributedQuote2 = NSAttributedString(string: "Hide  ", attributes: attributes)
    button2.setAttributedTitle(attributedQuote2, for: .selected)
    button2.setTitleColor(.black, for: .normal)
    button2.setTitleColor(.black, for: .selected)
      button2.addTarget(self, action: #selector(togglePasswordView2), for: .touchUpInside)
    self.rightView = button2
    self.rightViewMode = .always
    button2.alpha = 0.4
  }
  
  @objc func togglePasswordView2(_ sender: Any) {
      isSecureTextEntry.toggle()
      button2.isSelected.toggle()
  }
  
  func enablePasswordToggle3(){
    let font = UIFont.systemFont(ofSize: 14)
    let attributes = [NSAttributedString.Key.font: font, .foregroundColor: UIColor.black]
    let attributedQuote = NSAttributedString(string: "Show  ", attributes: attributes)
    button3.setAttributedTitle(attributedQuote, for: .normal)
    let attributedQuote2 = NSAttributedString(string: "Hide  ", attributes: attributes)
    button3.setAttributedTitle(attributedQuote2, for: .selected)
    button3.setTitleColor(.black, for: .normal)
    button3.setTitleColor(.black, for: .selected)
      button3.addTarget(self, action: #selector(togglePasswordView3), for: .touchUpInside)
    self.rightView = button3
    self.rightViewMode = .always
    button3.alpha = 0.4
  }
  
  @objc func togglePasswordView3(_ sender: Any) {
      isSecureTextEntry.toggle()
      button3.isSelected.toggle()
  }
  
}
