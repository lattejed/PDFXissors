//
//  LJPDFClipView.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/25/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJPDFClipView.h"
#import "LJPDFHelpers.h"

@interface LJPDFClipView ()

@property (nonatomic, retain) CGPDFDocumentRef pdfDocRef __attribute__((NSObject));
@property (nonatomic, retain) CGPDFPageRef pdfPageRef __attribute__((NSObject));
@property (nonatomic, copy) NSURL* __sourcePDFURL;
@property (nonatomic, assign) NSUInteger srcPageNum;

@end

@implementation LJPDFClipView

- (void)setSourcePDFURL:(NSURL *)sourcePDFURL page:(NSUInteger)page;
{
    self.__sourcePDFURL = sourcePDFURL;
    self.srcPageNum = page;
    if (sourcePDFURL)
    {
        self.pdfDocRef = PDFGetDocumentRef([sourcePDFURL fileSystemRepresentation]);
        self.pdfPageRef = PDFGetPageRef(self.srcPageNum, self.pdfDocRef);
    }
    else
    {
        self.pdfDocRef = nil;
        self.pdfPageRef = nil;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    if (self.pdfPageRef)
    {
        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        PDFPageDrawInContextWithSrcRectDstRect(ctx, self.pdfPageRef, self.srcRect, self.bounds);
    }
}

@end
