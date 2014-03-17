//
//  MDSwipe3x3Test.m
//  1024AI
//
//  Created by Matthieu DESILE on 17/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface MDSwipe3x3Test : XCTestCase
@property (strong) MDGrid* grid;
@end

@implementation MDSwipe3x3Test
@synthesize grid;
- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 3 andHeight: 3];
}

- (void)tearDown
{
    grid = nil;
    [super tearDown];
}

- (void) testSwipe1
{
    [grid putTile: 2 row: 1 column: 2];
    [grid putTile: 2 row: 1 column: 3];
    [grid swipeToTheLeft];
    XCTAssertEqual([grid tileAtRow: 1 column: 1], 4, @"");
    XCTAssertEqual([grid tileAtRow: 1 column: 2], kEmptyTile, @"");
    XCTAssertEqual([grid tileAtRow: 1 column: 3], kEmptyTile, @"");
}
@end
