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
    cpSpace * _space;
    CCSprite *_button;
    
    CCPhysicsShape * _walls[4];
    
    
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
    
    
//    _physicsWorld = [CCPhysicsNode node];
//    _physicsWorld.debugDraw = YES; // Enable this if you want the physics shapes and joints drawn over the top of your sprites.
//    _physicsWorld.collisionDelegate = self; // More on this below
//    [self addChild:_physicsWorld];
//
//    CGSize s = [[CCDirector sharedDirector] viewSize];
//
//    CGPoint lowerLeft = ccp(0, 0);
//    CGPoint lowerRight = ccp(s.width, 0);
//
//    CCPhysicsBody *groundBody = [CCPhysicsBody bodyWithPillFrom:lowerLeft to:lowerLeft cornerRadius:0.0f];
//    [groundBody
//
//    // 3
//    float radius = 10.0;
//    CCPhysicsShape *groundShape = [CCPhysicsShape pillShapeFrom:lowerLeft to:lowerRight cornerRadius:radius];
    
    
    // Set up the physics space
    _space = cpSpaceNew();
    cpSpaceSetGravity(_space, cpv(0.0f, -500.0f));
    // Allow collsion shapes to overlap by 2 pixels.
    // This will make contacts pop on and off less, which helps it find matching groups better.
    cpSpaceSetCollisionSlop(_space, 2.0f);

    // Add bounds around the playfield
    {
        cpShape *shape;
        cpBody *staticBody = cpSpaceGetStaticBody(_space);
        cpFloat radius = 20.0;
        
        // left, right, bottom, top
        cpFloat l = 130 - radius;
        cpFloat r = 130 + 767 + radius;
        cpFloat b = 139 - radius;
        cpFloat t = 139 + 1500 + radius;
        
        shape = cpSpaceAddShape(_space, cpSegmentShapeNew(staticBody, cpv(l, b), cpv(l, t), radius));

        shape = cpSpaceAddShape(_space, cpSegmentShapeNew(staticBody, cpv(r, b), cpv(r, t), radius));
        
        shape = cpSpaceAddShape(_space, cpSegmentShapeNew(staticBody, cpv(l, b), cpv(r, b), radius));
        cpShapeSetFriction(shape, 1.0f);
        cpShapeGetBody(shape);
    }
    
    
    
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
    _cue.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_cue.contentSize.width/2.0f andCenter:_cue.anchorPointInPoints];
    [_physicsWorld addChild:_cue];
    
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
