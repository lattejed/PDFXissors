//
//  RSPDFElement.h
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kRSPDFElementType) {
    kRSPDFElementTypePDF,
    kRSPDFElementTypeAttributedString,
    kRSPDFElementTypeImage
};

@interface RSPDFElement : NSObject

@property (nonatomic, assign, readonly) kRSPDFElementType type;
@property (nonatomic, assign) CGRect dstRect;

+ (instancetype)initWithURL:(NSURL *)url srcPage:(NSUInteger)srcPage srcRect:(CGRect)srcRect;
+ (instancetype)initWithAttributedString:(NSAttributedString *)attributedString;
+ (instancetype)initWithImage:(NSImage *)image;
- (NSString *)ID;

@end
