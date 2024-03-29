/* cocos2d for iPhone
 *
 * http://www.cocos2d-iphone.org
 *
 * Copyright (C) 2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "CCNode.h"
#import "CCProtocols.h"
#import "CCTextureAtlas.h"

@class CCSpriteSheet;
@class CCSpriteFrame;

#pragma mark CCSprite

enum {
	/// CCSprite invalid index on the CCSpriteSheet
	CCSpriteIndexNotInitialized = 0xffffffff,
};

/**
 Whether or not an CCSprite will rotate, scale or translate with it's parent.
 Useful in health bars, when you want that the health bar translates with it's parent but you don't
 want it to rotate with its parent.
 @since v0.9.0
 */
typedef enum {
	//! Translate with it's parent
	CC_HONOR_PARENT_TRANSFORM_TRANSLATE =  1 << 0,
	//! Rotate with it's parent
	CC_HONOR_PARENT_TRANSFORM_ROTATE	=  1 << 1,
	//! Scale with it's parent
	CC_HONOR_PARENT_TRANSFORM_SCALE		=  1 << 2,

	//! All possible transformation enabled. Default value.
	CC_HONOR_PARENT_TRANSFORM_ALL		=  CC_HONOR_PARENT_TRANSFORM_TRANSLATE | CC_HONOR_PARENT_TRANSFORM_ROTATE | CC_HONOR_PARENT_TRANSFORM_SCALE,

} ccHonorParentTransform;

/** CCSprite is a CCNode object that implements the CCFrameProtocol and CCRGBAProtocol protocols.
 *
 * If the parent is a CCSpriteSheet then the following features/limitations are valid
 *	- Features when the parent is a CCSpriteSheet
 *		- It is MUCH faster if you render multiptle sprites at the same time (eg: 50 or more CCSprite nodes)
 *
 *	- Limitations
 *		- Camera is not supported yet (eg: OrbitCamera action doesn't work)
 *		- GridBase actions are not supported (eg: Lens, Ripple, Twirl)
 *		- The Alias/Antialias property belongs to CCSpriteSheet, so you can't individually set the aliased property.
 *		- The Blending function property belongs to CCSpriteSheet, so you can't individually set the blending function property.
 *		- Parallax scroller is not supported, but can be simulated with a "proxy" sprite.
 *
 *  If the parent is an standard CCNode, then CCSprite behaves like any other CCNode:
 *    - It supports blending functions
 *    - It supports aliasing / antialiasing
 *    - But the rendering will be slower
 *
 */
@interface CCSprite : CCNode <CCFrameProtocol, CCRGBAProtocol, CCTextureProtocol>
{
	
	//
	// Data used when the sprite is rendered using a CCSpriteSheet
	//
	CCTextureAtlas *textureAtlas_;					// Sprite Sheet texture atlas (weak reference)
	NSUInteger atlasIndex_;							// Absolute (real) Index on the SpriteSheet
	BOOL	dirty_;									// Sprite needs to be updated
	CCSpriteSheet	*spriteSheet_;					// Used spritesheet (weak reference)
	ccHonorParentTransform	honorParentTransform_;	// whether or not to transform according to its parent transformations
	BOOL	hasChildren_;							// optimization to check if it contain children
	
	//
	// Data used when the sprite is self-rendered
	//
	ccBlendFunc	blendFunc_;				// Needed for the texture protocol
	CCTexture2D		*texture_;			// Texture used to render the sprite

	//
	// Shared data
	//

	// whether or not it's parent is a CCSpriteSheet
	BOOL	usesSpriteSheet_;

	// texture pixels
	CGRect rect_;
	
	// vertex coords, texture coors and color info
	ccV3F_C4B_T2F_Quad quad_;
	
	// opacity and RGB protocol
	GLubyte		opacity_;
	ccColor3B	color_;
	BOOL		opacityModifyRGB_;
	
	// image is flipped
	BOOL	flipX_;
	BOOL	flipY_;
	
	
	// Animations that belong to the sprite
	NSMutableDictionary *animations;
}

