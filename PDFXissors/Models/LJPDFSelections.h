//
//  LJPDFSelections.h
//
//  Created by Matthew Smith on 4/28/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJPDFSelections : NSObject

// TODO: How are we handling text selections?

+ (instancetype)sharedInstance;
- (void)setTemporarySelectionWithSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
- (void)setTemporarySelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
- (void)addSelectionWithID:(NSString *)UUID;
- (void)updateSelectionSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
- (void)updateSelectionDstRect:(CGRect)dstRect forSelectionID:(NSString *)UUID;
- (void)removeSelectionForSelectionID:(NSString *)UUID;
- (NSDictionary *)selections;

@end
