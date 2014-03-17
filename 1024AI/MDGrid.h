//
//  MDGrid.h
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned int MDTile;
#define kEmptyTile 0

@class MDGrid;

#define RIGHT_TO_LEFT  1
#define LEFT_TO_RIGHT -1
#define TOP_TO_BOTTOM  1
#define BOTTOM_TO_TOP -1

typedef signed int MDGridMovementDirection;

@protocol MDGridMovementDelegate
- (void) grid: (MDGrid*) grid tileAtRow: (NSUInteger) row1 column: (NSUInteger) column1 movedToRow: (NSUInteger) row2 column: (NSUInteger) column2;
- (void) grid: (MDGrid*) grid tileAtRow: (NSUInteger) row column: (NSUInteger) column changedTo: (MDTile) tile;
- (void) grid: (MDGrid*) grid tile: (MDTile) tile appearedAtRow: (NSUInteger) row column: (NSUInteger) column;
@end

@interface MDGrid : NSObject
@property (assign) NSUInteger width;
@property (assign) NSUInteger height;
@property (weak) id<MDGridMovementDelegate> delegate;

- (id) initWithWidth: (NSUInteger) width andHeight: (NSUInteger) height;

- (void) putTile: (MDTile) tile row: (NSUInteger) row column: (NSUInteger) column;
- (MDTile) tileAtRow: (NSUInteger) row column: (NSUInteger) column;
- (void) removeTileAtRow: (NSUInteger) row column: (NSUInteger) column;

- (void) addRandomTiles: (NSUInteger) number;
- (BOOL) isGameOver;

- (void) swipeToTheLeft;
- (void) swipeToTheTop;
- (void) swipeToTheRight;
- (void) swipeToTheBottom;
@end
