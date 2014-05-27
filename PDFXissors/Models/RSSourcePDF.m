//
//  RSSourcePDF.m
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSSourcePDF.h"

@implementation RSSourcePDF

- (void)setUrl:(NSURL *)url;
{
    _url = url;
    [N_CENTER postNotificationName:kNotificationSourcePDFDidUpdate
                            object:self];
}

- (void)setCurrentPage:(NSUInteger)currentPage;
{
    _currentPage = currentPage;
    [N_CENTER postNotificationName:kNotificationSourcePDFPageDidUpdate
                            object:self];
}

- (void)setCurrentScale:(CGFloat)currentScale
{
    _currentScale = currentScale;
    [N_CENTER postNotificationName:kNotificationSourcePDFZoomDidUpdate
                            object:self];
}

@end
