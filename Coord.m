//
//  Coord.m
//
//  Created by John Saba on 11/8/14.

#import "Coord.h"

CGFloat const kDefaultUnitWidth = 50.0f;
CGFloat const kDefaultUnitHeight = 50.0f;

NSString *const kDirectionNorth = @"N";
NSString *const kDirectionEast = @"E";
NSString *const kDirectionSouth = @"S";
NSString *const kDirectionWest = @"W";

NSString *const kDirectionNorthWest = @"NW";
NSString *const kDirectionNorthEast = @"NE";
NSString *const kDirectionSouthWest = @"SW";
NSString *const kDirectionSouthEast = @"SE";

@implementation Coord

+ (id)coordWithX:(NSInteger)x Y:(NSInteger)y
{
  return [[Coord alloc] initWithX:x Y:y];
}

- (id)initWithX:(NSInteger)x Y:(NSInteger)y
{
  self = [super init];
  if (self)
  {
    self.x = x;
    self.y = y;
  }
  return self;
}

#pragma mark - position

+ (Coord*)coordForRelativePosition:(CGPoint)position
{
  return [Coord coordForRelativePosition:position unitSize:CGSizeMake(kDefaultUnitWidth, kDefaultUnitHeight)];
}

+ (Coord*)coordForRelativePosition:(CGPoint)position unitSize:(CGSize)unitSize
{
  return [Coord coordWithX:floorf(position.x / unitSize.width) Y:floorf(position.y / unitSize.height)];
}

- (CGPoint)relativePosition
{
  return [self relativePositionWithUnitSize:CGSizeMake(kDefaultUnitWidth, kDefaultUnitHeight)];
}

- (CGPoint)relativePositionWithUnitSize:(CGSize)unitSize
{
  return CGPointMake(self.x * unitSize.width, self.y * unitSize.height);
}

- (CGPoint)relativeMidpoint
{
  return [self relativeMidpointWithUnitSize:CGSizeMake(kDefaultUnitWidth, kDefaultUnitHeight)];
}

- (CGPoint)relativeMidpointWithUnitSize:(CGSize)unitSize
{
  CGPoint position = [self relativePositionWithUnitSize:unitSize];
  return CGPointMake(position.x + unitSize.width / 2.0f, position.y + unitSize.height / 2.0f);
}

#pragma mark - converts

+ (Coord*)coordFromArray:(NSArray*)array
{
  return [Coord coordWithX:[array[0] integerValue] Y:[array[1] integerValue]];
}

+ (NSArray*)coordsFromArrays:(NSArray*)arrays
{
  NSMutableArray* coords = [NSMutableArray array];
  for (NSArray* a in arrays)
  {
    [coords addObject:[Coord coordFromArray:a]];
  }
  return [NSArray arrayWithArray:coords];
}

+ (NSArray*)arraysFromCoords:(NSArray*)coords
{
  NSMutableArray* arrays = [NSMutableArray array];
  for (Coord* c in coords)
  {
    [arrays addObject:@[[NSNumber numberWithInteger:c.x], [NSNumber numberWithInteger:c.y]]];
  }
  return [NSArray arrayWithArray:arrays];
}

- (NSArray*)arrayRepresentation;
{
  return @[[NSNumber numberWithInteger:self.x], [NSNumber numberWithInteger:self.y]];
}

#pragma mark - compare

+ (Coord*)maxCoord:(NSArray*)coords
{
  NSInteger xMax = 0;
  NSInteger yMax = 0;
  
  for (Coord *c in coords)
  {
    xMax = MAX(xMax, c.x);
    yMax = MAX(yMax, c.y);
  }
  return [Coord coordWithX:xMax Y:yMax];
}

+ (Coord*)minCoord:(NSArray*)coords
{
  NSInteger xMin = NSIntegerMax;
  NSInteger yMin = NSIntegerMax;
  
  for (Coord* c in coords)
  {
    xMin = MIN(xMin, c.x);
    yMin = MIN(yMin, c.y);
  }
  return [Coord coordWithX:xMin Y:yMin];
}

- (BOOL)isEqualToCoord:(Coord*)coord
{
  return ((self.x == coord.x) && (self.y == coord.y));
}

- (BOOL)isCoordInGroup:(NSArray*)coords
{
  for (Coord* c in coords)
  {
    if ([c isEqualToCoord:self])
    {
      return YES;
    }
  }
  return NO;
}

#pragma mark - context

+ (NSArray*)cardinalDirections
{
  return @[kDirectionNorth, kDirectionSouth, kDirectionEast, kDirectionWest];
}

