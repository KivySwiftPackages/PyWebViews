

import Foundation
import UIKit
import UIViewRender



extension WebViewer {
	
	public func startTextureRender(fps: Int) {
		guard displayLink == nil else { return }
		let displaylink = CADisplayLink(target: self, selector: #selector(next_frame))
		
		displaylink.preferredFramesPerSecond = fps
		displaylink.add(to: .main, forMode: .default)
		
		self.displayLink = displaylink
	}
	
	public func stopTextureRender() {
		self.displayLink?.remove(from: .main, forMode: .default)
		self.displayLink = nil
	}
	
	
	
	public func requestFrame() {
		let size = view.frame.size
		py_callback?.next_frame(frame: view.pixels(), size: [size.width * ui_scale, size.height * ui_scale] )
	}
	
	@objc
	func next_frame(displaylink: CADisplayLink) {
		requestFrame()
	}
}


extension JavaViewer {
	
	public func startTextureRender(fps: Int) {
		guard displayLink == nil else { return }
		let displaylink = CADisplayLink(target: self, selector: #selector(next_frame))
		
		displaylink.preferredFramesPerSecond = fps
		displaylink.add(to: .main, forMode: .default)
		
		self.displayLink = displaylink
	}
	
	public func stopTextureRender() {
		self.displayLink?.remove(from: .main, forMode: .default)
		self.displayLink = nil
	}
	
	
	
	public func requestFrame() {
		let size = view.frame.size
		py_callback?.next_frame(frame: view.pixels(), size: [size.width * ui_scale, size.height * ui_scale] )
	}
	
	@objc
	func next_frame(displaylink: CADisplayLink) {
		requestFrame()
	}
}
