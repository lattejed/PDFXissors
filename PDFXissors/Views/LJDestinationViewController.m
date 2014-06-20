//
//  LJDestinationViewController.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJDestinationViewController.h"
#import <Quartz/Quartz.h>
#import "LJBorderedView.h"
#import "LJDestinationView.h"
#import "LJDestinationPDF.h"
#import "LJSourcePDFs.h"
#import "LJDragResizeView.h"
#import "LJDestinationSelectionView.h"
#import "LJPDFSelection.h"
#import "LJPDFClipView.h"
#import "LJPDFSelections.h"
#import "LJContentViewWithCloseButton.h"

@interface LJDestinationViewController ()

@property (nonatomic, weak) IBOutlet LJBorderedView* menuView;
@property (nonatomic, weak) IBOutlet NSPopUpButton* selectSizePopup;
@property (nonatomic, weak) IBOutlet NSPopUpButton* addItemPopup;
@property (nonatomic, weak) IBOutlet NSButton* portraitButton;
@property (nonatomic, weak) IBOutlet NSButton* landscapeButton;
@property (nonatomic, weak) IBOutlet NSButton* processButton;
@property (nonatomic, weak) IBOutlet LJDestinationView* destinationView;
@property (nonatomic, strong) LJDestinationPDF* destinationPDF;
@property (nonatomic, strong) LJSourcePDFs* sourcePDFs;
@property (nonatomic, strong) NSMutableDictionary* selectionViews;
@property (nonatomic, strong) LJPDFSelections* pdfSelections;

@end

@implementation LJDestinationViewController

