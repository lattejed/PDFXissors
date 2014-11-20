//
//  LJPDFSelection.h
//
//  Created by Matthew Smith on 4/25/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJPDFSelection : NSObject

@property (nonatomic, assign) BOOL isRect;
@property (nonatomic, assign) BOOL isString;
@property (nonatomic, copy) NSString* ID;
@property (nonatomic, assign) CGRect srcRect;
@property (nonatomic, assign) CGRect dstRect;
@property (nonatomic, copy) NSAttributedString* string;
@property (nonatomic, copy) NSColor* color;

@end
