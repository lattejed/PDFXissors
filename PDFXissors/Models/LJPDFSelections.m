//
//  LJPDFSelections.m
//
//  Created by Matthew Smith on 4/28/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJPDFSelections.h"
#import "LJPDFSelection.h"

@interface LJPDFSelections ()

@property (nonatomic, strong) NSMutableDictionary* __selections;
@property (nonatomic, strong) LJPDFSelection* temporarySelection;

@end

@implementation LJPDFSelections

+ (instancetype)sharedInstance;
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)setTemporarySelectionWithSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
{
    LJPDFSelection* selection = [LJPDFSelection new];
    selection.type = kLJPDFSelectionTypePDF;
    selection.ID = UUID;
    selection.srcRect = srcRect;
    self.temporarySelection = selection;
    [N_CENTER postNotificationName:kNotificationPDFSelectionTempUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)setTemporarySelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
{
    LJPDFSelection* selection = [LJPDFSelection new];
    selection.type = kLJPDFSelectionTypeString;
    selection.ID = UUID;
    selection.string = string;
    self.temporarySelection = selection;
    [N_CENTER postNotificationName:kNotificationPDFSelectionTempUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)promoteTemporarySelection;
{
    [self addSelection:self.temporarySelection forSelectionID:self.temporarySelection.ID];
}

- (void)addSelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
{
    if (!self.__selections) self.__selections = [NSMutableDictionary dictionary];
    LJPDFSelection* selection = [LJPDFSelection new];
    selection.type = kLJPDFSelectionTypeString;
    selection.ID = UUID;
    selection.string = string;
    [self.__selections setObject:selection forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionAdd
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)addSelectionWithImage:(NSImage *)image forSelectionID:(NSString *)UUID;
{
    if (!self.__selections) self.__selections = [NSMutableDictionary dictionary];
    LJPDFSelection* selection = [LJPDFSelection new];
    selection.type = kLJPDFSelectionTypeImage;
    selection.ID = UUID;
    selection.image = image;
    [self.__selections setObject:selection forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionAdd
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)addSelection:(LJPDFSelection *)selection forSelectionID:(NSString *)UUID;
{
    if (!self.__selections) self.__selections = [NSMutableDictionary dictionary];
    [self.__selections setObject:selection forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionAdd
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)updateSelectionSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
{
    LJPDFSelection* selection = [self.__selections objectForKey:UUID];
    selection.srcRect = srcRect;
    [N_CENTER postNotificationName:kNotificationPDFSelectionSrcUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)updateSelectionDstRect:(CGRect)dstRect forSelectionID:(NSString *)UUID;
{
    LJPDFSelection* selection = [self.__selections objectForKey:UUID];
    selection.dstRect = dstRect;
    [N_CENTER postNotificationName:kNotificationPDFSelectionDstUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)removeSelectionForSelectionID:(NSString *)UUID;
{
    LJPDFSelection* selection = [self.__selections objectForKey:UUID];
    [self.__selections removeObjectForKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionRemove
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (NSDictionary *)selections;
{
    return [self.__selections copy];
}

- (BOOL)canPaste;
{
    return self.temporarySelection != nil;
}

@end
