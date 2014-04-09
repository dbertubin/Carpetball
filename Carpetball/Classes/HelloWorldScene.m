//
//  HelloWorldScene.m
//  Carpetball
//
//  Created by Derek Bertubin on 4/7/14.
//  Copyright Derek Bertubin 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"



#define PTM_RATIO 32.0
// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_cue;
    CCPhysicsNode *_physicsWorld;
    ChipmunkSpace * _space;
    CCSprite *_button;
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    
    _space = [[ChipmunkSpace alloc] init];
    
    
    [[OALSimpleAudio sharedInstance] playBg:@"background_music.mp3" loop:YES];
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    
    
    // Create a colored background (Dark Grey)
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"background_iphone5_table.png"];
    background.anchorPoint = ccp(0,0);
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add a sprite
    _cue = [CCSprite spriteWithImageNamed:@"cue_2.png"];
    _cue.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:_cue];
    //    // Animate sprite with action
    //    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    _button = [CCSprite spriteWithImageNamed:@"button_2b.png"];
    _button.positionType = CCPositionTypeNormalized;
    _button.position = ccp(0.50f, 0.95f);
    [self addChild:_button];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"Menu" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.50f, 0.955f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    // 2
    CGPoint offset    = ccpSub(touchLocation, _cue.position);
    float   ratio     = offset.y/offset.x;
    int     targetX   = _cue.contentSize.width/2 + self.contentSize.width;
    int     targetY   = (targetX*ratio) + _cue.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
    
    // 4
    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [_cue runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
    
    //    // Move our sprite to touch location
    //    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    //    [_cue runAction:actionMove];
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // 'touches' will only contain one touch, because we aren't using multitouch
//    UITouch *touch = [touches anyObject];
//
//    // we want to know the location of our touch in this scene
//    CGPoint touchLocation = [touch locationInNode:self];
//
//    // move the ship animated to the touch position
//    [_cue runAction: [CCActionMoveTo actionWithDuration:1.f position:touchLocation]];
//}


//- (void)update:(CCTime)delta
//{
//    //move the ship only in the x direction by a fixed amount every frame
//    _cue.position = ccp( _cue.position.x + 100*delta, _cue.position.y );
//
//    if (_cue.position.x > self.contentSize.width+32)
//    {
//        //if the ship reaches the edge of the screen, loop around
//        _cue.position = ccp( -32, _cue.position.y);
//    }
//}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
    
    
    [[OALSimpleAudio sharedInstance] stopBg];
    
}

// -----------------------------------------------------------------------
@end
