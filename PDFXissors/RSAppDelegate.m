//
//  RSAppDelegate.m
//  PDFXissors
//
//  Created by Matthew Smith on 5/6/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSAppDelegate.h"
#import <INAppStoreWindow/INAppStoreWindow.h>
#import "RSViewDrawBlock.h"

@implementation RSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    INAppStoreWindow *aWindow = (INAppStoreWindow*)self.window;
    aWindow.titleBarHeight = 60.0;
    aWindow.centerTrafficLightButtons = NO;
    aWindow.showsTitle = YES;
    aWindow.titleTextColor = [NSColor colorWithCalibratedWhite:0.75 alpha:1.0];
    NSShadow* titleShadow = [[NSShadow alloc] init];
    [titleShadow setShadowColor:[NSColor blackColor]];
    [titleShadow setShadowOffset:(CGSize){0, 1}];
    aWindow.titleTextShadow = titleShadow;
    
    self.leftToolbarView.frame = (CGRect){0, 0, self.leftToolbarView.bounds.size.width, aWindow.titleBarView.bounds.size.height};
    [aWindow.titleBarView addSubview:self.leftToolbarView];
    
    self.rightToolbarView.frame = (CGRect){500, 0, self.rightToolbarView.bounds.size.width, aWindow.titleBarView.bounds.size.height};
    [aWindow.titleBarView addSubview:self.rightToolbarView];
    
    // TODO: Move this into a custom view so we don't have drawing code here
    NSView* contentView = self.window.contentView;
    RSViewDrawBlock* contentView2 = [[RSViewDrawBlock alloc] initWithFrame:contentView.bounds];
    contentView2.drawBlock = ^(NSView* view, NSRect dirtyRect) {
        
        [[NSColor colorWithCalibratedWhite:0.15 alpha:1.0] setFill];
        [NSBezierPath fillRect:view.bounds];
        
        [[NSColor colorWithCalibratedWhite:0.10 alpha:1.0] setFill];
        [NSBezierPath fillRect:(CGRect){0, view.bounds.size.height - 1, view.bounds.size.width, 1}];
    };
    [contentView addSubview:contentView2];
    
    self.splitView.dividerStyle = NSSplitViewDividerStyleThick;
    self.splitView.frame = contentView2.bounds;
    [contentView2 addSubview:self.splitView];
    
    
    
    void (^moveRightToolbar)(void) = ^{
        self.rightToolbarView.frame = (CGRect){ self.righPanetSplitView.frame.origin.x - 15, 0,
                                                self.rightToolbarView.bounds.size.width,
                                                aWindow.titleBarView.bounds.size.height};
    };
    
    moveRightToolbar();
    [[NSNotificationCenter defaultCenter] addObserverForName:NSSplitViewDidResizeSubviewsNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      moveRightToolbar();
                                                  }];

    [aWindow setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath)
     {
         CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
         CGContextAddPath(ctx, clippingPath);
         CGContextClip(ctx);
         NSGradient *gradient = nil;
         gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.35 alpha:1.0]
                                                  endingColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0]];
         [[NSColor darkGrayColor] setFill];
         [gradient drawInRect:drawingRect angle:-90];
     }];
}

@end
