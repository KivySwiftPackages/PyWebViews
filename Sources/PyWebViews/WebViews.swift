//
//  WebViewScreen.swift
//  test
//
//  Created by MusicMaker on 08/01/2023.
//

import Foundation

import WebKit
import UIKit
import PythonCore
//import KivyTex

import KivyTexture
import UIViewRender

fileprivate let retinaScale = 1.0 / UIScreen.main.nativeScale
fileprivate let screen_size = UIScreen.main.nativeBounds

let ui_scale = UIScreen.main.scale


fileprivate func invertedHeight(_ v: Double) -> Double {
    var result: Double = 0
	let device = UIDevice.current
    let o = device.orientation
	
	switch o {
	case .portrait, .portraitUpsideDown:
		result = screen_size.height - v
	case .landscapeLeft, .landscapeRight:
		result = screen_size.width - v
	default:
		let size = screen_size
		let w = size.width
		let h = size.height
		if w > h {
			result = h - v
		} else {
			result = w - v
		}
	}
	
    return result
}

fileprivate extension Double {
    var retinaScaled: Self { self * retinaScale }
}

public protocol WKBase {
	var view: WKWebView { get }
}

extension WKBase {
	public func set_pos(x: Double, y: Double) {
		view.frame.origin = .init(x: x.retinaScaled, y: invertedHeight(y).retinaScaled)
	}
	public func set_size(w: Double, h: Double) {
		view.frame.size = .init(width: w.retinaScaled, height: h.retinaScaled)
	}
}

public class WebViewer: WKBase {
    
    public let view = WKWebView()
    var frame: CGRect = UIScreen.main.bounds
    var viewcontroller: UIViewController?
	
	public var py_callback: PyCallback?
	
	var displayLink: CADisplayLink?
	
	init() {
		
	}
	
}

extension WebViewer: WebViewer_PyProtocol {
    
	public func set_callback(callback: PyPointer) {
		py_callback = .init(callback: callback)
	}
    
    var can_go_forward: Bool { view.canGoForward}
    
    var can_go_back: Bool { view.canGoBack}
	
	public func show() {
		guard
			let window = UIApplication.shared.windows.first,
			let kivy_vc = window.rootViewController
        else { fatalError() }
        kivy_vc.view.addSubview(view)
    }
    
	public func present() {
        viewcontroller = .init()
        guard
            let window = UIApplication.shared.windows.first,
            let kivy_vc = window.rootViewController,
            let vc = viewcontroller
        else { return }
                
        vc.view = view
        kivy_vc.present(vc, animated: true)
    }
    
	public func dismiss() {
        
        if viewcontroller != nil {
            viewcontroller?.dismiss(animated: true)
            viewcontroller = nil
            return
        }
        
        view.removeFromSuperview()
        
    }
    
	public func reload() {
        view.reload()
    }
    
	public func reloadFromOrigin() {
        view.reloadFromOrigin()
    }
    
	public func forward() {
        view.goForward()
    }
    
	public func back() {
        view.goBack()
    }
    
	public func load_data(data: Data, mime: String, char_encoing: String, base_url: String) {
        view.load(data, mimeType: mime, characterEncodingName: char_encoing, baseURL: .init(string: base_url)!)
    }
    
	public func load_url(url: String) {
        
        DispatchQueue.global().async {
            guard let url = URL(string: url) else { return }
            let request = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.view.load(request)
            }
        }
        
    }
    
    func load_html_string(string: String, base_url: String) {
        let base: URL? = base_url != "" ? .init(string: base_url) : nil
        view.loadHTMLString(string, baseURL: base)
    }
    
	public func load_html_string(string: String, base_url: String?) {
        var base: URL? = nil
        if let base_url = base_url {
            base = .init(string: base_url)
        }
        view.loadHTMLString(string, baseURL: base)
    }
    
}




public class JavaViewer: WKBase {
    
    public let view = WKWebView()
    var frame: CGRect = UIScreen.main.bounds
    var viewcontroller: UIViewController?
	var displayLink: CADisplayLink?
	public var py_callback: PyCallback?
	
	public init() {
		
	}
	public func set_callback(callback: PyPointer) {
		py_callback = .init(callback: callback)
	}
}

extension JavaViewer: JavaViewer_PyProtocol {
	
	
	
	public func load_html(html: String) {
        DispatchQueue.global().async {
            DispatchQueue.main.async { [weak self] in
                self?.view.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
	public func evaluate_javascript(js: String) {
        DispatchQueue.global().async {
            DispatchQueue.main.async { [weak self] in
                self?.view.evaluateJavaScript(js)
            }
        }
        
    }
	
	
    
//	public func set_frame(x: Double, y: Double, w: Double, h: Double) {
//        print("set frame:",x,y,w,h)
//        view.frame = .init(x: x.retinaScaled, y: y.retinaScaled, width: w.retinaScaled, height: h.retinaScaled)
//    }
    
	public func show() {
        guard
            let window = UIApplication.shared.windows.first,
            let kivy_vc = window.rootViewController
        else { return }
        //view.frame = frame
        kivy_vc.view.addSubview(view)
    }
    
	public func present() {
        viewcontroller = .init()
        guard
            let window = UIApplication.shared.windows.first,
            let kivy_vc = window.rootViewController,
            let vc = viewcontroller
        else { return }
        vc.view = view
        kivy_vc.present(vc, animated: true)
    }
    
	public func dismiss() {
        
        if viewcontroller != nil {
            viewcontroller?.dismiss(animated: true)
            viewcontroller = nil
            return
        }
        
        view.removeFromSuperview()
        
    }
    
    func reload() {
        view.reload()
    }
}




