//
//  HelloWorldLayer.m
//  GMiner
//
//  Created by cnzhao on 13-5-14.
//  Copyright glacier 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "Paddle.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer
{
    CCSprite * _sp;
    CGPoint _velocity;
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		CCTexture2D *paddleTexture = [[CCTextureCache sharedTextureCache] addImage:@"drop.jpg"];
        Paddle *paddle = [Paddle paddleWithTexture:paddleTexture];
        paddle.position = CGPointMake(160, 15);
        [self addChild:paddle];
        
        CCSprite *paddle1 = [CCSprite spriteWithFile:@"Icon.png"];
        paddle1.position = CGPointMake(300, 100);
        [self addChild:paddle1];
        CCRotateBy * rot = [CCRotateBy actionWithDuration:5 angle:360];
        CCEaseIn * ea = [CCEaseIn actionWithAction:rot rate:4];
        CCRepeatForever * fo = [CCRepeatForever actionWithAction:ea];
//        [paddle1 runAction:fo];
        _sp = paddle1;
        self.accelerometerEnabled = true;
        [self scheduleUpdate];
        
	}
	return self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float deceleration = 0.4f;
    float sensitivity = 6.0f;
    float maxVelocity = 100;
    _velocity.x = _velocity.x * deceleration + acceleration.x * sensitivity;
    
    NSLog(@"_velocity.x %f acc %f",_velocity.x,acceleration.x);
    
    if (_velocity.x > maxVelocity)
    {
        _velocity.x = maxVelocity;
    }
    else if(_velocity.x < - maxVelocity)
    {
        _velocity.x = - maxVelocity;
    }
}

- (void)update:(ccTime)delta
{
    CGPoint pos = _sp.position;
    pos.x += _velocity.x;
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float imageWidthHalved = [_sp texture].contentSize.width * 0.5f;
    float leftLim = imageWidthHalved;
    float rightLim = screenSize.width - imageWidthHalved;
    if (pos.x < leftLim)
    {
        pos.x = leftLim;
        _velocity = CGPointZero;
    }
    else if(pos.x > rightLim)
    {
        pos.x = rightLim;
        _velocity = CGPointZero;
    }
    
    _sp.position = pos;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
	[super dealloc];
}

//#pragma mark GameKit delegate
//
//-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
//
//-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
@end
