//
//  NSButton+LJBlocks.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "NSButton+LJBlocks.h"
#import <objc/runtime.h>

static void* const kNSButton_LJBlocks_HelperKey = (void *)&kNSButton_LJBlocks_HelperKey;

@interface __NSButtonHelper : NSObject

@property (nonatomic, weak) NSButton* owner;
@property (nonatomic, copy) void (^block)(void);

- (void)action:(id)sender;

@end

@implementation NSButton (LJBlocks)

- (void)setActionBlock:(void (^)(void))block;
{
    __NSButtonHelper* helper = [self lj_NSPopupButton_blocks_helper];
    helper.block = block;
    
    [self setAction:@selector(action:)];
    [self setTarget:helper];
}

- (__NSButtonHelper *)lj_NSPopupButton_blocks_helper;
{
    __NSButtonHelper* helper = objc_getAssociatedObject(self, kNSButton_LJBlocks_HelperKey);
    if (!helper)
    {
        helper = [__NSButtonHelper new];
        helper.owner = self;
        objc_setAssociatedObject(self, kNSButton_LJBlocks_HelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

@end

@implementation __NSButtonHelper

- (void)action:(id)sender;
{
    if (self.owner)
    {
        self.block();
    }
}

@end
