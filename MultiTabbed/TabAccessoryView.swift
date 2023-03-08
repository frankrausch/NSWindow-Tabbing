//
//  TabAccessoryView.swift
//  MultiTabbed
//
//  Created by Frank Rausch on 2023-03-08.
//

import Cocoa

class TabAccessoryView: NSView {

    weak private(set) var windowController: NSWindowController?

    private let tabDropTargetView: TabDropTargetView

    init(windowController: NSWindowController? = nil) {
        self.windowController = windowController
        self.tabDropTargetView = TabDropTargetView(windowController: windowController)
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidMoveToWindow() {
        guard tabDropTargetView.superview == nil else { return }

        // DEBUG: Highlight accessory view
        wantsLayer = true
        layer?.backgroundColor = NSColor.red.withAlphaComponent(0.1).cgColor

        // The NSTabButton close button, title, and accessory view are contained in a stack view:
        guard let stackView = superview as? NSStackView,
              let backgroundView = stackView.superview else { return }

        // Add the drop target view behind the NSTabButton’s NSStackView and pin it to the edges
        backgroundView.addSubview(tabDropTargetView, positioned: .below, relativeTo: stackView)
        tabDropTargetView.translatesAutoresizingMaskIntoConstraints = false
        tabDropTargetView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        tabDropTargetView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        tabDropTargetView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        tabDropTargetView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
    }

}
