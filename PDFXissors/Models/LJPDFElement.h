//
//  LJPDFElement.h
//
//  Created by Matthew Smith on 4/25/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kLJPDFElementType) {
    kLJPDFElementTypePDF,
    kLJPDFElementTypeString,
    kLJPDFElementTypeImage
};

@interface LJPDFElement : NSObject

@property (nonatomic, assign) kLJPDFElementType type;
@property (nonatomic, copy) NSString* ID;
@property (nonatomic, assign) CGRect srcRect;
@property (nonatomic, assign) CGRect dstRect;
@property (nonatomic, copy) NSAttributedString* string;
@property (nonatomic, strong) NSImage* image;
@property (nonatomic, copy) NSColor* color;

@end
