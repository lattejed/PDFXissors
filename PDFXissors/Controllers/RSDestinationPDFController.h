//
//  RSDestinationPDFController.h
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSDestinationPDFController : NSObject

@property (nonatomic, assign) CGFloat layoutMargin;

- (void)addPage:(NSView *)page;
- (void)removePageAtIndex:(NSUInteger)idx;

@end
