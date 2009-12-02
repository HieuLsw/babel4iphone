//
//  BabelAppDelegate.m
//  Babel
//
//  Created by Giovanni Amati on 02/12/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BabelAppDelegate.h"
#import "cocos2d.h"
#import "MenuLayer.h"
#import "GameLayer.h"

enum {
	kTagGameLayer = 0,
	kTagMenuLayer = 1,
};

@implementation BabelAppDelegate

@synthesize window;

-(void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
	// [[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	GameLayer *glayer = [GameLayer node];
	[glayer loadWithMap:1 playerPos:ccp(96, 16)]; //ccp(700, 700)];      //ccp(96, 16)];
	MenuLayer *mlayer = [MenuLayer node];
	
	[scene addChild:glayer z:0 tag:kTagGameLayer]; // 0 tag del game layer
	[scene addChild:mlayer z:1 tag:kTagMenuLayer]; // 1 tag del menu layer
	
	[[CCDirector sharedDirector] runWithScene: scene];
}


-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

-(void) applicationWillTerminate:(UIApplication *)application
{
	[[CCDirector sharedDirector] end];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void) dealloc
{
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end