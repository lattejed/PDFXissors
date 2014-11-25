//
//  RSDestinationPDFController.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSDestinationPDFController.h"

@interface __DocumentView : NSView

@end

@implementation __DocumentView

- (BOOL)isFlipped; { return YES; }

@end

@interface RSDestinationPDFController ()

@property (nonatomic, weak) IBOutlet NSScrollView* scrollView;
@property (nonatomic, strong) __DocumentView* documentView;
@property (nonatomic, strong) NSMutableArray* pages;

@end

@implementation RSDestinationPDFController

- (void)awakeFromNib;
{
    CGRect frame = [self.scrollView.documentView frame];
    self.documentView = [[__DocumentView alloc] initWithFrame:frame];
    self.documentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.documentView = self.documentView;
    self.pages = [NSMutableArray array];
    self.layoutMargin = 10.0;
}

- (void)layoutPages;
{
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    CGFloat margin = self.layoutMargin;
    for (NSView* page in self.pages) {
        CGFloat newWidth = page.frame.size.width + margin * 2;
        if (newWidth > totalWidth) totalWidth = newWidth;
        totalHeight += page.frame.size.height + margin;
    }
    [self.documentView setFrameSize:CGSizeMake(totalWidth, totalHeight)];
    
    CGFloat yOffset = margin;
    for (NSView* page in self.pages) {
        CGFloat xOffset = floor((totalWidth - page.frame.size.width) / 2.0);
        [page setFrameOrigin:CGPointMake(xOffset, yOffset)];
        yOffset += page.frame.size.height + margin;
    }
}

- (void)addPage:(NSView *)page;
{
    [self.scrollView.documentView addSubview:page];
    [self.pages addObject:page];
    [self layoutPages];
}

- (void)removePageAtIndex:(NSUInteger)idx;
{
    NSView* page = [self.pages objectAtIndex:idx];
    [page removeFromSuperview];
    [self.pages removeObjectAtIndex:idx];
    [self layoutPages];
}

@end
