//
//  GlowBorder.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation
import SwiftUI

struct GlowBorder: ViewModifier {
    var color: Color
    var lineWidth: Int
    
    func body(content: Content) -> some View {
        var newContent = AnyView(content)
        
        for _ in 0 ..< lineWidth {
            newContent = AnyView(newContent.shadow(color: color, radius: 1))
        }
        
        return newContent
    }
}

extension View {
    func glowBorder(color: Color, lineWidth: Int) -> some View {
        self.modifier(GlowBorder(color: color, lineWidth: lineWidth))
    }
}
