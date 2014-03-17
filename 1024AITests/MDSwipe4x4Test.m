//
//  MDSwipe4x4Test.m
//  1024AI
//
//  Created by Matthieu DESILE on 17/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface MDSwipe4x4Test : XCTestCase
@property (strong) MDGrid* grid;
@end

@implementation MDSwipe4x4Test
@synthesize grid;

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

- (void)testSwipe1
{
    [grid putTile: 2 row: 1 column: 2];
    [grid putTile: 2 row: 1 column: 4];
    [grid swipeToTheLeft];
    XCTAssertEqual([grid tileAtRow: 1 column: 1], 4, @"");
}

@end
