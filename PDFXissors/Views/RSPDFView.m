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
    if (self.allowNativeSelection())
    {
        [super setCursorForAreaOfInterest:area];
    }
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
    if (self.allowNativeSelection())
    {
        [super mouseDown:theEvent];
    }
    else
    {
        CGPoint origin = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        CGPoint origin2;
        while ((theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask]))
        {
            origin2 = [self convertPoint:[theEvent locationInWindow] fromView:nil];
            self.selectionRectDidUpdate(CGPoints2Frame(origin, origin2));
            if ([theEvent type] == NSLeftMouseUp) break;
        }
    }
}

- (void)drawPage:(PDFPage *)page;
{
    [super drawPage:page];
    if (!self.allowNativeSelection())
    {
        NSBezierPath* selection = [NSBezierPath bezierPathWithRect:[self convertRect:self.selectionRect() toPage:page]];
        CGFloat pattern[] = {12,12};
        [selection setLineDash:pattern count:2 phase:0];
        [[NSColor darkGrayColor] setStroke];
        [selection stroke];
    }
}

/*
- (void)drawPagePost:(PDFPage *)page;
{
    //[[NSColor redColor] setFill];
    //NSRectFill(self.bounds);
}
*/

@end
