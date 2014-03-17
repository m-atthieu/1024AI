//
//  MDGrid.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDGrid.h"

@interface MDGrid ()
@property (assign) NSUInteger filled;
- (NSArray*) treat: (NSArray*) line;
@end

@implementation MDGrid
@synthesize tiles;
@synthesize width;
@synthesize height;
@synthesize filled;

- (id) initWithWidth: (NSUInteger) aWidth andHeight: (NSUInteger) aHeight
{
    NSParameterAssert( aWidth > 0);
    NSParameterAssert(aHeight > 0);
    NSParameterAssert(aWidth == aHeight);

    if(self = [super init]){
        filled = 0;
        width = aWidth;
        height = aHeight;
        tiles = [NSMutableArray arrayWithCapacity: height];
        for(int i = 0; i <= height; ++i){
            NSMutableArray* line = [NSMutableArray arrayWithCapacity: width];
            for (int j = 0; j < width; ++j) {
                [line setObject: [NSNull null] atIndexedSubscript: j];
            }
            [tiles setObject: line atIndexedSubscript: i];
        }
    }
    return self;
}

- (void) random: (NSUInteger) number
{
    [self putTile: [[MDTile alloc] initWithNumber: 2] row: 2 column: 2];
    [self putTile: [[MDTile alloc] initWithNumber: 2] row: 1 column: 3];
    self.filled += 2;
}

- (NSString*) description
{
    NSString* desc = @"";
    MDTile* tile;
    for(int i = 0; i < height; ++i){
        for(int j = 0; j < width; ++j){
            tile = [self tileAtRow: i + 1 column: j + 1];
            if(tile == nil){
                desc = [desc stringByAppendingString: @"0 "];
            } else {
                desc = [desc stringByAppendingFormat: @"%d ", [tile number]];
            }
        }
        desc = [desc stringByAppendingString: @";"];
    }
    return desc;
}

- (void) putTile: (MDTile*) tile row: (NSUInteger) row column: (NSUInteger) column
{
    NSParameterAssert(row >= 1);
    NSParameterAssert(column >= 1);
    NSParameterAssert(row <= height);
    NSParameterAssert(column <= width);
    
    [[tiles objectAtIndex: row - 1] setObject: tile atIndex: column - 1];
}

- (MDTile*) tileAtRow: (NSUInteger) row column: (NSUInteger) column
{
    NSParameterAssert(row >= 1);
    NSParameterAssert(column >= 1);
    NSParameterAssert(row <= height);
    NSParameterAssert(column <= width);

    MDTile* t = [[tiles objectAtIndex: row - 1] objectAtIndex: column - 1];
    return (t == [NSNull null] ? nil: t);
}

- (void) removeTileAtRow: (NSUInteger) row column: (NSUInteger) column
{
    [[tiles objectAtIndex: row - 1] setObject: [NSNull null] atIndex: column - 1];
}

#pragma mark - Movements

- (NSArray*) treat:(NSMutableArray *)line
{
    NSMutableArray* newLine = [NSMutableArray arrayWithCapacity: width];
    int k = 0;
    for(int i = 0; i < width; ++i){
        if([line objectAtIndex: i] != nil){
            [newLine setObject: [line objectAtIndex: i] atIndexedSubscript: k];
            ++k;
        }
    }
    for(; k < width; ++k){ [newLine setObject: [NSNull null] atIndexedSubscript: k]; }

    MDTile* current, *next;
    for(int i = 0; i < width - 1; ++i){
        current = [newLine objectAtIndex: i];
        next = [newLine objectAtIndex: i + 1];
        if(current == [NSNull null]){
            if(next != [NSNull null]){
                [newLine setObject: next atIndexedSubscript: i];
            } else {
                [newLine setObject: [NSNull null] atIndexedSubscript: i];
            }
            [newLine setObject: [NSNull null] atIndexedSubscript: i + 1];
            continue;
        }
        if([current canCombineWith: next]){
            [newLine setObject: [current combineWith: next] atIndexedSubscript: i];
            [newLine setObject: [NSNull null] atIndexedSubscript: i + 1];
        }
    }
    return [newLine copy];
}

- (void) swipeToTheLeft
{
    int row = 0, column = 0;
    NSMutableArray* line;
    NSArray* newLine;
    MDTile* tile;
    for(row = 0; row < height; ++row){
        line = [NSMutableArray arrayWithCapacity: width];
        for(column = 0; column < width; ++column){
            tile = [self tileAtRow: row + 1 column: column + 1];
            if(tile != nil){
                [line setObject: tile atIndexedSubscript: column];
            } else {
                [line setObject: [NSNull null] atIndexedSubscript: column];
            }
        }
        newLine = [self treat: line];
        for(column = 0; column < width; ++column){
            [self putTile: [newLine objectAtIndex: column] row: row + 1 column: column + 1];
        }
    }
}

- (void) swipeToTheTop
{
    int row = 0, column = 0;
    NSMutableArray* line;
    NSArray* newLine;
    MDTile* tile;

    for(column = 0; column < width; ++column){
        line = [NSMutableArray arrayWithCapacity: height];
        for(row = 0; row < height; ++row){
            tile = [self tileAtRow: row + 1 column: column + 1];
            if(tile != nil){
                [line setObject: tile atIndexedSubscript: row];
            } else {
                [line setObject: [NSNull null] atIndexedSubscript: row];
            }
        }
        newLine = [self treat: line];
        for(row = 0; row < height; ++row){
            [self putTile: [newLine objectAtIndex: row] row: row + 1 column: column + 1];
        }
    }
}


- (void) swipeToTheRight
{
    int row = 0, column = 0;
    NSMutableArray* line;
    NSArray* newLine;
    MDTile* tile;
    for(row = 0; row < height; ++row){
        line = [NSMutableArray arrayWithCapacity: width];
        for(column = width - 1; column >= 0; --column){
            tile = [self tileAtRow: row + 1 column: column + 1];
            if(tile != nil){
                [line setObject: tile atIndexedSubscript: width - column - 1];
            } else {
                [line setObject: [NSNull null] atIndexedSubscript: width - column - 1];
            }
        }
        newLine = [self treat: line];
        for(column = 0; column < width; ++column){
            [self putTile: [newLine objectAtIndex: width - column - 1] row: row + 1 column: column + 1];
        }
    }
}

- (void) swipeToTheBottom
{
    int row = 0, column = 0;
    NSMutableArray* line;
    NSArray* newLine;
    MDTile* tile;

    for(column = 0; column < width; ++column){
        line = [NSMutableArray arrayWithCapacity: height];
        for(row = height - 1; row >= 0; --row){
            tile = [self tileAtRow: row + 1 column: column + 1];
            if(tile != nil){
                [line setObject: tile atIndexedSubscript: height - row - 1];
            } else {
                [line setObject: [NSNull null] atIndexedSubscript: height - row - 1];
            }
        }
        newLine = [self treat: line];
        for(row = 0; row < height; ++row){
            [self putTile: [newLine objectAtIndex: height - row - 1] row: row + 1 column: column + 1];
        }
    }

}

@end
