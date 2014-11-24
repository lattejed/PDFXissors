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
- (void)setTemporarySelectionWithSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
- (void)setTemporarySelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
- (void)promoteTemporarySelection;
- (void)addSelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
- (void)addSelectionWithImage:(NSImage *)image forSelectionID:(NSString *)UUID;
- (void)addSelection:(LJPDFElement *)selection forSelectionID:(NSString *)UUID;
- (void)updateSelectionSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
- (void)updateSelectionDstRect:(CGRect)dstRect forSelectionID:(NSString *)UUID;
- (void)removeSelectionForSelectionID:(NSString *)UUID;
- (NSDictionary *)selections;
- (BOOL)canPaste;

@end
