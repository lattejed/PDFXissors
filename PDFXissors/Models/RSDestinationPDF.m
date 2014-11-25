//
//  RSDestinationPDF.m
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSDestinationPDF.h"

@implementation RSDestinationPDF

// TODO: Add pages as some type of NSArray
// TODO: Add elements via pages

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

- (void)addPageWithSize:(CGSize)size;
{
    CGSize pointSize = (CGSize){size.width * 72, size.height * 72};
    NSImage* image = [NSImage blankImageWithSize:pointSize];
    PDFPage* page = [[PDFPage alloc] initWithImage:image];
    [page setBounds:(CGRect){0,0,pointSize} forBox:kPDFDisplayBoxArtBox];
    if (!_document)
    {
        _document = [PDFDocument new];
        [_document insertPage:page atIndex:0];
    }
    else
    {
        [_document insertPage:page atIndex:_currentPage + 1];
    }
    [N_CENTER postNotificationName:kNotificationDestinationPDFPageDidUpdate
                            object:self];
}

- (void)removeCurrentPage;
{
    [self.document removePageAtIndex:_currentPage];
    [N_CENTER postNotificationName:kNotificationDestinationPDFPageDidUpdate
                            object:self];
}

- (BOOL)canPaste;
{
    return _document != nil && _document.pageCount > 0;
}

@end
