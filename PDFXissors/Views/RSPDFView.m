//
//  RSPDFView.m
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSPDFView.h"

@implementation RSPDFView

- (void)setCursorForAreaOfInterest:(PDFAreaOfInterest)area;
{
    // Prevent PDFView from overriding custom cursors in our selection rects
    
    // TODO: Check if we're using rectangular cursor or the standard (text, others?) cursor. Use a block or delegate method.
    
}

- (void)zoomIn:(id)sender;
{
    // Prevent PDFView from zooming
}

- (void)zoomOut:(id)sender;
{
    // Prevent PDFView from zooming
}

- (void)mouseDown:(NSEvent *)theEvent;
{
    // PDFView handles mouse events poorly, we need to consume this to receive mouseDragged: events
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    //CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    //if (self.addSelectionView) self.addSelectionView(point, theEvent);
}

@end
