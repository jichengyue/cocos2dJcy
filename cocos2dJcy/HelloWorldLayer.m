//
//  HelloWorldLayer.m
//  cocos2dJcy
//
//  Created by 季程跃 on 13-8-31.
//  Copyright apple 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

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

/*
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}
 */

-(id)init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        
        enemy = [[NSMutableArray alloc]init];
        bullet = [[NSMutableArray alloc] init];
        projectilesDestroyed = 0;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *soldier = [CCSprite spriteWithFile:@"soldier.png" rect:CGRectMake(0, 0, 27, 40)];
        soldier.position = ccp(soldier.contentSize.width/2,winSize.height/2);
        
        [self addChild:soldier];
    }
    [self schedule:@selector(gameLogic:) interval:1.0];
    [self schedule:@selector(update:)];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];

    [self setTouchEnabled:YES];
    
    
    return self;
}

-(void)gameLogic:(ccTime)dt {
    [self addTarget];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [enemy release];
    [bullet release];
    
	[super dealloc];
}

-(void)addTarget {
    CCSprite *target = [CCSprite spriteWithFile:@"enemy.png"
                                           rect:CGRectMake(0, 0, 27, 40)];
    //CCSprite is init a sprite's picture , size and location.
    
    target.tag = 1;
    [enemy  addObject:target];
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)]; 
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    
    if (sprite.tag == 1) {
        [enemy removeObject:sprite];
        
        
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:@"You Lose !!!"];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];

    }
    else if (sprite.tag==2)
    {
        [bullet removeObject:sprite];
    }
    
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"]; 
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"bullet.png"
                                               rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(20, winSize.height/2);
    
    projectile.tag = 2;
    [bullet addObject:projectile];
    
    // Determine offset of location to projectile
    int offX = location.x - projectile.position.x;
    int offY = location.y - projectile.position.y;
    
    // Bail out if we are shooting down or backwards
    if (offX <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    // Determine where we wish to shoot the projectile to
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far we're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
    [CCMoveTo actionWithDuration:realMoveDuration position:realDest], 
    [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
    
}


- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    for (CCSprite *projectile in bullet)
    {
        CGRect projectileRect = CGRectMake(
           projectile.position.x - (projectile.contentSize.width/2),
           projectile.position.y - (projectile.contentSize.height/2),
           projectile.contentSize.width,
           projectile.contentSize.height);
        
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *target in enemy)
        {
            CGRect targetRect = CGRectMake(
               target.position.x - (target.contentSize.width/2),
               target.position.y - (target.contentSize.height/2),
               target.contentSize.width,
               target.contentSize.height);
            
            if (CGRectIntersectsRect(projectileRect, targetRect))
            {
                [targetsToDelete addObject:target];
            }
        } 
        
        for (CCSprite *target in targetsToDelete)
        {
            [enemy removeObject:target];
            [self removeChild:target cleanup:YES];
        } 
        
        if (targetsToDelete.count > 0)
        {
            [projectilesToDelete addObject:projectile];
        } 
        [targetsToDelete release];
        
    } 
    
    for (CCSprite *projectile in projectilesToDelete)
    {
        [bullet removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
        projectilesDestroyed++;
        if (projectilesDestroyed > 30) {
            
            GameOverScene *gameOverScene = [GameOverScene node];
            [gameOverScene.layer.label setString:@"You Win!"];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
            
        }
        
    } 
    [projectilesToDelete release];
    
} 


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
