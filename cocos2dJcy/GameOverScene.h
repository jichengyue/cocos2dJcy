//
//  GameOverScene.h
//  cocos2dJcy
//
//  Created by 季程跃 on 13-9-1.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor
{
    CCLabelTTF *label;
}

@property(nonatomic,retain) CCLabelTTF *label;

@end


@interface GameOverScene : CCScene
{
    GameOverLayer *layer;
    
}
@property(nonatomic,retain) GameOverLayer *layer;

@end
