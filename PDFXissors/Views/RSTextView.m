//
//  RSTextView.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSTextView.h"

@implementation RSTextView

- (instancetype)initWithFrame:(NSRect)frameRect;
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setDrawsBackground:NO];
        [self setAllowsImageEditing:NO];
        [self setImportsGraphics:NO];
        [self setUsesRuler:NO];
        [self setUsesInspectorBar:NO];
        [self setHorizontallyResizable:NO];
        [self setVerticallyResizable:NO];
    }
    return self;
}

@end
