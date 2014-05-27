//
//  RSViewDrawBlock.m
//  PDFXissors
//
//  Created by Matthew Smith on 5/6/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSViewDrawBlock.h"

@implementation RSViewDrawBlock

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    if (self.drawBlock)
    {
        self.drawBlock(self, dirtyRect);
    }
}

@end
