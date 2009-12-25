//
//  InterfaceLayer.h
//  Genoma
//
//  Created by Giovanni Amati on 24/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface InterfaceLayer : CCLayer
{
	int sel;
	int num;
}

@property (readwrite) int sel;
@property (readwrite) int num;

-(void) initMenu:(NSArray *)labels;
-(void) configMenu:(int)i move:(int)m;

@end