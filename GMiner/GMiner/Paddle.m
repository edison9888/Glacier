/* TouchesTest (c) Valentin Milea 2009
 */
#import "Paddle.h"
#import "cocos2d.h"

@implementation Paddle
{
    CGFloat _xOffset;
    CGFloat _yOffset;
}

#define hdsize(s) CGSizeMake(s.width/2,s.height/2)

- (CGRect)rectInPixels
{
	CGSize s = [self.texture contentSizeInPixels];
    s = hdsize(s);
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [self.texture contentSize];
    s = hdsize(s);
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

+ (id)paddleWithTexture:(CCTexture2D *)aTexture
{
	return [[[self alloc] initWithTexture:aTexture] autorelease];
}

- (id)initWithTexture:(CCTexture2D *)aTexture
{
	if ((self = [super initWithTexture:aTexture]) ) {

		state = kPaddleStateUngrabbed;
	}

	return self;
}


- (void)onEnter
{
	CCDirector *director =  [CCDirector sharedDirector];

	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];

	[[director touchDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (state != kPaddleStateUngrabbed) return NO;
	if ( ![self containsTouchLocation:touch] ) return NO;

    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    _xOffset =  self.position.x - touchPoint.x;
    _yOffset = self.position.y -touchPoint.y;
    
	state = kPaddleStateGrabbed;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

	NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");

	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
	self.position = CGPointMake(touchPoint.x + _xOffset, touchPoint.y + _yOffset);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");

	state = kPaddleStateUngrabbed;
}

@end
