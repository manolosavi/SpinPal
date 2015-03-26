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
		case RouteTypeStraight:
			return [UIImage imageNamed:@"straight"];
		case RouteTypeJump:
			return [UIImage imageNamed:@""];
		case RouteTypeStand:
			return [UIImage imageNamed:@""];
		case RouteTypeUpStand:
			return [UIImage imageNamed:@""];
		case RouteTypeUpSit:
			return [UIImage imageNamed:@""];
	}
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
		self.repetitions = [decoder decodeIntegerForKey:@"repetitions"];
		self.resistance = [decoder decodeIntegerForKey:@"resistance"];
		self.rightSide = [decoder decodeBoolForKey:@"rightSide"];
		self.type = [decoder decodeIntegerForKey:@"type"];
		self.icon = [self getImage:self.type];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInteger:self.seconds forKey:@"seconds"];
	[encoder encodeInteger:self.rpm forKey:@"rpm"];
	[encoder encodeInteger:self.repetitions forKey:@"repetitions"];
	[encoder encodeInteger:self.resistance forKey:@"resistance"];
	[encoder encodeBool:self.rightSide forKey:@"rightSide"];
	[encoder encodeInteger:self.type forKey:@"type"];
}

@end