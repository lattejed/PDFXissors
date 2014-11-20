//
//  NSImage+LJBlankImage.m
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "NSImage+LJBlankImage.h"

@implementation NSImage (LJBlankImage)

+ (instancetype)blankImageWithSize:(CGSize)size;
{
    NSImage* image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [[NSColor whiteColor] setFill];
    [NSBezierPath fillRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    return image;
}

@end
