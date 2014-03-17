//
//  MDGrid.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDGrid.h"

#define GRID(r, c) (_grid[(r) * width + (c)])
#define CAN_COMBINE(t1, t2) ((t1) == (t2))
#define COMBINE(t1, t2) ((t1) + (t2))

#define EMPTY_ADD(row, col) [empty    addObject: NSStringFromCGPoint(CGPointMake(row, col))]
#define EMPTY_DEL(row, col) [empty removeObject: NSStringFromCGPoint(CGPointMake(row, col))]

@interface MDGrid ()
{
    MDTile* _grid;
}
@property (strong) NSMutableSet* empty;

- (void) treat: (MDTile*) line   line: (NSUInteger) index;
- (void) treat: (MDTile*) line column: (NSUInteger) index;

- (BOOL) canSwipeToLeft;
- (BOOL) canSwipeToRight;
- (BOOL) canSwipeToTop;
- (BOOL) canSwipeToBottom;
@end

@implementation MDGrid
@synthesize width;
@synthesize height;
@synthesize empty;
@synthesize delegate;

- (id) initWithWidth: (NSUInteger) aWidth andHeight: (NSUInteger) aHeight
{
    NSParameterAssert( aWidth > 0);
    NSParameterAssert(aHeight > 0);
    NSParameterAssert(aWidth == aHeight);
    
    if(self = [super init]){
        width = aWidth;
        height = aHeight;
	delegate = nil;
        _grid = calloc(width * height, sizeof(MDTile));
	empty = [NSMutableSet set];
	for(int i = 1; i <= width; ++i){
	    for(int j = 1; j <= height; ++j){
            EMPTY_ADD(i, j);
	    }
	}
	
    }
    return self;
}

- (void) dealloc
{
    free(_grid);
}

- (NSString*) description
{
    NSString* desc = @"";
    MDTile tile;
    for(int i = 0; i < height; ++i){
        for(int j = 0; j < width; ++j){
            tile = [self tileAtRow: i + 1 column: j + 1];
            if(tile == kEmptyTile){
                desc = [desc stringByAppendingString: @"0 "];
            } else {
                desc = [desc stringByAppendingFormat: @"%d ", tile];
            }
        }
        desc = [desc stringByAppendingString: @";"];
    }
    return desc;
}

#pragma mark - Game Management

- (void) addRandomTiles: (NSUInteger) toFill
{
    for(NSUInteger i = 0; i < toFill; ++i){
        NSString* s = [[empty allObjects] objectAtIndex: arc4random_uniform([empty count])];
        CGPoint random = CGPointFromString(s);
        [self putTile: 2 row: random.x column: random.y];
        if(delegate){ [delegate grid: self tile: 2 appearedAtRow: random.x column: random.y]; }
        EMPTY_DEL(random.x, random.y);
    }
}

- (BOOL) isGameOver
{
    if([empty count] != 0){ return NO; }
    
    return  [self canSwipeToLeft]  ||
            [self canSwipeToRight] ||
            [self canSwipeToTop]   ||
            [self canSwipeToBottom];
}

- (BOOL) canSwipeToLeft
{
    BOOL can = NO;
    for(int row = 0; row < height; ++row){
        for(int col = 0; col < width - 1; ++col){
            if(CAN_COMBINE(GRID(row, col), GRID(row, col + 1))){
                can = YES;
            }
        }
    }
    return can;
}

- (BOOL) canSwipeToRight
{
    BOOL can = NO;
    for(int row = 0; row < height; ++row){
        for(int col = 1; col < width; ++col){
            if(CAN_COMBINE(GRID(row, col - 1), GRID(row, col))){
                can = YES;
            }
        }
    }
    return can;
}

- (BOOL) canSwipeToTop
{
    BOOL can = NO;
    for(int col = 0; col < width; ++col){
        for(int row = 1; row < height; ++col){
            if(CAN_COMBINE(GRID(row, col), GRID(row - 1, col))){
                can = YES;
            }
        }
    } 
    return can;
}

- (BOOL) canSwipeToBottom
{
    BOOL can = NO;
    for(int col = 0; col < width; ++col){
        for(int row = 0; row < height - 1; ++col){
            if(CAN_COMBINE(GRID(row, col), GRID(row + 1, col))){
                can = YES;
            }
        }
    } 
    return can;
}

#pragma mark - Grid Management

- (void) putTile: (MDTile) tile row: (NSUInteger) row column: (NSUInteger) column
{
    NSParameterAssert(row >= 1);
    NSParameterAssert(column >= 1);
    NSParameterAssert(row <= height);
    NSParameterAssert(column <= width);
    if(tile == kEmptyTile){
        EMPTY_ADD(row, column);
    } else {
        EMPTY_DEL(row, column);
    }
    GRID(row - 1, column - 1) = tile;
}

