//
//  Coord.h
//
//  Created by John Saba on 11/8/14.

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT CGFloat const kDefaultUnitWidth;
FOUNDATION_EXPORT CGFloat const kDefaultUnitHeight;

FOUNDATION_EXPORT NSString *const kDirectionNorth;
FOUNDATION_EXPORT NSString *const kDirectionEast;
FOUNDATION_EXPORT NSString *const kDirectionSouth;
FOUNDATION_EXPORT NSString *const kDirectionWest;
FOUNDATION_EXPORT NSString *const kDirectionNorthWest;
FOUNDATION_EXPORT NSString *const kDirectionNorthEast;
FOUNDATION_EXPORT NSString *const kDirectionSouthWest;
FOUNDATION_EXPORT NSString *const kDirectionSouthEast;

@interface Coord : NSObject

@property NSInteger x;
@property NSInteger y;

+ (id)coordWithX:(NSInteger)x Y:(NSInteger)y;

#pragma mark - position

+ (Coord*)coordForRelativePosition:(CGPoint)position;
+ (Coord*)coordForRelativePosition:(CGPoint)position unitSize:(CGSize)unitSize;

- (CGPoint)relativePosition;
- (CGPoint)relativePositionWithUnitSize:(CGSize)unitSize;
- (CGPoint)relativeMidpoint;
- (CGPoint)relativeMidpointWithUnitSize:(CGSize)unitSize;

#pragma mark - convert

+ (Coord*)coordFromArray:(NSArray*)array;
+ (NSArray*)coordsFromArrays:(NSArray *)arrays;
+ (NSArray*)arraysFromCoords:(NSArray*)coords;

- (NSArray*)arrayRepresentation;

#pragma mark - compare

+ (Coord*)maxCoord:(NSArray*)coords;
+ (Coord*)minCoord:(NSArray*)coords;

- (BOOL)isEqualToCoord:(Coord*)coord;
- (BOOL)isCoordInGroup:(NSArray*)coords;

#pragma mark - context

+ (NSArray*)cardinalDirections;
+ (NSArray*)ordinalDirections;
+ (NSString*)oppositeDirection:(NSString*)direction;

- (NSDictionary *)cardinalNeighbors;
- (NSDictionary*)cardinalNeighborsWithDistance:(NSInteger)distance;
- (BOOL)isCardinalNeighbor:(Coord*)coord;
- (BOOL)isNorthOf:(Coord*)coord;
- (BOOL)isSouthOf:(Coord*)coord;
- (BOOL)isWestOf:(Coord*)coord;
- (BOOL)isEastOf:(Coord*)coord;

- (NSDictionary*)ordinalNeighbors;
- (NSDictionary*)oridnalNeighborsWithDistance:(NSInteger)distance;

- (Coord*)stepInDirection:(NSString*)direction;
- (Coord*)stepInDirection:(NSString*)direction until:(BOOL (^)(Coord* coord))condition;

#pragma mark - debug

- (NSString *)stringRep;

@end