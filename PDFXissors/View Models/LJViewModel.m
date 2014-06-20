//
//  LJViewModel.m
//  PDFXissors
//
//  Created by Matthew Smith on 5/27/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#import "LJViewModel.h"

@implementation LJViewModel

- (id)init
{
	if (self = [super init])
    {
        _errors = [[RACSubject subject] setNameWithFormat:@"%@ -errors", self];
    }
	return self;
}

- (void)dealloc
{
	[_errors sendCompleted];
}

@end
