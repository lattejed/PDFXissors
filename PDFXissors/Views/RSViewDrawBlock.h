//
//  RSViewDrawBlock.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/6/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSViewDrawBlock : NSView

@property (nonatomic, copy) void (^drawBlock)(NSView* view, NSRect dirtyRect);

@end
