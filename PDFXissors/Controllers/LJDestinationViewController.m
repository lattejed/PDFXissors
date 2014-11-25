//
//  LJDestinationViewController.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJDestinationViewController.h"
#import <Quartz/Quartz.h>
#import "RSPDFView.h"
#import "RSAddPagePanelController.h"
#import "LJPDFClipView.h"
#import "LJResizableDraggableView.h"
#import "RSTextView.h"
#import "RSImageView.h"

#import "RSDestinationPDF.h"
#import "RSDestinationPDFPage.h"
#import "RSPDFElement.h"
#import "RSDestinationPDFController.h"

@interface LJDestinationViewController ()

@property (nonatomic, weak) IBOutlet NSButton* addPageButton;
@property (nonatomic, weak) IBOutlet NSButton* removePageButton;
@property (nonatomic, weak) IBOutlet NSPanel* addPagePanel;
@property (nonatomic, weak) IBOutlet NSButton* pageBackButton;
@property (nonatomic, weak) IBOutlet NSButton* pageFwdButton;
@property (nonatomic, weak) IBOutlet NSTextField* pageTextField;
@property (nonatomic, weak) IBOutlet NSButton* zoomInButton;
@property (nonatomic, weak) IBOutlet NSButton* zoomOutButton;
@property (nonatomic, weak) IBOutlet NSButton* addTextButton;
@property (nonatomic, weak) IBOutlet NSButton* addImageButton;
@property (nonatomic, weak) IBOutlet NSButton* doPasteButton;
@property (nonatomic, weak) IBOutlet RSDestinationPDFController* destinationPDFController;

@property (nonatomic, strong) RSDestinationPDF* destinationPDF;
@property (nonatomic, strong) NSMutableArray* pages;

@end

@implementation LJDestinationViewController

