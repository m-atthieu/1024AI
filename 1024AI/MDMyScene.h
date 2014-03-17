//
//  MDMyScene.h
//  1024AI
//

//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MDGrid.h"

@interface MDMyScene : SKScene
- (id) initWithSize: (CGSize) size andGrid: (MDGrid*) grid;
@end
