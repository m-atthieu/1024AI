//
//  MDTileTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTile.h"

@interface MDTileTest : XCTestCase
{
    MDTile* tile;
}
@end

@implementation MDTileTest

- (void)setUp
{
    [super setUp];
    tile = [[MDTile alloc] initWithNumber: 2];
}

- (void)tearDown
{
    tile = nil;
    [super tearDown];
}

- (void) testTileHasNumber
{
    XCTAssert(tile.number == 2, @"tile has an associated number");
}

- (void) testCanCombineTiles
{
    MDTile* t1 = [[MDTile alloc] initWithNumber: 2];
    MDTile* t2 = [[MDTile alloc] initWithNumber: 2];
    XCTAssert([[t1 combineWith: t2] number] == 4, @"two tiles adds up when combined");
}

- (void) testTwoTilesWithSameNumberCanCombine
{
    MDTile* tile1 = [[MDTile alloc] initWithNumber: 2];
    MDTile* tile2 = [[MDTile alloc] initWithNumber: 2];
    XCTAssertTrue([tile1 canCombineWith: tile2], @"same number, can collide");
}

- (void) testTwoTilesWithoutSameNumberCannotCombine
{
    MDTile* t1 = [[MDTile alloc] initWithNumber: 2];
    MDTile* t2 = [[MDTile alloc] initWithNumber: 4];
    XCTAssertFalse([t1 canCombineWith: t2], @"different number, cannot combine");
}
@end
