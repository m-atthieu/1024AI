//
//  MDTile.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDTile.h"

@implementation MDTile
@synthesize number;

- (id) initWithNumber: (NSUInteger) aNumber
{
    self = [super init];
    if(self){
        number = aNumber;
    }
    return self;
}

- (MDTile*) combineWith: (MDTile*) aTile
{
    return [[MDTile alloc] initWithNumber: number + [aTile number]];
}

- (BOOL) canCombineWith: (MDTile*) aTile
{
    return number == [aTile number];
}
@end
