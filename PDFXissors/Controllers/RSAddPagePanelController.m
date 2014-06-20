//
//  RSAddPagePanelController.m
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSAddPagePanelController.h"

@interface RSAddPagePanelController ()

@property (weak) IBOutlet NSButton* addPageButton;
@property (weak) IBOutlet NSButton* cancelButton;
@property (weak) IBOutlet NSPopUpButton* selectSizePopup;
@property (weak) IBOutlet NSTextField* widthTextField;
@property (weak) IBOutlet NSTextField* spacerXTextField;
@property (weak) IBOutlet NSTextField* sizeInfoTextField;
@property (weak) IBOutlet NSTextField* heightTextField;

@property (assign) CGSize size;

@end

@implementation RSAddPagePanelController

- (void)awakeFromNib;
{
    void (^customInputHide)(BOOL) = ^void(BOOL hide) {
        self.widthTextField.hidden = hide;
        self.spacerXTextField.hidden = hide;
        self.heightTextField.hidden = hide;
        self.sizeInfoTextField.hidden = hide;
    };
    
    void (^close)(void) = ^void(void) {
        [NSApp endSheet:self.window];
        [self.window orderOut:self];
    };
    
    NSArray* targetSizes = CONFIG_TARGET_SIZES;
    [self.selectSizePopup setItemTitles:[targetSizes arrayByAddingObject:NSLocalizedString(@"Custom...", nil)]
                                 format:^NSString *(id item) {
                                     CGSize size = [(NSValue *)item sizeValue];
                                     return [NSString stringWithFormat:@"%.2f x %.2f", size.width, size.height];
                                 }
                                options:kLJPopUpButtonOptionsSelectFirstItem
                                  block:^(NSInteger item, NSString *title) {
                                      if (item == targetSizes.count)    customInputHide(NO);
                                      else                              customInputHide(YES);
                                  }];
    
    [self.addPageButton setActionBlock:^{
        CGSize size;
        NSInteger idx = self.selectSizePopup.indexOfSelectedItem;
        if (idx == targetSizes.count)
        {
            size = (CGSize){self.widthTextField.intValue, self.heightTextField.intValue};
        }
        else
        {
            size = [targetSizes[idx] sizeValue];
        }
        close();
    }];
    
    [self.cancelButton setActionBlock:^{
        close();
    }];
}

@end
