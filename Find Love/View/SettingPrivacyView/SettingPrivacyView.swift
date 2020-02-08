//
//  SettingPrivacyView.swift
//  Find Love
//
//  Created by Kaiserdem on 07.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingPrivacyView: UIView {
  
  @IBOutlet var settingPrivacyView: UIView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var cencelBtn: UIButton!
 
  let privacyTextRUS = """

  \t \t Landmarks Политика конфиденциальности
    
  \t Эта страница информирует вас о нашей политики конфиденциальности в отношении сбора, использования и раскрытия персональных данных, когда вы используете наше приложение, и о случаях, которые связаны с этими данными. Ваша конфиденциальность очень важна для нас.
  
  \t Приложение запрашивает разрешение на определение вашего местоположения, чтобы изменить расстояние от места и рассчитать маршрут до выбранных вами мест.
  
  \t Единственная цель сбора такой информации - навигационные и прикладные функции.
  
  \t Данные о том, где вы были, не были записаны и удалены сразу после выхода из приложения.
  
  \t Мы не собираем никакой личной информации, не запрашиваем ваше имя, адрес электронной почты, номер телефона или любую информацию о вас.
  \t Мы не продаем контент.
  \t Мы не требуем регистрации.
  \t Мы не отправляем новостные рассылки по электронной почте.
  \t Мы не продаем или иным образом не передаем вашу личную информацию третьим лицам.
  
  \t Безопасность вашей личной информации не будет нарушена.
"""
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    textView.contentOffset = .zero
    setupBtnSettings()
    textView.text = privacyTextRUS
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  func commonInit() {
    Bundle.main.loadNibNamed("SettingPrivacyView", owner: self, options: nil)
    settingPrivacyView.fixInView(self)
  }
  
  private func setupBtnSettings() {
    cencelBtn.setImage(UIImage(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    cencelBtn.imageView?.tintColor = .white
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
}
