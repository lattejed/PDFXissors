//
//  NSButton+LJBlocks.h
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (LJBlocks)

- (void)setActionBlock:(void (^)(void))block;

@end
