//
//  RSDestinationPDFPage.h
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSPDFElement;

@interface RSDestinationPDFPage : NSObject

@property (nonatomic, assign, readonly) CGSize size;

+ (instancetype)pageWithSize:(CGSize)size;
- (void)addElement:(RSPDFElement *)element;
- (void)removeElement:(RSPDFElement *)element;

@end
