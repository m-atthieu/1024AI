//
//  MDTile.h
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kEmptyTile ([NSNull null])

@interface MDTile : NSObject
@property (assign, readonly) NSUInteger number;
- (id) initWithNumber: (NSUInteger) aNumber;
- (MDTile*) combineWith: (MDTile*) aTile;
- (BOOL) canCombineWith: (MDTile*) aTile;
@end
