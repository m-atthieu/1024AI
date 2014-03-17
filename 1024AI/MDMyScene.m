//
//  MDMyScene.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDMyScene.h"
#import "MDTile.h"

@interface MDMyScene ()
@property (strong) MDGrid* grid;
@property (strong) SKLabelNode* scoreNode;
@property (strong) UITouch* firstTouch;
@end

@implementation MDMyScene
@synthesize grid;
@synthesize scoreNode;
@synthesize firstTouch;

- (id) initWithSize: (CGSize) size andGrid: (MDGrid*) aGrid
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        grid = aGrid;

        firstTouch = nil;

        [self setupGridTiles];
        [self setupScoreNode];
        [self displayGrid];
    }
    return self;
}

- (void) setupScoreNode
{
    scoreNode = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    scoreNode.text = @"Score : 0";
    scoreNode.fontSize = 18;
    scoreNode.position = CGPointMake(self.frame.size.width / 2,
                                     self.frame.size.height * 0.1);
    [self addChild: scoreNode];
}

- (void) setupGridTiles
{
    // http://colorschemedesigner.com/#5g21Tw0w0w0w0
    // background : eb6aa4
    self.backgroundColor = [SKColor colorWithRed: 0.9 green: 0.55 blue: 0.8 alpha:1.0];
    // gutter : eb3b8b
    CGFloat intersWidth = 10 * (grid.width);
    CGFloat tileWidth = (self.frame.size.width - intersWidth) / grid.width;
    CGFloat basey = (self.frame.size.height - self.frame.size.width) / 2;
    for(int i = 0; i < grid.width; ++i){
        for(int j = 0; j < grid.height; ++j){
            CGMutablePathRef tilePath = CGPathCreateMutable();
            CGFloat tx = 5 + (i * tileWidth) + (10 * i);
            CGFloat ty = basey + 5 + (j * tileWidth) + (10 * j);
            const CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
            CGPathAddRect(tilePath, &transform, CGRectMake(0, 0, tileWidth, tileWidth));
            SKShapeNode* tileBack = [[SKShapeNode alloc] init];
            tileBack.path = tilePath;
            tileBack.strokeColor = [SKColor colorWithRed: 0.9 green: 0.27 blue: 0.75 alpha: 1];
            tileBack.fillColor = [SKColor colorWithRed: 0.9 green: 0.27 blue: 0.75 alpha: 1];
            [self addChild: tileBack];
        }
    }
}

- (void) displayGrid
{
    CGFloat intersWidth = 10 * (grid.width);
    CGFloat tileWidth = (self.frame.size.width - intersWidth) / grid.width;
    CGFloat basey = (self.frame.size.height - self.frame.size.width) / 2;
    // tiles : 8bea00
    SKColor* tileColor = [SKColor colorWithRed: 0.54 green: 0.91 blue: 0 alpha: 1];
    // tiles text : 5a9800
    SKColor* textColor = [SKColor colorWithRed: 0.35 green: 0.58 blue: 0 alpha: 1];

    for(int i = 1; i <= grid.width; ++i){
        for(int j = 1; j <= grid.height; ++j){
            MDTile* tile = [grid tileAtRow: j column: i];
            if(tile != nil){
                CGMutablePathRef tilePath = CGPathCreateMutable();
                CGFloat tx = 5 + (i * tileWidth) + (10 * i);
                CGFloat ty = basey + 5 + (j * tileWidth) + (10 * j);
                const CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
                CGPathAddRect(tilePath, &transform, CGRectMake(0, 0, tileWidth, tileWidth));
                SKShapeNode* tileBack = [[SKShapeNode alloc] init];
                tileBack.path = tilePath;
                tileBack.strokeColor = tileColor;
                tileBack.fillColor = tileColor;
                [self addChild: tileBack];
                SKLabelNode* number = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
                number.text = [NSString stringWithFormat: @"%d", tile.number];
                number.position = CGPointMake(tx + tileWidth / 2 - (number.fontSize / 2),
                                              ty + tileWidth / 2 - (number.fontSize / 2));
                number.fontColor = textColor;
                [self addChild: number];
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    if(firstTouch == nil){
        firstTouch = touch;
        CGPoint location = [touch locationInView: self.view];
        NSLog(@"first touch %f %f", location.x, location.y);
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(firstTouch != nil){
        UITouch* touch = [touches anyObject];
        CGPoint t1 = [firstTouch locationInView: self.view];
        CGPoint t2 = [touch locationInView: self.view];
        NSLog(@"second touch %f %f", t2.x, t2.y);
        CGFloat dx = t2.x - t1.x;
        CGFloat dy = t2.y - t1.y;
        NSLog(@"diff %f %f", dx, dy);
        if(abs(dx) == 0 && dy == 0){ NSLog(@"no"); return; }
        if(abs(dx) > abs(dy)){
            if(dx < 0){
                NSLog(@"swipe left %f %f", dx, dy);
            } else {
                NSLog(@"swipe right %f %f", dx, dy);
            }
        } else {
            if(dy < 0){
                NSLog(@"swipe top %f %f", dx, dy);
            } else {
                NSLog(@"swipe bottom %f %f", dx, dy);
            }
        }
        firstTouch = nil;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouch = nil;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
