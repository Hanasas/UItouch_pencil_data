//
//  viewController.swift
//  test
//
//  Created by 勾陈 on 2024/10/10.
//

import Foundation

class ViewController: UIViewController {

    var path = UIBezierPath()  // 用于保存绘制路径
    var previousTouchLocation: CGPoint?  // 保存上一个触摸点，用于连接线段
    
    // 用于存储绘制的线条
    var drawLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.blue.cgColor  // 绘制线条颜色
        layer.lineWidth = 3.0  // 线条粗细
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将绘制层添加到视图
        view.layer.addSublayer(drawLayer)
        
        // 允许用户多点触控
        self.view.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.type == .pencil else { return }
        
        let location = touch.location(in: self.view)  // 获取触摸点位置
        
        // 创建新路径
        path = UIBezierPath()
        path.move(to: location)  // 移动到触摸点
        
        // 存储初始触摸点
        previousTouchLocation = location
        
        // 立即更新显示
        updateDrawing()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.type == .pencil else { return }

        let location = touch.location(in: self.view)  // 获取当前触摸点
        let force = touch.force  // 获取压力值
        let azimuthAngle = touch.azimuthAngle(in: self.view)  // 获取方位角
        let altitudeAngle = touch.altitudeAngle  // 获取倾斜角度
        
        // 显示Apple Pencil的相关信息
        print("Location: \(location), Force: \(force), Azimuth: \(azimuthAngle), Altitude: \(altitudeAngle)")
        
        // 绘制线条
        if let previousLocation = previousTouchLocation {
            path.addLine(to: location)
            previousTouchLocation = location
        }
        
        // 更新绘制
        updateDrawing()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.type == .pencil else { return }

        let location = touch.location(in: self.view)
        
        // 完成路径
        path.addLine(to: location)
        previousTouchLocation = nil
        
        // 更新绘制
        updateDrawing()
    }
    
    // 更新绘图
    private func updateDrawing() {
        drawLayer.path = path.cgPath
    }
}
