//
//  RSDestinationPDF.h
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSDestinationPDF : NSObject

@property (strong) PDFDocument* document;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) CGFloat currentScale;

- (void)appendPage;

@end
