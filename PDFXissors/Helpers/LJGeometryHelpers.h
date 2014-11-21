//
//  LJGeometryHelpers.h
//
//  Created by Matthew Smith on 5/30/14.
//  Copyright (c) 2014 Latte, Jed? All rights reserved.
//

#ifndef LJGeometryHelpers_h
#define LJGeometryHelpers_h

static inline CGPoint
CGPointAdd(const CGPoint p1, const CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

static inline CGPoint
CGPointSub(const CGPoint p1, const CGPoint p2)
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

static inline CGPoint
CGSize2Point(const CGSize s)
{
    return CGPointMake(s.width, s.height);
}

static inline CGSize
CGPoint2Size(const CGPoint p)
{
    return CGSizeMake(p.x, p.y);
}

static inline CGRect
CGPoints2Rect(const CGPoint origin, const CGPoint origin2)
{
    return CGRectMake(origin.x, origin.y, origin.x + origin2.x, origin.y + origin2.y);
}

static inline CGRect
CGPoints2Frame(const CGPoint origin, const CGPoint origin2)
{
    return CGRectMake(MIN(origin.x, origin2.x),  MIN(origin.y, origin2.y),
                      MAX(origin.x, origin2.x) - MIN(origin.x, origin2.x),
                      MAX(origin.y, origin2.y) - MIN(origin.y, origin2.y));
}

static inline CGRect
CGRect2Frame(const CGRect r)
{
    return CGPoints2Frame(r.origin, CGPointSub(CGSize2Point(r.size), r.origin));
}

static inline CGSize
CGSizeAdd(const CGSize s1, const CGSize s2)
{
    return CGSizeMake(s1.width + s2.width, s1.height + s2.height);
}

static inline CGSize
CGSizeSub(const CGSize s1, const CGSize s2)
{
    return CGSizeMake(s1.width - s2.width, s1.height - s2.height);
}

#endif
