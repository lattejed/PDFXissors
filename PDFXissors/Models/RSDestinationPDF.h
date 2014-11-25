//
//  RSDestinationPDF.h
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSDestinationPDFPage;

@interface RSDestinationPDF : NSObject

- (NSUInteger)pageCount;
- (void)appendPageWithSize:(CGSize)size;
- (RSDestinationPDFPage *)pageForIndex:(NSUInteger)idx;

@end
