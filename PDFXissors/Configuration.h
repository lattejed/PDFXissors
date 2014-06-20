//
//  Configuration.h
//  PDFXissors
//
//  Created by Matthew Smith on 5/21/14.
//  Copyright (c) 2014 RamenShoppe. All rights reserved.
//

#ifndef PDFXissors_Configuration_h
#define PDFXissors_Configuration_h

#define DEV_LOAD_TEST_PDF   1

#define CGSIZE2(__w__, __h__)   (CGSize){__w__, __h__}
#define CGSIZE_VAL(__size__)    [NSValue valueWithSize:__size__]

#define CONFIG_TARGET_SIZES @[      \
    CGSIZE_VAL(CGSIZE2(8.5, 11)),   \
    CGSIZE_VAL(CGSIZE2(5.5, 8.5)),  \
    CGSIZE_VAL(CGSIZE2(4.25, 5.5)), \
    CGSIZE_VAL(CGSIZE2(2.75, 5.5)), \
]

#define M_BNDL              [NSBundle mainBundle]
#define N_CENTER            [NSNotificationCenter defaultCenter]

#endif
