//
//  MDSwipeTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 16/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTile.h"
#import "MDGrid.h"

@interface MDSwipeTest : XCTestCase
{
    MDGrid* grid;
    MDTile* tile1;
    MDTile* tile2;
    MDTile* tile3;
}
@end

@implementation MDSwipeTest

- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 2 andHeight: 2];
    tile1 = [[MDTile alloc] initWithNumber: 2];
    tile2 = [[MDTile alloc] initWithNumber: 2];
    tile3 = [[MDTile alloc] initWithNumber: 4];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testSwipeToLeftCombineTwoTiles
{
    [grid putTile: tile1 row: 1 column: 1];
    [grid putTile: tile2 row: 1 column: 2];
    [grid putTile: tile2 row: 2 column: 2];
    [grid swipeToTheLeft];
    XCTAssertTrue([[grid tileAtRow: 1 column: 1] number] == 4, @"");
    XCTAssertNil([grid tileAtRow: 1 column: 2], @"combine remove tiles");
}

- (void) testSwipeToRightCombineTwoTiles
{
    [grid putTile: tile1 row: 1 column: 1];
    [grid putTile: tile2 row: 1 column: 2];
    [grid swipeToTheRight];
    XCTAssertTrue([[grid tileAtRow: 1 column: 2] number] == 4, @"");
    XCTAssertNil([grid tileAtRow: 1 column: 1], @"combine remove tiles");
}

- (void) testSwipeToUpCombineTwoTiles
{
    [grid putTile: tile1 row: 1 column: 1];
    [grid putTile: tile2 row: 2 column: 1];
    [grid swipeToTheTop];
    XCTAssertTrue([[grid tileAtRow: 1 column: 1] number] == 4, @"");
    XCTAssertNil([grid tileAtRow: 2 column: 1], @"combine remove tiles");
}

- (void) testSwipeToDownCombineTwoTiles
{
    [grid putTile: tile1 row: 1 column: 1];
    [grid putTile: tile2 row: 2 column: 1];
    [grid swipeToTheBottom];
    NSLog(@"%@", grid);
    XCTAssertTrue([[grid tileAtRow: 2 column: 1] number] == 4, @"");
    XCTAssertNil([grid tileAtRow: 1 column: 1], @"combine remove tiles");
}

@end
