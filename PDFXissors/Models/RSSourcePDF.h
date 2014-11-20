//
//  RSSourcePDF.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kRSSourcePDFSelectionType) {
    kRSSourcePDFSelectionTypeRectangle,
    kRSSourcePDFSelectionTypeText
};

@interface RSSourcePDF : NSObject

@property (nonatomic, copy) NSURL* url;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) kRSSourcePDFSelectionType selectionType;
@property (nonatomic, assign) CGRect currentSelectionRect;
@property (nonatomic, assign) NSAttributedString* currentSelectionString;

- (BOOL)canCopy;

@end
