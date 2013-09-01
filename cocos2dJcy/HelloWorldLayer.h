//
//  HelloWorldLayer.h
//  cocos2dJcy
//
//  Created by 季程跃 on 13-8-31.
//  Copyright apple 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
//<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *enemy;
    NSMutableArray *bullet;
    int projectilesDestroyed;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
