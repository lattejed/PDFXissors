//
//  LJResizableDraggableView.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "LJResizableDraggableView.h"

@interface LJResizableDraggableView ()

@property (nonatomic, copy) NSBezierPath* dragAreaPath;
@property (nonatomic, copy) NSBezierPath* resizeAreaPath;
@property (nonatomic, assign) CGRect closeAreaRect;
@property (nonatomic, copy) NSBezierPath* closeControlPath;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isResizing;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSView* contentView;
@property (nonatomic, assign) CGFloat aspect;

@end


@implementation LJResizableDraggableView

- (instancetype)initWithFrame:(NSRect)frameRect;
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.dragAreaColor = [NSColor colorWithCalibratedWhite:0.5 alpha:0.5];
        self.controlColor = [NSColor blackColor];
        self.contentInset = 20;
        self.resizeAreaInset = 2;
        self.controlBorderRadius = 10.0;
        self.controlLineWidth = 4;
        self.aspect = (CGFloat)frameRect.size.width / (CGFloat)frameRect.size.height;
        [self updateContent];
    }
    return self;
}

+ (CGRect)initialFrameForParentView:(NSView *)view size:(CGSize)size preserveAspect:(BOOL)preserveAspect;
{
    CGRect frame = CGRectZero;
    CGSize newSize = CGSizeZero;
    CGPoint origin = CGPointZero;
    CGFloat aspect = (CGFloat)size.width / (CGFloat)size.height;
    newSize.width = floor(view.bounds.size.width / 3.0);
    newSize.height = preserveAspect ? floor(newSize.width / aspect) : floor(view.bounds.size.height / 3.0);
    origin.x = floor((view.bounds.size.width - newSize.width) / 2.0);
    origin.y = floor((view.bounds.size.height - newSize.height) / 2.0);
    frame.origin = origin;
    frame.size = newSize;
    return frame;
}

- (CGRect)contentViewFrame;
{
    return CGRectInset(self.bounds, self.contentInset, self.contentInset);
}

- (void)setContentView:(NSView *)contentView;
{
    _contentView = contentView;
    [self addSubview:contentView];
    [self updateContent];
}

- (void)updateContent;
{
    self.dragAreaPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds
                                                        xRadius:self.controlBorderRadius
                                                        yRadius:self.controlBorderRadius];
    
    CGRect resizeRect = CGRectMake(NSMaxX(self.bounds) - self.contentInset,
                                   NSMaxY(self.bounds) - self.contentInset,
                                   self.contentInset, self.contentInset);
    resizeRect = CGRectInset(resizeRect, self.resizeAreaInset, self.resizeAreaInset);
    self.resizeAreaPath = [NSBezierPath bezierPathWithOvalInRect:resizeRect];
    
    CGRect closeRect = CGRectMake(NSMinX(self.bounds),
                                  NSMaxY(self.bounds) - self.contentInset,
                                  self.contentInset, self.contentInset);
    closeRect = CGRectInset(closeRect,
                            self.resizeAreaInset + (self.controlLineWidth / 4.0),
                            self.resizeAreaInset + (self.controlLineWidth / 4.0));
    self.closeAreaRect = closeRect;
    
    NSBezierPath* closePath = [NSBezierPath bezierPath];
    [closePath moveToPoint:CGPointMake(NSMinX(closeRect), NSMidY(closeRect))];
    [closePath lineToPoint:CGPointMake(NSMaxX(closeRect), NSMidY(closeRect))];
    [closePath moveToPoint:CGPointMake(NSMidX(closeRect), NSMinY(closeRect))];
    [closePath lineToPoint:CGPointMake(NSMidX(closeRect), NSMaxY(closeRect))];
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform translateXBy:NSMidX(closeRect) yBy:NSMidY(closeRect)];
    [transform rotateByDegrees:45];
    [transform translateXBy:-NSMidX(closeRect) yBy:-NSMidY(closeRect)];
    [closePath transformUsingAffineTransform:transform];
    [closePath setLineWidth:self.controlLineWidth];
    [closePath setLineCapStyle:NSSquareLineCapStyle];
    self.closeControlPath = closePath;
    
    if (self.contentView) {
        self.contentView.frame = [self contentViewFrame];
        if (self.contentViewFrameUpdate) self.contentViewFrameUpdate(self, self.contentView.frame);
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    if (!self.isActive) {
        [[self.dragAreaColor colorWithAlphaComponent:self.dragAreaColor.alphaComponent / 2.0] setFill];
    } else {
        [self.dragAreaColor setFill];
    }
    [self.dragAreaPath fill];
    
    if (self.isActive) {
        [self.controlColor setFill];
        [self.resizeAreaPath fill];
        [self.closeControlPath stroke];
    }
}

- (void)mouseDown:(NSEvent *)theEvent;
{
    if (!self.isActive) return;
    CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (CGRectContainsPoint(self.closeAreaRect, point)) {
        if (self.viewDidClose) self.viewDidClose(self);
    } else if ([self.resizeAreaPath containsPoint:point]) {
        self.isResizing = YES;
    } else if ([self.dragAreaPath containsPoint:point]) {
        self.isDragging = YES;
    }
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    if (!self.isActive) return;
    CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    CGPoint delta = CGPointZero;
    CGFloat minDim = self.contentInset * 3;
    while (YES)
    {
        theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
        BOOL preserveAspect = ([theEvent modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask;
        CGPoint currentPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        delta = CGPointSub(point, currentPoint);
        if (self.isDragging) {
            [self setFrameOrigin:CGPointSub(self.frame.origin, delta)];
            [self updateContent];
        } else if (self.isResizing) {
            CGSize newSize = CGSizeSub(self.frame.size, CGPoint2Size(delta));
            if (newSize.width < minDim) {
                newSize.width = minDim;
            } else {
                point = CGPointMake(currentPoint.x, point.y);
            }
            if (preserveAspect) {
                newSize.height = newSize.width / self.aspect;
            } else if (newSize.height < minDim) {
                newSize.height = minDim;
            } else {
                point = CGPointMake(point.x, currentPoint.y);
            }
            [self setFrameSize:newSize];
            [self updateContent];
        }
        if ([theEvent type] == NSLeftMouseUp)
        {
            [self mouseUp:theEvent];
            break;
        }
     }
}

- (void)mouseUp:(NSEvent *)theEvent;
{
    self.isDragging = NO;
    self.isResizing = NO;
}

- (BOOL)acceptsFirstResponder;
{
    return YES;
}

- (BOOL)becomeFirstResponder;
{
    self.isActive = YES;
    [self setNeedsDisplay:YES];
    return YES;
}

- (BOOL)resignFirstResponder;
{
    self.isActive = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

@end
