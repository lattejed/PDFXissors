//
//  RSDestinationPDF.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSDestinationPDF.h"
#import "RSDestinationPDFPage.h"

@interface RSDestinationPDF ()

@property (nonatomic, strong) NSMutableArray* pages;

@end

@implementation RSDestinationPDF

- (NSUInteger)pageCount;
{
    return self.pages.count;
}

- (void)appendPageWithSize:(CGSize)size;
{
    RSDestinationPDFPage* page = [RSDestinationPDFPage pageWithSize:size];
    [self.pages addObject:page];
    [N_CENTER postNotificationName:kNotificationDestinationPDFPagesDidUpdate
                            object:self];
}

- (RSDestinationPDFPage *)pageForIndex:(NSUInteger)idx;
{
    return self.pages.count < idx ? _pages[idx] : nil;
}

- (NSMutableArray *)pages;
{
    if (_pages == nil) _pages = [NSMutableArray array];
    return _pages;
}

@end
