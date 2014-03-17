//
//  MDMyScene.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDGridScene.h"

@interface MDGridScene ()
@property (strong) MDGrid* grid;
@property (strong) SKLabelNode* scoreNode;
@property (strong) NSMutableArray* displayedTiles;
@end

@implementation MDGridScene
@synthesize grid;
@synthesize scoreNode;
@synthesize displayedTiles;

- (id) initWithSize: (CGSize) size andGrid: (MDGrid*) aGrid
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        grid = aGrid;
        displayedTiles = [NSMutableArray arrayWithCapacity: grid.width * grid.height];
        [self setupGestureRecognizers];
        [self setupGridTiles];
        [self setupScoreNode];
        [self displayGrid];
    }
    return self;
}

- (void) dealloc
{
    grid = nil;
    displayedTiles = nil;
}

- (void) setupGestureRecognizers
{
    UISwipeGestureRecognizer* swipe;
    self.userInteractionEnabled = YES;
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipe:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer: swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipe:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer: swipe];

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipe:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer: swipe];

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipe:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer: swipe];
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

- (SKShapeNode*) nodeForBackgroundTileAtRow: (NSUInteger) row column: (NSUInteger) column withColor: (SKColor*) color
{
    CGFloat intersWidth = 10 * (grid.width);
    CGFloat tileWidth = (self.frame.size.width  - intersWidth) / grid.width;
    CGFloat basey =     (self.frame.size.height - self.frame.size.width) / 2;

    CGFloat tx =         5 + ((column - 1) * tileWidth) + (10 * (column - 1));
    CGFloat ty = basey + 5 + ((row    - 1) * tileWidth) + (10 * (row    - 1));
    const CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);

    CGMutablePathRef tilePath = CGPathCreateMutable();
    CGPathAddRect(tilePath, &transform, CGRectMake(0, 0, tileWidth, tileWidth));
    SKShapeNode* node = [[SKShapeNode alloc] init];
    node.path        = tilePath;
    node.strokeColor = color;
    node.fillColor   = color;
    return node;
}

- (SKLabelNode*) nodeForNumber: (MDTile) number atRow: (NSUInteger) row column: (NSUInteger) column withColor: (SKColor*) color
{
    CGFloat intersWidth = 10 * (grid.width);
    CGFloat tileWidth = (self.frame.size.width  - intersWidth) / grid.width;
    CGFloat basey =     (self.frame.size.height - self.frame.size.width) / 2;

    CGFloat tx =         5 + ((column - 1) * tileWidth) + (10 * (column - 1));
    CGFloat ty = basey + 5 + ((row    - 1) * tileWidth) + (10 * (row    - 1));

    SKLabelNode* node = [SKLabelNode labelNodeWithFontNamed: @"Chalkduster"];
    node.text     = [NSString stringWithFormat: @"%d", number];
    node.position = CGPointMake(tx + tileWidth / 2 - (node.fontSize / 2),
                                ty + tileWidth / 2 - (node.fontSize / 2));
    node.fontColor = color;
    return node;
}

- (void) setupGridTiles
{
    // http://colorschemedesigner.com/#5g21Tw0w0w0w0
    // background : eb6aa4
    self.backgroundColor = [SKColor colorWithRed: 0.9 green: 0.55 blue: 0.8 alpha:1.0];
    // gutter : eb3b8b
    SKColor* color = [SKColor colorWithRed: 0.9 green: 0.27 blue: 0.75 alpha: 1];

    for(int col = 1; col <= grid.width; ++col){
        for(int row = 1; row <= grid.height; ++row){
            SKShapeNode* node = [self nodeForBackgroundTileAtRow: row column: col withColor: color];
            [self addChild: node];
        }
    }
}

- (void) undisplayAllTiles
{
    [displayedTiles enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop){
	    [obj removeFromParent];
	}];
    [displayedTiles removeAllObjects];
}

- (void) displayGrid
{
    // tiles : 8bea00
    SKColor* tileColor = [SKColor colorWithRed: 0.54 green: 0.91 blue: 0 alpha: 1];
    // tiles text : 5a9800
    SKColor* textColor = [SKColor colorWithRed: 0.35 green: 0.58 blue: 0 alpha: 1];

    NSLog(@"%s %@", __PRETTY_FUNCTION__, grid);

    for(int row = 1; row <= grid.height; ++row){
        for(int col = 1; col <= grid.width; ++col){
            MDTile tile = [grid tileAtRow: row column: col];
            if(tile != kEmptyTile){
                SKShapeNode* node  = [self nodeForBackgroundTileAtRow: row column: col withColor: tileColor];
                SKLabelNode* label = [self nodeForNumber: tile  atRow: row column: col withColor: textColor];
                [node addChild: label];
                [self addChild: node];
            }
        }
    }
}

- (void) swipe: (UISwipeGestureRecognizer*) gesture
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch(gesture.direction){
    case UISwipeGestureRecognizerDirectionLeft:
	[grid swipeToTheLeft]; break;
    case UISwipeGestureRecognizerDirectionRight:
	[grid swipeToTheRight]; break;
    case UISwipeGestureRecognizerDirectionUp:
	[grid swipeToTheTop]; break;
    case UISwipeGestureRecognizerDirectionDown:
	[grid swipeToTheBottom]; break;
    }
    [self undisplayAllTiles];
    [self displayGrid];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end