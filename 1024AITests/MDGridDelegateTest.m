//
//  MDGridDelegateTest.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//
#import <XCTest/XCTest.h>

#import "MDGrid.h"
#import "MDGridScene.h"

@interface FakeDelegate : NSObject <MDGridMovementDelegate>
@property (assign) BOOL moveWasCalled;
@property (assign) BOOL changeWasCalled;
@property (assign) BOOL appearWasCalled;
@end

@implementation FakeDelegate
@synthesize moveWasCalled, changeWasCalled, appearWasCalled;
- (id) init 
{
    if(self = [super init]){
	moveWasCalled   = NO;
	changeWasCalled = NO;
	appearWasCalled = NO;
    }
    return self;
}
- (void) grid: (MDGrid*) grid tileAtRow: (NSUInteger) row1 column: (NSUInteger) column1 movedToRow: (NSUInteger) row2 column: (NSUInteger) column2
{
    moveWasCalled = YES;
}

- (void) grid: (MDGrid*) grid tileAtRow: (NSUInteger) row column: (NSUInteger) column changedTo: (MDTile) tile
{
    changeWasCalled = YES;
}

- (void) grid: (MDGrid*) grid tile: (MDTile) tile appearedAtRow: (NSUInteger) row column: (NSUInteger) column
{
    appearWasCalled = YES;
}
@end

@interface MDGridDelegateTest : XCTestCase
{
    MDGrid* grid;
    FakeDelegate* delegate;
}
@end

@implementation MDGridDelegateTest

- (void)setUp
{
    [super setUp];
    grid = [[MDGrid alloc] initWithWidth: 2 andHeight: 2];
    delegate = [[FakeDelegate alloc] init];
    grid.delegate = delegate;
    delegate.grid = grid;
}

- (void)tearDown
{
    grid.delegate = nil;
    grid = nil;
    delegate.grid = nil;
    delegate = nil;
    [super tearDown];
}

- (void) testSwipeToLeftGeneratesMovement
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheLeft];
    XCTAssertTrue([delegate moveWasCalled], @"");
}

- (void) testSwipeToLeftGeneratesMovement
{
    [grid putTile: 4 row: 1 column: 1];
    [grid putTile: 2 row: 1 column: 2];
    [grid swipeToTheRight];
    XCTAssertFalse([delegate moveWasCalled], @"");
}

- (void) testSwipeToTopGeneratesMovement
{
    [grid putTile: 2 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheTop];
    XCTAssertTrue([delegate moveWasCalled], @"");
}

- (void) testSwipeToBottomGeneratesNoMovement
{
    [grid putTile: 4 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    [grid swipeToTheBottom];
    XCTAssertFalse([delegate moveWasCalled], @"");
}

@end
