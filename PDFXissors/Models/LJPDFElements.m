//
//  LJPDFElements.m
//
//  Created by Matthew Smith on 4/28/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJPDFElement.h"
#import "LJPDFElements.h"

@interface LJPDFElements ()

@property (nonatomic, strong) NSMutableDictionary* __elements;
@property (nonatomic, strong) LJPDFElement* temporaryElement;

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

- (void)setTemporaryElementWithSrcRect:(CGRect)srcRect forElementID:(NSString *)UUID;
{
    LJPDFElement* element = [LJPDFElement new];
    element.type = kLJPDFElementTypePDF;
    element.ID = UUID;
    element.srcRect = srcRect;
    self.temporaryElement = element;
    [N_CENTER postNotificationName:kNotificationPDFElementTempUpdate
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)setTemporaryElementWithString:(NSAttributedString *)string forElementID:(NSString *)UUID;
{
    LJPDFElement* element = [LJPDFElement new];
    element.type = kLJPDFElementTypeString;
    element.ID = UUID;
    element.string = string;
    self.temporaryElement = element;
    [N_CENTER postNotificationName:kNotificationPDFElementTempUpdate
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)promoteTemporaryElement;
{
    [self addElement:self.temporaryElement forElementID:self.temporaryElement.ID];
}

- (void)addElementWithString:(NSAttributedString *)string forElementID:(NSString *)UUID;
{
    if (!self.__elements) self.__elements = [NSMutableDictionary dictionary];
    LJPDFElement* element = [LJPDFElement new];
    element.type = kLJPDFElementTypeString;
    element.ID = UUID;
    element.string = string;
    [self.__elements setObject:element forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFElementAdd
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)addElementWithImage:(NSImage *)image forElementID:(NSString *)UUID;
{
    if (!self.__elements) self.__elements = [NSMutableDictionary dictionary];
    LJPDFElement* element = [LJPDFElement new];
    element.type = kLJPDFElementTypeImage;
    element.ID = UUID;
    element.image = image;
    [self.__elements setObject:element forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFElementAdd
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)addElement:(LJPDFElement *)element forElementID:(NSString *)UUID;
{
    if (!self.__elements) self.__elements = [NSMutableDictionary dictionary];
    [self.__elements setObject:element forKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFElementAdd
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)updateElementSrcRect:(CGRect)srcRect forElementID:(NSString *)UUID;
{
    LJPDFElement* element = [self.__elements objectForKey:UUID];
    element.srcRect = srcRect;
    [N_CENTER postNotificationName:kNotificationPDFElementSrcUpdate
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)updateElementDstRect:(CGRect)dstRect forElementID:(NSString *)UUID;
{
    LJPDFElement* element = [self.__elements objectForKey:UUID];
    element.dstRect = dstRect;
    [N_CENTER postNotificationName:kNotificationPDFElementDstUpdate
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (void)removeElementForElementID:(NSString *)UUID;
{
    LJPDFElement* element = [self.__elements objectForKey:UUID];
    [self.__elements removeObjectForKey:UUID];
    [N_CENTER postNotificationName:kNotificationPDFElementRemove
                            object:self
                          userInfo:@{kNotificationPDFElementObjectKey: element}];
}

- (NSDictionary *)elements;
{
    return [self.__elements copy];
}

- (BOOL)canPaste;
{
    return self.temporaryElement != nil;
}

@end
