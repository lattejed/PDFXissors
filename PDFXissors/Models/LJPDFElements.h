//
//  LJPDFElements.h
//
//  Created by Matthew Smith on 4/28/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJPDFElement;

@interface LJPDFElements : NSObject

+ (instancetype)sharedInstance;
- (void)setTemporaryElementWithSrcRect:(CGRect)srcRect forElementID:(NSString *)UUID;
- (void)setTemporaryElementWithString:(NSAttributedString *)string forElementID:(NSString *)UUID;
- (void)promoteTemporaryElement;
- (void)addElementWithString:(NSAttributedString *)string forElementID:(NSString *)UUID;
- (void)addElementWithImage:(NSImage *)image forElementID:(NSString *)UUID;
- (void)addElement:(LJPDFElement *)element forElementID:(NSString *)UUID;
- (void)updateElementSrcRect:(CGRect)srcRect forElementID:(NSString *)UUID;
- (void)updateElementDstRect:(CGRect)dstRect forElementID:(NSString *)UUID;
- (void)removeElementForElementID:(NSString *)UUID;
- (NSDictionary *)elements;
- (BOOL)canPaste;

@end
