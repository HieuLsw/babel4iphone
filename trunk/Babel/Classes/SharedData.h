//
//  SharedData.h
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

@interface SharedData : NSObject
{
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
	NSString *DELIMETER;
}

-(void) connectToServer;
-(void) sendToServer:(NSString *)cmd;

-(void) menu:(int)i;

+(SharedData *) Initialize;

@end
