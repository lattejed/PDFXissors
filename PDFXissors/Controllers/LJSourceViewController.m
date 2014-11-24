//
//  LJSourceViewController.m
//  PDFManipulation
//
//  Created by Matthew Smith on 4/21/14.
//  Copyright (c) 2014 LatteJed. All rights reserved.
//

#import "LJSourceViewController.h"
//#import "LJBorderedView.h"
//#import "LJSourcePDFView.h"
#import "RSSourcePDF.h"
#import "RSPDFView.h"
//#import "LJDestinationPDF.h"
//#import "LJDragResizeView.h"
//#import "LJContentViewWithCloseButton.h"
#import "LJPDFElements.h"
//#import "LJPDFSelection.h"

@interface LJSourceViewController ()

@property (nonatomic, weak) IBOutlet NSButton* openFileButton;
@property (nonatomic, weak) IBOutlet NSButton* pageBackButton;
@property (nonatomic, weak) IBOutlet NSButton* pageFwdButton;
@property (nonatomic, weak) IBOutlet NSTextField* pageTextField;
@property (nonatomic, weak) IBOutlet NSButton* zoomInButton;
@property (nonatomic, weak) IBOutlet NSButton* zoomOutButton;
@property (nonatomic, weak) IBOutlet NSButton* rectSelectButton;
@property (nonatomic, weak) IBOutlet NSButton* textSelectButton;
@property (nonatomic, weak) IBOutlet NSButton* doCopyButton;
@property (nonatomic, weak) IBOutlet RSPDFView* pdfView;

//@property (nonatomic, weak) IBOutlet LJBorderedView* menuView;
@property (nonatomic, strong) RSSourcePDF* sourcePDF;
@property (nonatomic, strong) LJPDFElements* pdfElements;
//@property (nonatomic, strong) NSMutableDictionary* selectionViews;

@end

@implementation LJSourceViewController

