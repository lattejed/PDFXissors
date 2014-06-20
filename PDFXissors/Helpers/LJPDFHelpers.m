//
//  LJPDFHelpers.m
//
//  Created by Matthew Smith on 4/24/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJPDFHelpers.h"

CGPDFDocumentRef PDFGetDocumentRef(const char *filename)
{
    CFStringRef path = CFStringCreateWithCString(NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CGPDFDocumentRef doc = CGPDFDocumentCreateWithURL(url);
    CFRelease(path);
    CFRelease(url);
    return (CGPDFDocumentGetNumberOfPages(doc) > 1) ? doc : NULL;
}

CGPDFPageRef PDFGetPageRef(size_t pageNumber, CGPDFDocumentRef docRef)
{
    return CGPDFDocumentGetPage(docRef, pageNumber);
}

void PDFPageDrawInContextWithSrcRectDstRect(CGContextRef ctx, CGPDFPageRef page, CGRect srcRect, CGRect dstRect)
{
    CGSize scale = CGSizeMake(dstRect.size.width / srcRect.size.width,
                              dstRect.size.height / srcRect.size.height);
    
    CGAffineTransform t = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, CGRectInfinite, 0, true);
    CGContextSaveGState(ctx);
    CGContextBeginTransparencyLayer(ctx, NULL);
    CGContextConcatCTM(ctx, t);
    CGAffineTransform m = CGAffineTransformMakeTranslation(-srcRect.origin.x * scale.width,
                                                           -srcRect.origin.y * scale.height);
    CGContextConcatCTM(ctx, m);
    CGAffineTransform s = CGAffineTransformMakeScale(scale.width, scale.height);
    CGContextConcatCTM(ctx, s);
    CGContextClipToRect(ctx, srcRect);
    CGContextDrawPDFPage(ctx, page);
    CGContextEndTransparencyLayer(ctx);
    CGContextRestoreGState(ctx);
}