- (void)awakeFromNib;
{
    [super awakeFromNib];
    self.menuView.borderOptions = kLJBorderedViewBorderOptionsBottom;
    
    NSArray* targetSizes = CONFIG_TARGET_SIZES;
    [self.selectSizePopup setItemTitles:[@[
                                           NSLocalizedString(@"Select Target Size", nil),
                                           ] arrayByAddingObjectsFromArray:targetSizes]
                                 format:^NSString *(id item) {
                                     CGSize size = [(NSValue *)item sizeValue];
                                     return [NSString stringWithFormat:@"%.2f x %.2f", size.width, size.height];
                                 }
                                options:kLJPopUpButtonOptionsIgnoreFirstItem
                                  block:^(NSInteger item, NSString *title) {
                                      CGSize size = [(NSValue *)targetSizes[item-1] sizeValue];
                                      self.destinationPDF.sizeInInches = size;
                                  }];

    [self.portraitButton setActionBlock:^{
        self.destinationPDF.givesPointSizeFlipped = NO;
    }];
    
    [self.landscapeButton setActionBlock:^{
        self.destinationPDF.givesPointSizeFlipped = YES;
    }];
    
    [self.addItemPopup setItemTitles:@[
                                       NSLocalizedString(@"Insert", nil),
                                       NSLocalizedString(@"Text", nil),
                                       NSLocalizedString(@"Image", nil),
                                       ]
                             options:kLJPopUpButtonOptionsIgnoreSelection
                               block:^(NSInteger item, NSString *title) {
                                   switch (item) {
                                       case 1:
                                       {
                                           LJDragResizeView* view = [LJDragResizeView dragResizeViewForPoint:CGPointZero];
                                           NSViewController *vc = [[NSViewController alloc] initWithNibName:@"LJContentViewWithCloseButton" bundle:nil];
                                           LJContentViewWithCloseButton* selectionView = (LJContentViewWithCloseButton *)vc.view;
                                           selectionView.borderColor = [NSColor darkGrayColor];
                                           [selectionView.deleteButton setActionBlock:^{
                                               [view removeFromSuperview];
                                           }];
                                           [view setContentView:vc.view hitRadius:10];
                                           NSTextField* txtField = [[NSTextField alloc] initWithFrame:CGRectZero];
                                           [txtField setEditable:YES];
                                           [txtField setAllowsEditingTextAttributes:YES];
                                           [txtField setBordered:NO];
                                           txtField.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
                                           [view.contentView addSubview:txtField positioned:NSWindowBelow relativeTo:nil];
                                           view.selectionChanged = ^(LJDragResizeView* view, CGRect rect) {
                                               // Clear first responder or this will crash
                                               [[txtField window] makeFirstResponder:nil];
                                               view.frame = rect;
                                               view.contentView.frame = view.bounds;
                                               txtField.frame = CGRectInset(view.contentView.bounds, 40, 40);
                                           };
                                           view.selectionChanged(view, (CGRect){0, 0, 300, 300});
                                           [self.destinationView addSubview:view];
                                           break;
                                       }
                                       case 2:
                                       {
                                           NSOpenPanel *panel = [NSOpenPanel openPanel];
                                           [panel setCanChooseFiles:YES];
                                           [panel setCanChooseDirectories:NO];
                                           [panel setAllowsMultipleSelection:NO];
                                           [panel setTitle:NSLocalizedString(@"Select Image", nil)];
                                           [panel setAllowedFileTypes:@[(__bridge NSString *)kUTTypeImage]];
                                           [panel beginSheetModalForWindow:[[self view] window]
                                                         completionHandler:^(NSInteger result) {
                                                             if (result == NSFileHandlingPanelOKButton)
                                                             {
                                                                 NSURL* url = [[panel URLs] firstObject];
                                                                 LJDragResizeView* view = [LJDragResizeView dragResizeViewForPoint:CGPointZero];
                                                                 NSViewController *vc = [[NSViewController alloc] initWithNibName:@"LJContentViewWithCloseButton" bundle:nil];
                                                                 LJContentViewWithCloseButton* selectionView = (LJContentViewWithCloseButton *)vc.view;                                                                 selectionView.borderColor = [NSColor darkGrayColor];
                                                                 [selectionView.deleteButton setActionBlock:^{
                                                                     [view removeFromSuperview];
                                                                 }];
                                                                 [view setContentView:vc.view hitRadius:10];
                                                                 NSImageView* imgView = [[NSImageView alloc] initWithFrame:CGRectZero];
                                                                 [imgView setImageFrameStyle:NSImageFrameNone];
                                                                 [view.contentView addSubview:imgView positioned:NSWindowBelow relativeTo:nil];
                                                                 NSImage* img = [[NSImage alloc] initWithContentsOfURL:url];
                                                                 imgView.image = img;
                                                                 imgView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
                                                                 view.selectionChanged = ^(LJDragResizeView* view, CGRect rect) {
                                                                     view.frame = rect;
                                                                     view.contentView.frame = view.bounds;
                                                                     imgView.frame = CGRectInset(view.contentView.bounds, 40, 40);
                                                                 };
                                                                 view.selectionChanged(view, (CGRect){0, 0, 300, 300});
                                                                 [self.destinationView addSubview:view];
                                                             }
                                                         }];
                                           break;
                                       }
                                       default:
                                           break;
                                   }
                               }];
    
    [self.processButton setActionBlock:^{
        [[[self view] window] makeFirstResponder:nil];
        [N_CENTER postNotificationName:kNotificationHideNonDrawingElements
                                object:self];
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseFiles:NO];
        [panel setCanChooseDirectories:YES];
        [panel setAllowsMultipleSelection:NO];
        [panel setTitle:NSLocalizedString(@"Select Destination Directory", nil)];
        [panel setAllowedFileTypes:@[(__bridge NSString *)kUTTypePDF]];
        [panel beginSheetModalForWindow:[[self view] window]
                      completionHandler:^(NSInteger result) {
                          if (result == NSFileHandlingPanelOKButton)
                          {
                              NSURL* dstUrl = [[panel URLs] firstObject];
                              for (NSURL* srcUrl in [self.sourcePDFs URLs])
                              {
                                  PDFDocument* srcDoc = [[PDFDocument alloc] initWithURL:srcUrl];
                                  PDFDocument* dstDoc = [[PDFDocument alloc] init];

                                  for (NSUInteger pageIdx=0; pageIdx<[srcDoc pageCount]; ++pageIdx)
                                  {
                                      for (LJPDFClipView* pdfView in [self.selectionViews allValues])
                                      {
                                          [pdfView setSourcePDFURL:srcUrl page:pageIdx + 1];
                                          [pdfView setNeedsDisplay:YES];
                                      }
                                      NSData* data = [self.destinationView dataWithPDFInsideRect:self.destinationView.bounds];
                                      NSImage* img = [[NSImage alloc] initWithData:data];
                                      PDFPage* page = [[PDFPage alloc] initWithImage:img];
                                      [dstDoc insertPage:page atIndex:pageIdx];
                                  }
                                  NSData* data = [dstDoc dataRepresentation];
                                  [data writeToURL:[dstUrl URLByAppendingPathComponent:[srcUrl lastPathComponent]] atomically:YES];
                               }
                          }
                          [N_CENTER postNotificationName:kNotificationShowNonDrawingElements
                                                  object:self];
                      }];
    }];
    
    [N_CENTER addObserverForName:kNotificationDestinationPDFDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          NSViewSetSize(self.destinationView, [self.destinationPDF sizeInPoints]);
                          NSViewCenterInParent(self.destinationView);
                          
                          // TODO: Dirty hack to maintain highlight state, remove when buttons get replaced with something custom
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.portraitButton highlight:!self.destinationPDF.givesPointSizeFlipped];
                              [self.landscapeButton highlight:self.destinationPDF.givesPointSizeFlipped];
                          });
                      }];
    
    [self.destinationView.superview setPostsFrameChangedNotifications:YES];
    [N_CENTER addObserverForName:NSViewFrameDidChangeNotification
                          object:self.destinationView.superview
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          NSViewCenterInParent(self.destinationView);
                      }];

    [N_CENTER addObserverForName:kNotificationPDFSelectionSrcUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          LJPDFSelection* sel = [[note userInfo] objectForKey:kNotificationPDFSelectionObjectKey];
                          LJPDFClipView* pdfView = [self.selectionViews objectForKey:sel.ID];
                          pdfView.srcRect = sel.srcRect;
                          [pdfView setNeedsDisplay:YES];
                          CGRect dstRect = sel.dstRect;
                          dstRect.size = sel.srcRect.size;
                          [self.pdfSelections updateSelectionDstRect:dstRect forSelectionID:sel.ID];
                      }];
    
    [N_CENTER addObserverForName:kNotificationPDFSelectionDstUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          if (!self.selectionViews) self.selectionViews = [NSMutableDictionary dictionary];
                          LJPDFSelection* sel = [[note userInfo] objectForKey:kNotificationPDFSelectionObjectKey];
                          LJPDFClipView* pdfView = [self.selectionViews objectForKey:sel.ID];
                          LJDragResizeView* view = pdfView.parentDragView;
                          if (!view)
                          {
                              view = [LJDragResizeView dragResizeViewForPoint:CGPointZero];
                              view.selectionID = sel.ID;

                              LJDestinationSelectionView* selectionView = [[LJDestinationSelectionView alloc] initWithFrame:CGRectZero];
                              selectionView.borderColor = sel.color;
                              
                              pdfView = [[LJPDFClipView alloc] initWithFrame:selectionView.bounds];
                              [pdfView setSourcePDFURL:[[self.sourcePDFs URLs] firstObject] page:1];
                              pdfView.parentDragView = view;
                              pdfView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
                              [selectionView addSubview:pdfView];

                              [view setContentView:selectionView hitRadius:10];

                              view.selectionChanged = ^(LJDragResizeView* view, CGRect rect) {
                                  view.frame = rect;
                                  [self.pdfSelections updateSelectionDstRect:rect forSelectionID:sel.ID];
                              };
                              
                              [self.destinationView addSubview:view];
                              [self.selectionViews setObject:pdfView forKey:sel.ID];
                          }
                          view.frame = sel.dstRect;
                          view.contentView.frame = view.bounds;
                          pdfView.frame = CGRectInset(view.contentView.bounds, 2, 2);
                      }];
    
    [N_CENTER addObserverForName:kNotificationPDFSelectionRemove
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          LJPDFSelection* sel = [[note userInfo] objectForKey:kNotificationPDFSelectionObjectKey];
                          LJPDFClipView* pdfView = [self.selectionViews objectForKey:sel.ID];
                          LJDragResizeView* view = pdfView.parentDragView;
                          [view removeFromSuperview];
                          [self.selectionViews removeObjectForKey:sel.ID];
                      }];
    
    self.pdfSelections = [LJPDFSelections sharedInstance];
    self.sourcePDFs = [LJSourcePDFs sharedInstance];
    self.destinationPDF = [LJDestinationPDF sharedInstance]; // TODO: Probably don't need a singleton here
    self.destinationPDF.sizeInInches = (CGSize){8.5, 11}; // TODO:
    self.destinationPDF.givesPointSizeFlipped = NO;
}

@end
