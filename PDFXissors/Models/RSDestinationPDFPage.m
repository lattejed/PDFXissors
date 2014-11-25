//
//  RSDestinationPDFPage.m
//  PDFXissors
//
//  Created by Matthew Smith on 11/25/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "RSDestinationPDFPage.h"
#import "RSPDFElement.h"

@interface RSDestinationPDFPage ()

@property (nonatomic, strong) NSMutableDictionary* elements;

@end

@implementation RSDestinationPDFPage

+ (instancetype)pageWithSize:(CGSize)size;
{
    RSDestinationPDFPage* page = [RSDestinationPDFPage new];
    page->_size = size;
    return page;
}

- (void)addElement:(RSPDFElement *)element;
{
    [self.elements setObject:element forKey:element.ID];
}

- (void)removeElement:(RSPDFElement *)element;
{
    [self.elements removeObjectForKey:element.ID];
}

- (NSMutableDictionary *)elements;
{
    if (_elements == nil) _elements = [NSMutableDictionary dictionary];
    return _elements;
}

@end
