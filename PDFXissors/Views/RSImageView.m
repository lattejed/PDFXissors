//
//  RSImageView.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSImageView.h"

@implementation RSImageView

- (instancetype)initWithFrame:(NSRect)frameRect;
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setEditable:NO];
        [self setImageScaling:NSImageScaleAxesIndependently];
    }
    return self;
}

@end
