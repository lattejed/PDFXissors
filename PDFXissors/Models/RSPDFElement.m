//
//  RSPDFElement.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSPDFElement.h"

@interface RSPDFElement ()

@property (nonatomic, assign) CGRect srcRect;
@property (nonatomic, assign) NSUInteger srcPage;
@property (nonatomic, copy) NSAttributedString* attributedString;
@property (nonatomic, strong) NSImage* image;
@property (nonatomic, copy) NSString* UUID;

@end

@implementation RSPDFElement

+ (instancetype)initWithURL:(NSURL *)url srcPage:(NSUInteger)srcPage srcRect:(CGRect)srcRect;
{
    RSPDFElement* element = [RSPDFElement new];
    element->_type = kRSPDFElementTypePDF;
    element.srcPage = srcPage;
    element.srcRect = srcRect;
    element.UUID = [NSString UUID];
    return element;
}

+ (instancetype)initWithAttributedString:(NSAttributedString *)attributedString;
{
    RSPDFElement* element = [RSPDFElement new];
    element->_type = kRSPDFElementTypeAttributedString;
    element.attributedString = attributedString;
    element.UUID = [NSString UUID];
    return element;
}

+ (instancetype)initWithImage:(NSImage *)image;
{
    RSPDFElement* element = [RSPDFElement new];
    element->_type = kRSPDFElementTypeImage;
    element.image = image;
    element.UUID = [NSString UUID];
    return element;
}

- (NSString *)ID;
{
    return self.UUID;
}

@end
