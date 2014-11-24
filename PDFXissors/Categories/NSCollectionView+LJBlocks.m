//
//  NSCollectionView+LJBlocks.m
//
//  Created by Matthew Smith on 11/24/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "NSCollectionView+LJBlocks.h"
#import <objc/runtime.h>

static void* const kNSCollectionView_LJBlocks_HelperKey = (void *)&kNSCollectionView_LJBlocks_HelperKey;

@interface __NSCollectionViewHelper : NSObject <NSCollectionViewDelegate>

@property (nonatomic, weak) NSCollectionView* owner;
//@property (nonatomic, copy) void (^block)(void);

@end


@implementation NSCollectionView (LJBlocks)

- (__NSCollectionViewHelper *)lj_NSPopupButton_blocks_helper;
{
    __NSCollectionViewHelper* helper = objc_getAssociatedObject(self, kNSCollectionView_LJBlocks_HelperKey);
    if (!helper)
    {
        helper = [__NSCollectionViewHelper new];
        helper.owner = self;
        objc_setAssociatedObject(self, kNSCollectionView_LJBlocks_HelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return helper;
}

@end

@implementation __NSCollectionViewHelper

@end
