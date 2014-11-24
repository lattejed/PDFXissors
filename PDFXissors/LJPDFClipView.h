//
//  LJPDFClipView.h
//  PDFManipulation
//
//  Created by Matthew Smith on 4/25/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LJDragResizeView;

@interface LJPDFClipView : NSView

@property (nonatomic, assign) CGRect srcRect;

- (void)setSourcePDFURL:(NSURL *)sourcePDFURL page:(NSUInteger)page;

@end
