//
//  RSPDFView.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

@interface RSPDFView : PDFView

@property (nonatomic, copy) BOOL (^allowSelection)(void);
@property (nonatomic, copy) BOOL (^allowNativeSelection)(void);
@property (nonatomic, copy) void (^selectionRectDidUpdate)(CGRect);
@property (nonatomic, copy) CGRect (^selectionRect)(void);

@end