/** whether or not the Sprite needs to be updated in the Atlas */
@property (nonatomic,readwrite) BOOL dirty;
/** the quad (tex coords, vertex coords and color) information */
@property (nonatomic,readonly) ccV3F_C4B_T2F_Quad quad;
/** The index used on the TextureATlas. Don't modify this value unless you know what you are doing */
@property (nonatomic,readwrite) NSUInteger atlasIndex;
/** returns the rect of the CCSprite */
@property (nonatomic,readonly) CGRect textureRect;
/** whether or not the sprite is flipped horizontally */
@property (nonatomic,readwrite) BOOL flipX;
/** whether or not the sprite is flipped vertically */
@property (nonatomic,readwrite) BOOL flipY;
/** opacity: conforms to CCRGBAProtocol protocol */
@property (nonatomic,readonly) GLubyte opacity;
/** RGB colors: conforms to CCRGBAProtocol protocol */
@property (nonatomic,readonly) ccColor3B color;
/** whether or not the Sprite is rendered using a CCSpriteSheet */
@property (nonatomic,readwrite) BOOL usesSpriteSheet;
/** weak reference of the CCTextureAtlas used when the sprite is rendered using a CCSpriteSheet */
@property (nonatomic,readwrite,assign) CCTextureAtlas *textureAtlas;
/** weak reference to the CCSpriteSheet that renders the CCSprite */
@property (nonatomic,readwrite,assign) CCSpriteSheet *spriteSheet;
/** whether or not to transform according to its parent transfomrations.
 Useful for health bars. eg: Don't rotate the health bar, even if the parent rotates.
 IMPORTANT: Only valid if it is rendered using an CCSpriteSheet.
 @since v0.9.0
 */
@property (nonatomic,readwrite) ccHonorParentTransform honorParentTransform;
 

/** conforms to CCTextureProtocol protocol */
@property (nonatomic,readwrite) ccBlendFunc blendFunc;

/** Creates an sprite with a texture.
 The rect used will be the size of the texture.
 The offset will be (0,0).
 */
+(id) spriteWithTexture:(CCTexture2D*)texture;

/** Creates an sprite with a texture and a rect.
 The offset will be (0,0).
 */
+(id) spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect;

/** Creates an sprite with a texture, a rect and offset.
 */
+(id) spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect offset:(CGPoint)offset;

/** Creates an sprite with an sprite frame.
 */
+(id) spriteWithSpriteFrame:(CCSpriteFrame*)spriteFrame;

/** Creates an sprite with an image filename.
 The rect used will be the size of the image.
 The offset will be (0,0).
 */
+(id) spriteWithFile:(NSString*)filename;

/** Creates an sprite with an image filename and a rect.
 The offset will be (0,0).
 */
+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect;

/** Creates an sprite with an image filename, a rect and an offset.
 */
+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect offset:(CGPoint)offset;

/** Creates an sprite with a CGImageRef.
 */
+(id) spriteWithCGImage: (CGImageRef)image;


/** Initializes an sprite with a texture.
 The rect used will be the size of the texture.
 The offset will be (0,0).
 */
-(id) initWithTexture:(CCTexture2D*)texture;

/** Initializes an sprite with a texture and a rect.
 The offset will be (0,0).
 */
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect;

/** Initializes an sprite with a texture, a rect and offset.
 */
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect offset:(CGPoint)offset;

/** Initializes an sprite with a an sprite frame.
 */
-(id) initWithSpriteFrame:(CCSpriteFrame*)spriteFrame;

/** Initializes an sprite with an image filename.
 The rect used will be the size of the image.
 The offset will be (0,0).
 */
-(id) initWithFile:(NSString*)filename;

/** Initializes an sprite with an image filename, and a rect.
 The offset will be (0,0).
 */
-(id) initWithFile:(NSString*)filename rect:(CGRect)rect;

/** Initializes an sprite with an image filename, a rect and offset.
 */
-(id) initWithFile:(NSString*)filename rect:(CGRect)rect offset:(CGPoint)offset;

/** Initializes an sprite with a CGImageRef
 */
-(id) initWithCGImage: (CGImageRef)image;

/** updates the quad according the the rotation, position, scale values.
 */
-(void)updateTransform;

/** updates the texture rect of the CCSprite.
 */
-(void) setTextureRect:(CGRect) rect;

/** tell the sprite to use self-render.
 @since v0.9.0
 */
-(void) useSelfRender;

/** tell the sprite to use sprite sheet render.
 @since v0.9.0
 */
-(void) useSpriteSheetRender:(CCSpriteSheet*)spriteSheet;

@end