- (void)awakeFromNib;
{
    [super awakeFromNib];
    //self.menuView.borderOptions = kLJBorderedViewBorderOptionsBottom;
    
    [self.openFileButton setActionBlock:^{
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseFiles:YES];
        [panel setCanChooseDirectories:YES];
        [panel setAllowsMultipleSelection:YES];
        [panel setTitle:NSLocalizedString(@"Select Source PDF", nil)];
        [panel setAllowedFileTypes:@[(__bridge NSString *)kUTTypePDF]];
        [panel beginSheetModalForWindow:[[self view] window]
                      completionHandler:^(NSInteger result) {
                          if (result == NSFileHandlingPanelOKButton)
                          {
                              self.sourcePDF = [RSSourcePDF new];
                              self.sourcePDF.url = [[panel URLs] firstObject];
                          }
                      }];
    }];
    
    [N_CENTER addObserverForName:kNotificationSourcePDFDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          if ([self.sourcePDF url])
                          {
                              self.pdfView.document = [[PDFDocument alloc] initWithURL:self.sourcePDF.url];
                              self.sourcePDF.currentPage = 0; // TODO: Wrap these into an init?
                              self.sourcePDF.currentScale = self.pdfView.scaleFactor;
                              self.sourcePDF.currentSelectionRect = CGRectZero;
                              self.sourcePDF.currentSelectionString = nil;
                          }
                      }];
    
    [N_CENTER addObserverForName:kNotificationSourcePDFPageDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          [self.pdfView goToPage:[self.pdfView.document pageAtIndex:self.sourcePDF.currentPage]];
                          self.pageBackButton.enabled = self.pdfView.canGoBack;
                          self.pageFwdButton.enabled = self.pdfView.canGoForward;
                          self.pageTextField.stringValue = [NSString stringWithFormat:@"%lu of %lu",
                                                            (unsigned long)self.sourcePDF.currentPage + 1,
                                                            (unsigned long)self.pdfView.document.pageCount];
                      }];
    
    [self.pageBackButton setActionBlock:^{
        if (self.pdfView.canGoBack) self.sourcePDF.currentPage = self.sourcePDF.currentPage - 1;
    }];
    
    [self.pageFwdButton setActionBlock:^{
        if (self.pdfView.canGoForward) self.sourcePDF.currentPage = self.sourcePDF.currentPage + 1;
    }];
    
    [N_CENTER addObserverForName:kNotificationSourcePDFZoomDidUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          self.pdfView.scaleFactor = self.sourcePDF.currentScale;
                          self.zoomOutButton.enabled = self.pdfView.canZoomOut;
                          self.zoomInButton.enabled = self.pdfView.canZoomIn;
                      }];
    
    [self.zoomOutButton setActionBlock:^{
        if (self.pdfView.canZoomOut) self.sourcePDF.currentScale = self.sourcePDF.currentScale * 0.707;
    }];
    
    [self.zoomInButton setActionBlock:^{
        if (self.pdfView.canZoomIn) self.sourcePDF.currentScale = self.sourcePDF.currentScale * 1.414;
    }];
    
    
    [self.rectSelectButton setActionBlock:^{
        self.rectSelectButton.state = NSOnState;
        self.textSelectButton.state = NSOffState;
        self.sourcePDF.selectionType = kRSSourcePDFSelectionTypeRectangle;
    }];
    
    [self.textSelectButton setActionBlock:^{
        self.textSelectButton.state = NSOnState;
        self.rectSelectButton.state = NSOffState;
        self.sourcePDF.selectionType = kRSSourcePDFSelectionTypeText;
    }];
    
    [N_CENTER addObserverForName:kNotificationSourcePDFSelectionTypeUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          [self.pdfView setNeedsDisplay:YES];
                      }];
    
    self.pdfView.allowSelection = ^BOOL { return YES; };
    
    self.pdfView.allowNativeSelection = ^BOOL{
        return (self.sourcePDF.selectionType == kRSSourcePDFSelectionTypeText);
    };
    
    self.pdfView.selectionRectDidUpdate = ^(CGRect rect) {
        self.sourcePDF.currentSelectionRect = rect;
    };
    
    [N_CENTER addObserverForName:kNotificationSourcePDFSelectionRectUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          [self.pdfView setNeedsDisplay:YES];
                          self.doCopyButton.enabled = [self.sourcePDF canCopy];
                      }];
    
    self.pdfView.selectionRect = ^CGRect{
        return self.sourcePDF.currentSelectionRect;
    };
    
    self.pdfView.selectionStringDidUpdate = ^(NSAttributedString* string) {
        self.sourcePDF.currentSelectionString = string;
    };
    
    [N_CENTER addObserverForName:kNotificationSourcePDFSelectionStringUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          self.doCopyButton.enabled = [self.sourcePDF canCopy];
                      }];
    
    [self.doCopyButton setActionBlock:^{
        if (self.sourcePDF.selectionType == kRSSourcePDFSelectionTypeRectangle)
        {
            NSString* uuid = [NSString UUID]; // TODO:
            CGRect srcRect = [self.pdfView convertRect:self.sourcePDF.currentSelectionRect toPage:self.pdfView.currentPage]; // TODO: selection?
            [self.pdfElements setTemporaryElementWithSrcRect:srcRect forElementID:uuid];
        }
        else if (self.sourcePDF.selectionType == kRSSourcePDFSelectionTypeText)
        {
            NSString* uuid = [NSString UUID]; // TODO:
            [self.pdfElements setTemporaryElementWithString:self.sourcePDF.currentSelectionString forElementID:uuid];
        }
    }];
    
    [N_CENTER addObserverForName:kNotificationSourcePDFCopyStateUpdate
                          object:nil
                           queue:nil
                      usingBlock:^(NSNotification *note) {
                          self.doCopyButton.enabled = self.sourcePDF.canCopy;
                      }];
        
    //self.sourcePDF = [RSSourcePDF new];
    self.pdfElements = [LJPDFElements sharedInstance];

#if DEV_LOAD_TEST_PDF
    self.sourcePDF = [RSSourcePDF new];
    self.sourcePDF.url = [M_BNDL URLForResource:@"pdf1" withExtension:@"pdf" subdirectory:@"Test"];
#endif
}

@end
