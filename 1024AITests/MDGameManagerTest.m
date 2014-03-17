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
  grid = nil;
  [super tearDown];
}

- (void) testCanInsertRandomTiles
{
  [grid random: 2];
  XCTAssertEquals(grid.filled, 2, @"");
  [grid random: 1];
  XCTAssertEquals(grid.filled, 3, @"");
}

- (void) testNotGameOverWhenNotFilled
{
  XCTAssertFalse([grid isGameOver], @"");
}

- (void) testNotGameOverWhenFilledButCanSwipe
{
  [grid putTile: 2 row: 1 column: 1];
  [grid putTile: 2 row: 1 column: 2];
  [grid putTile: 2 row: 2 column: 1];
  [grid putTile: 2 row: 2 column: 2];
  XCTAssertFalse([grid isGameOver], @"");
}

- (void) testGameOverWhenFilledAndCannotSwipe
{
  [grid putTile: 2 row: 1 column: 1];
  [grid putTile: 4 row: 1 column: 2];
  [grid putTile: 8 row: 2 column: 1];
  [grid putTile: 16 row: 2 column: 2];
  XCTAssertTrue([grid isGameOver], @"");
}

- (void) testCanSwipeToLeft
{
  [grid putTile: 2 row: 1 column: 1];
  [grid putTile: 2 row: 1 column: 2];
  XCTAssertTrue([grid canSwipeToLeft], @"");
}

@end
