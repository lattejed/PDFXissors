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

- (void)setSelectionType:(kRSSourcePDFSelectionType)selectionType;
{
    _selectionType = selectionType;
    [N_CENTER postNotificationName:kNotificationSourcePDFSelectionTypeUpdate
                            object:self];
}

- (void)setCurrentSelectionRect:(CGRect)currentSelectionRect;
{
    _currentSelectionRect = currentSelectionRect;
    [N_CENTER postNotificationName:kNotificationSourcePDFSelectionRectUpdate
                            object:self];
}

- (void)setCurrentSelectionString:(NSAttributedString *)currentSelectionString;
{
    _currentSelectionString = currentSelectionString;
    [N_CENTER postNotificationName:kNotificationSourcePDFSelectionStringUpdate
                            object:self];
}

- (BOOL)canCopy;
{
    if (self.selectionType == kRSSourcePDFSelectionTypeRectangle)
    {
        return self.currentSelectionRect.size.width > 0 && self.currentSelectionRect.size.height > 0;
    }
    else if (self.selectionType == kRSSourcePDFSelectionTypeText)
    {
        return self.currentSelectionString != nil;
    }
    return NO;
}

@end
