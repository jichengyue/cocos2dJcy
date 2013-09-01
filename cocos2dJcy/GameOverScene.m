//
//  GameOverScene.m
//  cocos2dJcy
//
//  Created by 季程跃 on 13-9-1.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "GameOverScene.h"
#import "HelloWorldLayer.h"

@implementation GameOverScene
@synthesize layer;

-(id)init
{
    if (self = [super init]) {
        self.layer = [GameOverLayer node];
        [self addChild:layer];
    }
    return self;
}

-(void)dealloc
{
    [layer release];
    layer=nil;
    [super dealloc];
}

@end

@implementation GameOverLayer
@synthesize label;

-(id)init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        label = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:35];
        label.color = ccBLUE;
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label z:2];
        
        [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:3],
                     [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                     nil]];
        NSLog(@"%d",[label retainCount]);
    }
    
    return self;
}

-(void)gameOverDone
{
    [[CCDirector sharedDirector]replaceScene:[HelloWorldLayer scene]];
}

-(void)dealloc
{
    //[label release];
    NSLog(@"资源被释放！！！");
    NSLog(@"%d",[label retainCount]);
    [super dealloc];
    
}

@end