- (MDTile) tileAtRow: (NSUInteger) row column: (NSUInteger) column
{
    NSParameterAssert(row >= 1);
    NSParameterAssert(column >= 1);
    NSParameterAssert(row <= height);
    NSParameterAssert(column <= width);

    return GRID(row - 1, column -1);
}

- (void) removeTileAtRow: (NSUInteger) row column: (NSUInteger) column
{
    GRID(row - 1, column - 1) = kEmptyTile;
    [empty addObject: [NSValue valueWithCGPoint: CGPointMake(row, column)]];
}

#pragma mark - Movements

- (void) treat: (MDTile*) line line: (NSUInteger) index
{
    MDTile newLine[width];
    int k = 0;
    for(int i = 0; i < width; ++i){
        if(line[i] != kEmptyTile){
            newLine[k] = line[i];
            if(delegate){ [delegate grid: self tileAtRow: index column: i movedToRow: index column: k]; }
            ++k;
        }
    }
    for(; k < width; ++k){ newLine[k] = kEmptyTile; }

    MDTile current, next;
    for(int i = 0; i < width - 1; ++i){
        current = newLine[i];
        next = newLine[i + 1];
        if(CAN_COMBINE(current, next)){
            newLine[i] = COMBINE(current, next);
            if(delegate){ [delegate grid: self tile: newLine[i] appearedAtRow: index column: i]; }
            newLine[i + 1] = kEmptyTile;
        }
    }
    // copy
    for(int i = 0; i < width; ++i){
        line[i] = newLine[i];
    }
}

- (void) treat: (MDTile*) line column: (NSUInteger) index
{
    MDTile newLine[height];
    int k = 0;
    for(int i = 0; i < height; ++i){
        if(line[i] != kEmptyTile){
            newLine[k] = line[i];
            ++k;
        }
    }
    for(; k < height; ++k){ newLine[k] = kEmptyTile; }

    MDTile current, next;
    for(int i = 0; i < height - 1; ++i){
        current = newLine[i];
        next = newLine[i + 1];
        if(CAN_COMBINE(current, next)){
            newLine[i] = COMBINE(current, next);
            newLine[i + 1] = kEmptyTile;
        }
    }
    // copy
    for(int i = 0; i < width; ++i){
        line[i] = newLine[i];
    }
}

- (void) swipeToTheLeft
{
    MDTile* line = calloc(width, sizeof(MDTile));
    for(int row = 0; row < height; ++row){
        for(int col = 0; col < width ; ++col){
            line[col] = GRID(row, col);
        }

        [self treat: line line: row];

        for(int col = 0; col < width ; ++col){
            GRID(row, col) = line[col];
            if(line[col] == kEmptyTile){
                EMPTY_ADD(row + 1, col + 1);
            } else {
                EMPTY_DEL(row + 1, col + 1);
            }
        }
    }
    free(line);
}

- (void) swipeToTheTop
{
    MDTile* line = calloc(height, sizeof(MDTile));
    for(int col = 0; col < width; ++col){
        for(int row = 0; row < height; ++row){
            line[row] = GRID(row, col);
        }

        [self treat: line column: col];

        for(int row = 0; row < height; ++row){
            GRID(row, col) = line[row];
            if(line[col] == kEmptyTile){
                EMPTY_ADD(row + 1, col + 1);
            } else {
                EMPTY_DEL(row + 1, col + 1);
            }
        }
    }
    free(line);
}

- (void) swipeToTheRight
{
    MDTile* line = calloc(width, sizeof(MDTile));
    for(int row = 0; row < height; ++row){
        for(int col = width - 1; col >= 0; --col){
            line[col] = GRID(row, col);
        }

        [self treat: line line: row];

        for(int col = 0; col < width; ++col){
            GRID(row, col) = line[width - col - 1];
            if(line[width - col - 1] == kEmptyTile){
                EMPTY_ADD(row + 1, col + 1);
            } else {
                EMPTY_DEL(row + 1, col + 1);
            }

        }
    }
    free(line);
}

- (void) swipeToTheBottom
{
    MDTile* line = calloc(height, sizeof(MDTile));
    for(int col = 0; col < width; ++col){
        for(int row = height - 1; row >= 0; --row){
            line[row] = GRID(row, col);
        }

        [self treat: line column: col];

        for(int row = 0; row < height; ++row){
            GRID(row, col) = line[height - row - 1];
            if(line[height - row - 1] == kEmptyTile){
                EMPTY_ADD(row + 1, col + 1);
            } else {
                EMPTY_DEL(row + 1, col + 1);
            }

        }
    }
    free(line);
}

@end

#undef GRID
#undef CAN_COMBINE
#undef COMBINE
#undef EMPTY_ADD
#undef EMPTY_DEL
