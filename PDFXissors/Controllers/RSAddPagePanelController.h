//
//  RSAddPagePanelController.h
//  PDFXissors
//
//  Created by Matthew Smith on 6/20/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSAddPagePanelController : NSWindowController

@property (nonatomic, copy) void (^addPageForSize)(CGSize);

@end
