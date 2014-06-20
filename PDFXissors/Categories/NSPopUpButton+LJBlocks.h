//
//  NSPopUpButton+LJBlocks.h
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_OPTIONS(NSInteger, kLJPopUpButtonOptions)
{
    kLJPopUpButtonOptionsNone               = 0,
    kLJPopUpButtonOptionsSelectFirstItem    = 1 << 1,
    kLJPopUpButtonOptionsIgnoreSelection    = 1 << 2,
    kLJPopUpButtonOptionsIgnoreFirstItem    = 1 << 3,
    kLJPopUpButtonOptionsIgnoreForceFormat  = 1 << 4,
};

@interface NSPopUpButton (LJBlocks)

- (void)setItemTitles:(NSArray *)titles
              options:(kLJPopUpButtonOptions)options
                block:(void (^)(NSInteger item, NSString* title))block;

- (void)setItemTitles:(NSArray *)titles
               format:(NSString* (^)(id item))format
              options:(kLJPopUpButtonOptions)options
                block:(void (^)(NSInteger item, NSString* title))block;

@end
