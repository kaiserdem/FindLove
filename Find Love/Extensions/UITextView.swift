//
//  UITextView.swift
//  Find Love
//
//  Created by Kaiserdem on 23.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

extension UITextView {
  
  func centerVertically() {
    let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let size = sizeThatFits(fittingSize)
    let topOffset = (bounds.size.height - size.height * zoomScale) / 2
    let positiveTopOffset = max(1, topOffset)
    contentOffset.y = -positiveTopOffset
  }
  
}


