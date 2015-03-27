//
//  RouteSection.m
//  SpinPal
//
//  Created by manolo on 3/23/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "RouteSection.h"

@implementation RouteSection

- (UIImage *)getImage:(RouteType)type {
	switch (type) {
		case RouteTypeNone:
			return [UIImage imageNamed:@"addSection"];
		case RouteTypeStraightStand:
			return [UIImage imageNamed:@"straightStand"];
		case RouteTypeStraightSit:
			return [UIImage imageNamed:@"straightSit"];
		case RouteTypeJump:
			return [UIImage imageNamed:@"jump"];
		case RouteTypeUpStand:
			return [UIImage imageNamed:@"upStand"];
		case RouteTypeUpSit:
			return [UIImage imageNamed:@"upSit"];
		case RouteTypeRaceStand:
			return [UIImage imageNamed:@"raceStand"];
		case RouteTypeRaceSit:
			return [UIImage imageNamed:@"raceSit"];
		case RouteTypeSprint:
			return [UIImage imageNamed:@"sprint"];
		case RouteTypeSprintUp:
			return [UIImage imageNamed:@"sprintUp"];
	}
}

- (void)changeIcon {
	self.icon = [self getImage:_type];
}

- (instancetype)initWithRouteType:(RouteType)type {
	if (self = [super init]) {
		self.type = type;
		self.icon = [self getImage:type];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.seconds = [decoder decodeIntegerForKey:@"seconds"];
		self.rpm = [decoder decodeIntegerForKey:@"rpm"];
		self.jumpCount = [decoder decodeIntegerForKey:@"jumpCount"];
		self.rightSide = [decoder decodeBoolForKey:@"rightSide"];
		self.type = [decoder decodeIntegerForKey:@"type"];
		self.icon = [self getImage:self.type];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:self.seconds forKey:@"seconds"];
	[encoder encodeInteger:self.rpm forKey:@"rpm"];
	[encoder encodeInteger:self.jumpCount forKey:@"jumpCount"];
	[encoder encodeBool:self.rightSide forKey:@"rightSide"];
	[encoder encodeInteger:self.type forKey:@"type"];
}

@end