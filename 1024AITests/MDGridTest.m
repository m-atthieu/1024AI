//
//  MDGridTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//
#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface MDGridTest : XCTestCase
{
    MDGrid* grid;
}
@end

@implementation MDGridTest

- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 4 andHeight: 4];
}

- (void)tearDown
{
    grid = nil;
    [super tearDown];
}

- (void) testGridHasDimension
{
    XCTAssert([grid width] == 4, @"width is 4");
    XCTAssert([grid height] == 4, @"height is 4");
}

- (void) testTileCanBePlacedOnGrid
{
    XCTAssertNoThrow([grid putTile: 2 row: 1 column: 1], @"tile can be placed on the grid");
}

- (void) testGridIsOneIndexed
{
    XCTAssertThrows([grid putTile: 2 row: 0 column: 0], @"first row is 1, first column is 1");
}

- (void) testCanRemoveTileFromGrid
{
    [grid putTile: 2 row: 1 column: 1];
    [grid removeTileAtRow: 1 column: 1];
    XCTAssertEqual([grid tileAtRow: 1 column: 1], kEmptyTile, @"empty cell is nil");
}

- (void) testGridCanTellWichTileIsWhere
{
    [grid putTile: 2 row: 1 column: 1];
    XCTAssertEqual([grid tileAtRow: 1 column: 1], 2, @"??");
}

- (void) testGridHasDescription
{
    MDGrid* grid2 = [[MDGrid alloc] initWithWidth: 2 andHeight: 2];
    [grid2 putTile: 2 row: 1 column: 1];
    [grid2 putTile: 2 row: 2 column: 1];
    NSString* expected = @"2 0 ;2 0 ;";
    NSString* desc = [grid2 description];
    XCTAssertTrue([desc isEqualToString: expected], @"");

}
@end
