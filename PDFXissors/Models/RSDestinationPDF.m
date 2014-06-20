//
//  RSDestinationPDF.m
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSDestinationPDF.h"

@implementation RSDestinationPDF

- (id)init;
{
    if (self = [super init])
    {
        self.document = [[PDFDocument alloc] init];
        [N_CENTER postNotificationName:kNotificationDestinationPDFDidUpdate
                                object:self];
        [self appendPage];
    }
    return self;
}

- (void)setCurrentPage:(NSUInteger)currentPage;
{
    _currentPage = currentPage;
    [N_CENTER postNotificationName:kNotificationDestinationPDFPageDidUpdate
                            object:self];
}

- (void)setCurrentScale:(CGFloat)currentScale
{
    _currentScale = currentScale;
    [N_CENTER postNotificationName:kNotificationDestinationPDFZoomDidUpdate
                            object:self];
}

- (void)appendPage;
{
    PDFPage* page = [[PDFPage alloc] init]; // TODO:
    [self.document insertPage:page atIndex:[self.document pageCount]];
    [N_CENTER postNotificationName:kNotificationDestinationPDFPageDidUpdate
                            object:self];
}

@end
