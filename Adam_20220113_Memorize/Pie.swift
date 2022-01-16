//
//  Pie.swift
//  Adam_20220113_Memorize
//
//  Created by Adam on 2022/1/16.
//

import SwiftUI

struct Pie: Shape {
    private(set) var startAngle: Angle
    private(set) var endAngle: Angle
    private(set) var clockwise: Bool = false
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = CGFloat((Int(min(rect.width, rect.height)) >> 1))
        let start = CGPoint(x: center.x + CGFloat(radius * cos(startAngle.radians)),
                            y: center.y + CGFloat(radius * sin(startAngle.radians))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        path.addLine(to: center)
        return path
    }
    
 
}
