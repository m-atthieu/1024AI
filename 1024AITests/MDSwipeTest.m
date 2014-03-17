//
//  MDSwipeTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 16/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface MDSwipeTest : XCTestCase
{
    MDGrid* grid;
}
@end

@implementation MDSwipeTest

- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 2 andHeight: 2];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testSwipeToLeftCombineTwoTiles
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid putTile: 2 row: 2 column: 2];
    [grid swipeToTheLeft];
    XCTAssertTrue([grid tileAtRow: 1 column: 1] == 4, @"");
    XCTAssertEqual([grid tileAtRow: 1 column: 2], kEmptyTile, @"combine remove tiles");
}

- (void) testSwipeToRightCombineTwoTiles
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, grid);
    [grid swipeToTheRight];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, grid);
    XCTAssertTrue([grid tileAtRow: 1 column: 2] == 4, @"");
    XCTAssertEqual([grid tileAtRow: 1 column: 1], kEmptyTile, @"combine remove tiles");
}

- (void) testSwipeToUpCombineTwoTiles
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheTop];
    XCTAssertTrue([grid tileAtRow: 1 column: 1] == 4, @"");
    XCTAssertEqual([grid tileAtRow: 2 column: 1], kEmptyTile, @"combine remove tiles");
}

- (void) testSwipeToDownCombineTwoTiles
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheBottom];
    NSLog(@"%@", grid);
    XCTAssertTrue([grid tileAtRow: 2 column: 1] == 4, @"");
    XCTAssertEqual([grid tileAtRow: 1 column: 1], kEmptyTile, @"combine remove tiles");
}

@end
