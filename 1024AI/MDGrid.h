//
//  MDGrid.h
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTile.h"

@interface MDGrid : NSObject

@property (assign) NSMutableArray* tiles;
@property (assign) NSUInteger width;
@property (assign) NSUInteger height;

- (id) initWithWidth: (NSUInteger) width andHeight: (NSUInteger) height;

- (void) putTile: (MDTile*) tile row: (NSUInteger) row column: (NSUInteger) column;
- (MDTile*) tileAtRow: (NSUInteger) row column: (NSUInteger) column;
- (void) removeTileAtRow: (NSUInteger) row column: (NSUInteger) column;

- (void) random: (NSUInteger) number;

- (void) swipeToTheLeft;
- (void) swipeToTheTop;
- (void) swipeToTheRight;
- (void) swipeToTheBottom;
@end
