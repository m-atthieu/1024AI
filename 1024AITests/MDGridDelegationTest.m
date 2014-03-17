//
//  MDGridDelegationTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 17/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MDGrid.h"

@interface FakeDelegate : NSObject <MDGridMovementDelegate>
@property (assign) BOOL moveWasCalled;
@property (assign) BOOL changeWasCalled;
@property (assign) BOOL appearWasCalled;
@property (strong) NSMutableArray* moves;
@property (strong) NSMutableArray* appears;
@property (strong) NSMutableArray* changes;
@end

@implementation FakeDelegate
@synthesize moveWasCalled, changeWasCalled, appearWasCalled;
@synthesize moves, appears, changes;
- (id) init
{
    if(self = [super init]){
        moveWasCalled = NO;
        changeWasCalled = NO;
        appearWasCalled = NO;
        moves = [NSMutableArray arrayWithCapacity: 4];
        appears = [NSMutableArray array];
        changes = [NSMutableArray array];
    }
    return self;
}
- (void) grid:(MDGrid *)grid tileAtRow:(NSUInteger)row column:(NSUInteger)column changedTo:(MDTile)tile
{
    changeWasCalled = YES;
    [changes addObject: [NSString stringWithFormat: @"change %d %d -> %d", row, column, tile]];
}
- (void) grid:(MDGrid *)grid tile:(MDTile)tile appearedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    appearWasCalled = YES;
    [appears addObject: [NSString stringWithFormat: @"appear %d = %d %d", tile, row, column]];
}
- (void) grid:(MDGrid *)grid tileAtRow:(NSUInteger)row1 column:(NSUInteger)column1 movedToRow:(NSUInteger)row2 column:(NSUInteger)column2
{
    moveWasCalled = YES;
    [moves addObject: [NSString stringWithFormat: @"move %d %d => %d %d", row1, column1, row2, column2]];
}
@end

@interface MDGridDelegationTest : XCTestCase
{
    MDGrid* grid;
    FakeDelegate* delegate;
}
@end

@implementation MDGridDelegationTest

- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 2 andHeight: 2];
    delegate = [[FakeDelegate alloc] init];
    grid.delegate = delegate;
}

- (void)tearDown
{
    grid.delegate = nil;
    delegate = nil;
    [super tearDown];
}

- (void) testSwipeToLeftCallsMove
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheLeft];
    XCTAssertTrue([delegate moveWasCalled], @"");
}

- (void) testSwipe2
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheLeft];
    XCTAssertEqual([delegate.moves count], 1, @"");
    NSString* expected = @"move 1 2 => 1 1";
    XCTAssertEqualObjects([delegate.moves objectAtIndex: 0], expected, @"");
}

- (void) testSwipe3
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheRight];
    XCTAssertEqual([delegate.moves count], 1, @"");
    NSString* expected = @"move 1 1 => 1 2";
    XCTAssertEqualObjects([delegate.moves objectAtIndex: 0], expected, @"");
}

- (void) testSwipe4
{
    [grid addRandomTiles: 2];
    XCTAssertEqual([delegate.appears count], 2, @"");
}

- (void) testSwipe5
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheLeft];
    XCTAssertEqual([delegate.changes count], 1, @"");
    NSString* expected = @"change 1 1 -> 4";
    XCTAssertEqualObjects([delegate.changes objectAtIndex: 0], expected, @"");
}

- (void) testSwipe6
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheRight];
    XCTAssertEqual([delegate.changes count], 1, @"");
    NSString* expected = @"change 1 2 -> 4";
    XCTAssertEqualObjects([delegate.changes objectAtIndex: 0], expected, @"");
}

- (void) testSwipe7
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheTop];
    NSString* expectedChange = [NSString stringWithFormat: @"change 1 1 -> 4"],
            * expectedMove   = [NSString stringWithFormat: @"move 2 1 => 1 1"];
    XCTAssertEqual([delegate.changes count], 1, @"");
    NSLog(@"%@", delegate.changes);
    XCTAssertEqualObjects([delegate.changes objectAtIndex: 0], expectedChange, @"");
    XCTAssertEqual([delegate.moves count], 1, @"");
    XCTAssertEqualObjects([delegate.moves objectAtIndex: 0], expectedMove, @"");

}

- (void) testSwipe8
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheBottom];
    NSString* expectedChange = [NSString stringWithFormat: @"change 2 1 -> 4"],
            * expectedMove   = [NSString stringWithFormat: @"move 1 1 => 2 1"];
    XCTAssertEqual([delegate.changes count], 1, @"");
    XCTAssertEqualObjects([delegate.changes objectAtIndex: 0], expectedChange, @"");
    XCTAssertEqual([delegate.moves count], 1, @"");
    XCTAssertEqualObjects([delegate.moves objectAtIndex: 0], expectedMove, @"");

}

@end