+ (NSArray*)ordinalDirections
{
  return @[kDirectionNorthWest, kDirectionNorthEast, kDirectionSouthWest, kDirectionSouthEast];
}

+ (NSString*)oppositeDirection:(NSString*)direction
{
  if ([direction isEqualToString:kDirectionNorth])
  {
    return kDirectionSouth;
  }
  else if ([direction isEqualToString:kDirectionEast])
  {
    return kDirectionWest;
  }
  else if ([direction isEqualToString:kDirectionSouth])
  {
    return kDirectionNorth;
  }
  else if ([direction isEqualToString:kDirectionWest])
  {
    return kDirectionEast;
  }
  else if ([direction isEqualToString:kDirectionNorthEast])
  {
      return kDirectionSouthWest;
  }
  else if ([direction isEqualToString:kDirectionNorthWest])
  {
      return kDirectionSouthEast;
  }
  else if ([direction isEqualToString:kDirectionSouthEast])
  {
      return kDirectionNorthWest;
  }
  else if ([direction isEqualToString:kDirectionSouthWest])
  {
      return kDirectionNorthEast;
  }
  else
  {
    CCLOG(@"Coord warning: unrecognized direction");
    return nil;
  }
}

- (NSDictionary*)cardinalNeighbors
{
  return [self cardinalNeighborsWithDistance:1];
}

- (NSDictionary*)cardinalNeighborsWithDistance:(NSInteger)distance
{
  return @{kDirectionWest : [Coord coordWithX:self.x - distance Y:self.y],
           kDirectionEast : [Coord coordWithX:self.x + distance Y:self.y],
           kDirectionNorth : [Coord coordWithX:self.x Y:self.y + distance],
           kDirectionSouth : [Coord coordWithX:self.x Y:self.y - distance]};
}

- (BOOL)isCardinalNeighbor:(Coord*)coord
{
  NSUInteger index = [[[self cardinalNeighbors] allValues] indexOfObjectPassingTest:^BOOL(Coord *neighbor, NSUInteger idx, BOOL *stop) {
    return [coord isEqualToCoord:neighbor];
  }];
  return index != NSNotFound;
}

- (BOOL)isNorthOf:(Coord*)coord
{
  Coord* above = [[coord cardinalNeighbors] objectForKey:kDirectionNorth];
  return [self isEqualToCoord:above];
}

- (BOOL)isSouthOf:(Coord*)coord
{
  Coord* below = [[coord cardinalNeighbors] objectForKey:kDirectionSouth];
  return [self isEqualToCoord:below];
}

- (BOOL)isWestOf:(Coord*)coord
{
  Coord* left = [[coord cardinalNeighbors] objectForKey:kDirectionWest];
  return [self isEqualToCoord:left];
}

- (BOOL)isEastOf:(Coord*)coord
{
  Coord* right = [[coord cardinalNeighbors] objectForKey:kDirectionEast];
  return [self isEqualToCoord:right];
}

- (NSDictionary*)ordinalNeighbors
{
  return [self oridnalNeighborsWithDistance:1];
}

- (NSDictionary*)oridnalNeighborsWithDistance:(NSInteger)distance
{
  return @{kDirectionNorthWest : [Coord coordWithX:self.x - distance Y:self.y + distance],
           kDirectionNorthEast : [Coord coordWithX:self.x + distance Y:self.y + distance],
           kDirectionSouthWest : [Coord coordWithX:self.x - distance Y:self.y - distance],
           kDirectionSouthEast : [Coord coordWithX:self.x + distance Y:self.y - distance]};
}

- (Coord*)stepInDirection:(NSString*)direction
{
    for (NSString* d in [Coord cardinalDirections])
    {
        if ([d isEqualToString:direction])
        {
            return [self cardinalNeighbors][direction];
        }
    }
    for (NSString* d in [Coord ordinalDirections])
    {
        if ([d isEqualToString:direction])
        {
            return [self ordinalNeighbors][direction];
        }
    }
    return nil;
}

- (Coord*)stepInDirection:(NSString*)direction until:(BOOL (^)(Coord* coord))condition
{
  return [Coord stepInDirection:direction until:condition from:self];
}

+ (Coord*)stepInDirection:(NSString*)direction until:(BOOL (^)(Coord* coord))condition from:(Coord*)from
{
  if (condition(from))
  {
    return from;
  }
  return [self stepInDirection:direction until:condition from:[from stepInDirection:direction]];
}

#pragma mark - Debug

- (NSString *)stringRep
{
  return [NSString stringWithFormat:@"( %i, %i )", self.x, self.y];
}

@end