//
//  RouteSection.h
//  SpinPal
//
//  Created by manolo on 3/23/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RouteSection : NSObject <NSCoding>

typedef NS_ENUM(NSInteger, RouteType) {
	RouteTypeNone			= -1,
	RouteTypeStraightStand	= 0,
	RouteTypeStraightSit	= 1,
	RouteTypeJump			= 2,
	RouteTypeUpStand			= 3,
	RouteTypeUpSit			= 4,
	RouteTypeRaceStand		= 5,
	RouteTypeRaceSit			= 6,
	RouteTypeSprint			= 7,
	RouteTypeSprintUp		= 8
};

@property NSTimeInterval seconds;
@property NSInteger rpm;
@property NSInteger jumpCount;
@property NSInteger intensity;
@property BOOL rightSide;
@property RouteType type;
@property (strong) UIImage *icon;


- (void)changeIcon;
- (instancetype)initWithRouteType:(RouteType)type;
- (UIImage *)getImage:(RouteType)type;

@end