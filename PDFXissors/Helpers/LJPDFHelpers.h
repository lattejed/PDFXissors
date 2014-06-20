//
//  LJPDFHelpers.h
//  PDFManipulation
//
//  Created by Matthew Smith on 4/24/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Foundation/Foundation.h>

CGPDFDocumentRef PDFGetDocumentRef(const char *filename);
CGPDFPageRef PDFGetPageRef(size_t pageNumber, CGPDFDocumentRef docRef);
void PDFPageDrawInContextWithSrcRectDstRect(CGContextRef ctx, CGPDFPageRef page, CGRect srcRect, CGRect dstRect);