- (void)awakeFromNib;
{
    [super awakeFromNib];
    
    
    self.pages = [NSMutableArray array];
    //self.collectionView.content = self.pages;
    
    self.doPasteButton.enabled = false;
    self.addImageButton.enabled = false;
    self.addTextButton.enabled = false;
    
    [self.addPageButton setActionBlock:^{
        [NSApp beginSheet:self.addPagePanel
           modalForWindow:self.view.window
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];
    }];
    
    RSAddPagePanelController* panelController = [self.addPagePanel windowController];
    panelController.addPageForSize = ^(CGSize size) {
        [self.destinationPDF appendPageWithSize:size];
    };
    
    [self.removePageButton setActionBlock:^{
       //[self.destinationPDF removeCurrentPage];
    }];
    
    
    [N_CENTER addObserverForName:kNotificationDestinationPDFPagesDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          if (self.pages == nil) {
                              self.pages = [NSMutableArray array];
                              //self.collectionView.content = self.pages;
                          }
                          
                      }];
    
    [N_CENTER addObserverForName:@""//kNotificationDestinationPDFPageDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          //if (!self.pdfView.document) self.pdfView.document = self.destinationPDF.document;
                          //[self.pdfView goToPage:[self.pdfView.document pageAtIndex:self.destinationPDF.currentPage]];
                          
                          //self.pageBackButton.enabled = self.pdfView.canGoBack;
                          //self.pageFwdButton.enabled = self.pdfView.canGoForward;
                          //self.pageTextField.stringValue = [NSString stringWithFormat:@"%lu of %lu",
                          //                                  (unsigned long)self.destinationPDF.currentPage + 1,
                          //                                  (unsigned long)self.pdfView.document.pageCount];
                          
                          // TODO: Should these be here?
                          //BOOL canPaste = [self.destinationPDF canPaste];
                          //self.doPasteButton.enabled = canPaste && [self.pdfElements canPaste];
                          //self.addImageButton.enabled = canPaste;
                          //self.addTextButton.enabled = canPaste;
                      }];
    
    [self.pageBackButton setActionBlock:^{
        //if (self.pdfView.canGoBack) self.destinationPDF.currentPage = self.destinationPDF.currentPage - 1;
    }];
    
    [self.pageFwdButton setActionBlock:^{
        //if (self.pdfView.canGoForward) self.destinationPDF.currentPage = self.destinationPDF.currentPage + 1;
    }];
    
    [N_CENTER addObserverForName:@""//kNotificationDestinationPDFZoomDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          //self.pdfView.scaleFactor = self.destinationPDF.currentScale;
                          //self.zoomOutButton.enabled = self.pdfView.canZoomOut;
                          //self.zoomInButton.enabled = self.pdfView.canZoomIn;
                      }];
    
    [self.zoomOutButton setActionBlock:^{
        //if (self.pdfView.canZoomOut) self.destinationPDF.currentScale = self.destinationPDF.currentScale * 0.707;
    }];
    
    [self.zoomInButton setActionBlock:^{
        //if (self.pdfView.canZoomIn) self.destinationPDF.currentScale = self.destinationPDF.currentScale * 1.414;
    }];
    
    [N_CENTER addObserverForName:@""//kNotificationPDFElementTempUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          //self.doPasteButton.enabled = [self.destinationPDF canPaste] && [self.pdfElements canPaste];
                      }];

    [self.doPasteButton setActionBlock:^{
        //[self.pdfElements promoteTemporaryElement];
    }];
    
    [self.addTextButton setActionBlock:^{
        
        //NSString* uuid = [NSString UUID];
        //[self.pdfElements add]
    }];
    
    [self.addImageButton setActionBlock:^{
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setCanChooseFiles:YES];
        [panel setCanChooseDirectories:NO];
        [panel setAllowsMultipleSelection:NO];
        [panel setTitle:NSLocalizedString(@"Select Image", nil)];
        [panel setAllowedFileTypes:@[(__bridge NSString *)kUTTypeImage]];
        [panel beginSheetModalForWindow:[[self view] window]
                      completionHandler:^(NSInteger result) {
                          if (result == NSFileHandlingPanelOKButton) {
                              NSURL* url = [[panel URLs] firstObject];
                              NSImage* image = [[NSImage alloc] initWithContentsOfURL:url];
                              if (image != nil) {
                                  //NSString* uuid = [NSString UUID];
                                  //[self.pdfElements addElementWithImage:image forElementID:uuid];
                              }
                          }
                      }];
    }];
    
    // TODO: We need to be able to remove these by page
    
    [N_CENTER addObserverForName:@""//kNotificationPDFElementAdd
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          //LJPDFElement* selection = [[note userInfo] objectForKey:kNotificationPDFElementObjectKey];
                          //LJResizableDraggableView* controlView = nil;
                          //if (selection.type == kLJPDFElementTypeString) {
                              
                              // TODO: We don't know how this will draw to the final page
                              //controlView = [[LJResizableDraggableView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)]; // TODO:
                              //RSTextView* textView = [[RSTextView alloc] initWithFrame:controlView.contentViewFrame];
                              //[[textView textStorage] setAttributedString:selection.string];
                              //[controlView setContentView:textView];
                              //[self.pdfView addSubview:controlView];
                          //} else if (selection.type == kLJPDFElementTypePDF) {
                              
                              //CGRect frame = [LJResizableDraggableView initialFrameForParentView:self.pdfView size:selection.srcRect.size preserveAspect:YES];
                              //controlView = [[LJResizableDraggableView alloc] initWithFrame:frame];

                              // TODO: We need to handle source pdf, source page for LJPDFClipView
                              
                              //[self.pdfView addSubview:controlView];

                          //} else if (selection.type == kLJPDFElementTypeImage) {
                              
                              //CGRect frame = [LJResizableDraggableView initialFrameForParentView:self.pdfView size:selection.image.size preserveAspect:YES];
                              //controlView = [[LJResizableDraggableView alloc] initWithFrame:frame];
                              //RSImageView* imageView = [[RSImageView alloc] initWithFrame:controlView.contentViewFrame];
                              //imageView.image = selection.image;
                              //[controlView setContentView:imageView];
                              //[self.pdfView addSubview:controlView];
                          //}
                          //if (controlView != nil) {
                          //    controlView.viewDidClose = ^(NSView* view){
                          //        [view removeFromSuperview];
                          //        [self.pdfElements removeElementForElementID:selection.ID];
                          //    };
                          //    controlView.contentViewFrameUpdate = ^(NSView* view, CGRect rect){
                          //        [self.pdfElements updateElementSrcRect:rect forElementID:selection.ID];
                          //    };
                          //}
                      }];
    
    //self.pdfView.allowSelection = ^BOOL { return NO; };
    //self.pdfElements = [LJPDFElements sharedInstance];
    
    self.destinationPDF = [RSDestinationPDF new];
    
    //self.menuView.borderOptions = kLJBorderedViewBorderOptionsBottom;
}

@end
