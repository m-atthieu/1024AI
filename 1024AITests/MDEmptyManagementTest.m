//
//  MDEmptyManagementTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 17/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface MDInspectableGrid : MDGrid
- (NSSet*) emptySet;
@end

@implementation MDInspectableGrid
- (NSSet*) emptySet
{
    return [[self performSelector: @selector(empty)] copy];
}
@end

@interface MDEmptyManagementTest : XCTestCase
@property (strong) MDInspectableGrid* grid;
@end

@implementation MDEmptyManagementTest
@synthesize grid;

- (void)setUp
{
    [super setUp];
    grid = [[MDInspectableGrid alloc] initWithWidth: 2 andHeight: 2];
}

- (void)tearDown
{
    grid = nil;
    [super tearDown];
}

- (void) testEmpty1
{
    [grid putTile: 2 row: 1 column: 1];
    XCTAssertEqual([[grid emptySet] count], 3, @"");
}

- (void) testEmpty2
{
    [grid addRandomTiles: 2];
    XCTAssertEqual([[grid emptySet] count], 2, @"");
}

@end
