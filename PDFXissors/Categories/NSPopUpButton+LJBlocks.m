//
//  NSPopUpButton+LJBlocks.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "NSPopUpButton+LJBlocks.h"
#import <objc/runtime.h>

static void* const kNSPopUpButton_LJBlocks_HelperKey = (void *)&kNSPopUpButton_LJBlocks_HelperKey;

@interface __NSPopUpButtonHelper : NSObject

@property (nonatomic, weak) NSPopUpButton* owner;
@property (nonatomic, copy) void (^block)(NSInteger item, NSString* title);
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) kLJPopUpButtonOptions options;

- (void)action:(id)sender;

@end

@implementation NSPopUpButton (LJBlocks)

- (void)setItemTitles:(NSArray *)titles
              options:(kLJPopUpButtonOptions)options
                block:(void (^)(NSInteger item, NSString* title))block;
{
    [self setItemTitles:titles
                 format:nil
                options:options
                  block:block];
}

- (void)setItemTitles:(NSArray *)titles
               format:(NSString* (^)(id item))format
              options:(kLJPopUpButtonOptions)options
                block:(void (^)(NSInteger item, NSString* title))block;
{
    [self removeAllItems];
    
    if (format)
    {
        for (id title in titles)
        {
            if ([title isKindOfClass:[NSString class]] && !(options & kLJPopUpButtonOptionsIgnoreForceFormat))
            {
                [self addItemWithTitle:title];
            }
            else
            {
                [self addItemWithTitle:format(title)];
            }
        }
    }
    else
    {
        [self addItemsWithTitles:titles];
    }
    
    __NSPopUpButtonHelper* helper = [self lj_NSPopupButton_blocks_helper];
    helper.block = block;
    helper.options = options;
    
    [self setAction:@selector(action:)];
    [self setTarget:helper];
}

- (__NSPopUpButtonHelper *)lj_NSPopupButton_blocks_helper;
{
    __NSPopUpButtonHelper* helper = objc_getAssociatedObject(self, kNSPopUpButton_LJBlocks_HelperKey);
    if (!helper)
    {
        helper = [__NSPopUpButtonHelper new];
        helper.owner = self;
        helper.lastIndex = 0;
        objc_setAssociatedObject(self, kNSPopUpButton_LJBlocks_HelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

@end

@implementation __NSPopUpButtonHelper

- (void)action:(id)sender;
{
    if (self.owner)
    {
        NSInteger idx = [self.owner indexOfSelectedItem];
        NSString* title = [self.owner titleOfSelectedItem];
        BOOL call = YES;
        if (self.options & kLJPopUpButtonOptionsIgnoreSelection)
        {
            [self.owner selectItemAtIndex:0];
        }
        if (self.options & kLJPopUpButtonOptionsIgnoreFirstItem && idx == 0)
        {
            call = NO;
            [self.owner selectItemAtIndex:self.lastIndex];
        }
        [self.owner synchronizeTitleAndSelectedItem];
        if (call) self.block(idx, title);
        self.lastIndex = idx;
    }
}

@end
