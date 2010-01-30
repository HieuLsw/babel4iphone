//
//  SharedData.m
//  Genoma
//
//  Created by Giovanni Amati on 08/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedData.h"
#import "CCDirector.h"
#import "PlayerData.h" // per l'init della lista player

@implementation SharedData

@synthesize mainMenu, playerList;//, iStream, oStream;

-(void) dealloc
{
	NSLog(@"------------------- RELEASE SINGETON DATA ----------------------");
	inputStream = nil;
	outputStream = nil;
	
	[mainMenu release];
	[playerList release];
	[super dealloc];
}

-(void) connectToServer:(NSString *)cmd
{
	CFHostRef host;
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	readStream = NULL;
	writeStream = NULL;
	
	host = CFHostCreateWithName(NULL, (CFStringRef)@"127.0.0.1");
	CFStreamCreatePairWithSocketToCFHost(NULL, host, 66666, &readStream, &writeStream);
	CFRelease(host);
	
	inputStream = [(NSInputStream *)readStream autorelease];
	outputStream = [(NSOutputStream *)writeStream autorelease];
	
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
	[outputStream open];
	
	[self sendToServer:cmd];
}

-(void) sendToServer:(NSString *)cmd
{
	cmd = [cmd stringByAppendingString:@"\r\n"];
    [outputStream write:(const uint8_t *)[cmd UTF8String] maxLength:[cmd length]];    
}

-(void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent
{
	NSString *io;
	if (stream == inputStream) io = @"[SERVER]";
	else io = @"[CLIENT]";
	
	NSString *event;
	switch (streamEvent)
	{
		case NSStreamEventNone:
			event = @"<< EventNone >>";
			break;
		case NSStreamEventOpenCompleted:
			event = @"<< Connessione... >>";
			break;
		case NSStreamEventHasBytesAvailable:
			event = @"<< Comunicazione dati... >>";
			if (stream == inputStream)
			{
				uint8_t buffer[1024];
				unsigned int len = 0;
				while ([inputStream hasBytesAvailable])
				{
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
					{
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						//NSData *theData = [[NSData alloc] initWithBytes:buffer length:len];
						if (nil != output)
						{
							NSArray *arr = [output componentsSeparatedByString:@"|"];
							[output release];
							
							if ([[arr objectAtIndex:0] isEqualToString:@"M"])
							{
								NSLog(@"%@ : %@", io, [arr objectAtIndex:1]);
							}
							else
							{
								NSLog(@"Not implemented server msg : %@", arr);
							}
						}
					}
				}
			}
			break;
		case NSStreamEventHasSpaceAvailable:
			event = @"<< Comunicazione disponibile... >>";
			break;
		case NSStreamEventErrorOccurred:
			event = @"<< Errore di connesione... >>";
			break;
		case NSStreamEventEndEncountered:
			event = @"<< Connessione persa... >>";
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //[stream release]; // fa scoppiare
			//if (stream != NULL) CFRelease(stream);
            stream = nil;
			break;
		default:
			event = @"<< Unknown >>";
	}
	
	NSLog(@"%@ : %@", io, event);
}

-(void) initGame
{	
	self.mainMenu = [NSMutableArray array];
	[self.mainMenu addObject:@"Attack"];
	[self.mainMenu addObject:@"Defende"];
	[self.mainMenu addObject:@"Magics"];
	[self.mainMenu addObject:@"Invocations"];
	[self.mainMenu addObject:@"Items"];
	[self.mainMenu addObject:@"Team"];
	[self.mainMenu addObject:@"Settings"];
	
	// deve essere fatta dalla sorgente dati
	self.playerList = [NSMutableArray array];
	
	id p1 = [[[PlayerData alloc] init] autorelease];
	[p1 setName:@"Vito"];
	[p1 setType:@"Human"];
	id p2 = [[[PlayerData alloc] init] autorelease];
	[p2 setName:@"Gino"];
	[p2 setType:@"Human"];
	id p3 = [[[PlayerData alloc] init] autorelease];
	[p3 setName:@"Monter"];
	[p3 setType:@"NPC"];
	
	[self.playerList addObject:p1];
	[self.playerList addObject:p2];
	[self.playerList addObject:p3];
	
	playerSel = arc4random() % [self.playerList count]; // x ora il turno comincia random
	
	// prova socket
	[self connectToServer:@"U|test"];
	[self sendToServer:@"M|cacca"];
	[self sendToServer:@"M|merda"];
}

-(NSMutableArray *) getMenu:(NSString *)name
{
	if (@"Main" == name)
		return self.mainMenu;
	else if (@"Magics" == name)
		return [[self getPlayer:-1] getMagicMenu];
	else
		return NULL;
}

-(id) getPlayer:(int)i  // current player -1
{
	if (0 > i)
		i = playerSel;
	return [self.playerList objectAtIndex:i];
}

-(void) nextTurn
{
	playerSel = (playerSel + 1) % [self.playerList count];
	
	id layer = [[[CCDirector sharedDirector] runningScene] getChildByTag:1];
	[layer getTurn];
}

-(void) addAction:(NSString *)name ofType:(NSString *)type toTarget:(int)target
{
	NSLog(@"----> Player: %s - %s action: %s", [[[self getPlayer:-1] name] UTF8String], [type UTF8String], [name UTF8String]);
	// creare una lista di azioni da fare in gamelayer
}

-(void) generateAction
{
	NSLog(@"----> NPC: %s IA generate a action and target", [[[self getPlayer:-1] name] UTF8String]);
	// creare una lista di azioni da fare in gamelayer
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// Singleton ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

static SharedData *sharedMyData = nil;

+(SharedData *) Initialize
{
    @synchronized(self)
	{
        if (sharedMyData == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedMyData;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (sharedMyData == nil)
		{
            sharedMyData = [super allocWithZone:zone];
            return sharedMyData;
        }
    }
	
    return nil;
}

-(id) copyWithZone:(NSZone *)zone
{	
    return self;
}

-(id) retain
{
    return self;
}

-(unsigned) retainCount
{
    return UINT_MAX;
}

-(void) release
{
	[super release];
}

-(id) autorelease
{
	return self;
}

@end