//
//  CoreFunctions.h
//  Genoma
//
//  Created by Giovanni Amati on 19/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "MyMoveTo.h"

@interface CoreFunctions : NSObject
{

}

+(CGPoint) convertToISO:(CGPoint)pos;
+(NSMutableDictionary *) getTileInfo:(CGPoint)pos;
+(float) intersectionX:(float)x p1:(CGPoint)p1 p2:(CGPoint)p2;
+(float) intersectionY:(float)y p1:(CGPoint)p1 p2:(CGPoint)p2;
+(NSMutableArray *)actionsFrom:(NSMutableDictionary *)start to:(NSMutableDictionary *)dest;

@end