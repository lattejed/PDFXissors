//
//  LJResizableDraggableView.h
//  PDFXissors
//
//  Created by Matthew Smith on 11/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LJResizableDraggableView : NSView

@property (nonatomic, copy) NSColor* dragAreaColor;
@property (nonatomic, copy) NSColor* controlColor;
@property (nonatomic, assign) NSInteger contentInset;
@property (nonatomic, assign) NSInteger resizeAreaInset;
@property (nonatomic, assign) NSInteger controlLineWidth;
@property (nonatomic, assign) CGFloat controlBorderRadius;

@property (nonatomic, copy) void (^contentViewFrameUpdate)(NSView*, CGRect);
@property (nonatomic, copy) void (^viewDidClose)(NSView*);

+ (CGRect)initialFrameForParentView:(NSView *)view size:(CGSize)size preserveAspect:(BOOL)preserveAspect;

- (CGRect)contentViewFrame;
- (void)setContentView:(NSView *)contentView;

@end
