//
//  TabAccessoryView.swift
//  MultiTabbed
//
//  Created by Frank Rausch on 2023-03-08.
//

import Cocoa

class TabDropTargetView: NSView {
    private(set) weak var windowController: NSWindowController?

    let allowedDropTypes: Array<NSPasteboard.PasteboardType> = [.URL, .fileContents, .string, .html, .rtf]

    init(windowController: NSWindowController? = nil) {
        self.windowController = windowController
        super.init(frame: .zero)

        // Tell the system that we accept drops on this view
        registerForDraggedTypes(allowedDropTypes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidMoveToWindow() {
        // DEBUG: Highlight drop target view
        wantsLayer = true
        layer?.backgroundColor = NSColor.green.withAlphaComponent(0.05).cgColor
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Optional: Ignore drags from the same window
        guard (sender.draggingSource as? NSView)?.window != window else { return .generic }

        return .copy
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        // Optional: Ignore drags from the same window
        guard (sender.draggingSource as? NSView)?.window != window else { return .generic }

        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        // Optional: Ignore drags from the same window
        guard (sender.draggingSource as? NSView)?.window != window else { return false }

        // Check if the dropped item contains text:
        let pasteboard = sender.draggingPasteboard
        guard let availableType = pasteboard.availableType(from: allowedDropTypes),
              let text = pasteboard.string(forType: availableType) else {
            return false
        }

        if let windowController = windowController as? WindowController {
            // Use the reference to the tab’s NSWindowController to pass the dropped item
             windowController.handleDroppedText(text)
        }

        return true
    }
}
