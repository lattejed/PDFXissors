//
//  Notifications.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/14/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#ifndef PDFXissors_Notifications_h
#define PDFXissors_Notifications_h

static NSString* const kNotificationPDFElementTempUpdate                = @"kNotificationPDFElementTempUpdate";
static NSString* const kNotificationPDFElementAdd                       = @"kNotificationPDFElementAdd";
static NSString* const kNotificationPDFElementSrcUpdate                 = @"kNotificationPDFElementSrcUpdate";
static NSString* const kNotificationPDFElementDstUpdate                 = @"kNotificationPDFElementDstUpdate";
static NSString* const kNotificationPDFElementRemove                    = @"kNotificationPDFElementRemove";
static NSString* const kNotificationPDFElementObjectKey                 = @"kNotificationPDFElementObjectKey";

static NSString* const kNotificationSourcePDFDidUpdate                  = @"kNotificationSourcePDFDidUpdate";
static NSString* const kNotificationSourcePDFPageDidUpdate              = @"kNotificationSourcePDFPageDidUpdate";
static NSString* const kNotificationSourcePDFZoomDidUpdate              = @"kNotificationSourcePDFZoomDidUpdate";
static NSString* const kNotificationSourcePDFSelectionTypeUpdate        = @"kNotificationSourcePDFSelectionTypeUpdate";
static NSString* const kNotificationSourcePDFSelectionRectUpdate        = @"kNotificationSourcePDFSelectionRectUpdate";
static NSString* const kNotificationSourcePDFSelectionStringUpdate      = @"kNotificationSourcePDFSelectionStringUpdate";
static NSString* const kNotificationSourcePDFCopyStateUpdate            = @"kNotificationSourcePDFCopyStateUpdate";

//static NSString* const kNotificationDestinationPDFDidUpdate             = @"kNotificationDestinationPDFDidUpdate";
static NSString* const kNotificationDestinationPDFPageDidUpdate         = @"kNotificationDestinationPDFPageDidUpdate";
static NSString* const kNotificationDestinationPDFZoomDidUpdate         = @"kNotificationDestinationPDFZoomDidUpdate";

//static NSString* const kNotificationHideNonDrawingElements              = @"kNotificationHideNonDrawingElements";
//static NSString* const kNotificationShowNonDrawingElements              = @"kNotificationShowNonDrawingElements";

#endif
