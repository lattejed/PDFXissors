//
//  RSSourcePDF.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSourcePDF : NSObject

@property (nonatomic, copy) NSURL* url;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) CGFloat currentScale;

@end
