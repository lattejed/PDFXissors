//
//  RSAppDelegate.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/6/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSView* leftToolbarView;
@property (nonatomic, strong) IBOutlet NSView* rightToolbarView;
@property (nonatomic, strong) IBOutlet NSSplitView* splitView;
@property (nonatomic, strong) IBOutlet NSView* leftPaneSplitView;
@property (nonatomic, strong) IBOutlet NSView* righPanetSplitView;

@end
