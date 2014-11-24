//
//  LJPDFElements.m
//
//  Created by Matthew Smith on 4/28/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJPDFElement.h"
#import "LJPDFElements.h"

@interface LJPDFElements ()

@property (nonatomic, strong) NSMutableDictionary* __selections;
@property (nonatomic, strong) LJPDFElement* temporarySelection;

@end

@implementation LJPDFElements

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
    LJPDFElement* selection = [LJPDFElement new];
    selection.type = kLJPDFElementTypePDF;
    selection.ID = UUID;
    selection.srcRect = srcRect;
    self.temporarySelection = selection;
    [N_CENTER postNotificationName:kNotificationPDFSelectionTempUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)setTemporarySelectionWithString:(NSAttributedString *)string forSelectionID:(NSString *)UUID;
{
    LJPDFElement* selection = [LJPDFElement new];
    selection.type = kLJPDFElementTypeString;
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
    LJPDFElement* selection = [LJPDFElement new];
    selection.type = kLJPDFElementTypeString;
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
    LJPDFElement* selection = [LJPDFElement new];
    selection.type = kLJPDFElementTypeImage;
    selection.ID = UUID;
    selection.image = image;
    [self.__selections setObject:selection forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionAdd
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)addSelection:(LJPDFElement *)selection forSelectionID:(NSString *)UUID;
{
    if (!self.__selections) self.__selections = [NSMutableDictionary dictionary];
    [self.__selections setObject:selection forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFSelectionAdd
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)updateSelectionSrcRect:(CGRect)srcRect forSelectionID:(NSString *)UUID;
{
    LJPDFElement* selection = [self.__selections objectForKey:UUID];
    selection.srcRect = srcRect;
    [N_CENTER postNotificationName:kNotificationPDFSelectionSrcUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)updateSelectionDstRect:(CGRect)dstRect forSelectionID:(NSString *)UUID;
{
    LJPDFElement* selection = [self.__selections objectForKey:UUID];
    selection.dstRect = dstRect;
    [N_CENTER postNotificationName:kNotificationPDFSelectionDstUpdate
                            object:self
                          userInfo:@{kNotificationPDFSelectionObjectKey: selection}];
}

- (void)removeSelectionForSelectionID:(NSString *)UUID;
{
    LJPDFElement* selection = [self.__selections objectForKey:UUID];
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
