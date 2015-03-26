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
	RouteTypeNone		= -1,
	RouteTypeStraight	= 0,
	RouteTypeJump		= 1,
	RouteTypeStand		= 2,
	RouteTypeUpStand		= 3,
	RouteTypeUpSit		= 4
};

@property NSTimeInterval seconds;
@property NSInteger rpm;
@property NSInteger repetitions;
@property NSInteger resistance;
@property BOOL rightSide;
@property RouteType type;
@property (strong) UIImage *icon;

- (instancetype)initWithRouteType:(RouteType)type;

@end