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

/**
 Defines the type of @c RouteSection.
 
 @c SectionTypeNone: No type, used as a New Section button.
 
 @c SectionTypeStraightStand: Straight section, standing.
 
 @c SectionTypeStraightSit: Straight section, sitting.
 
 @c SectionTypeJump: Jump section.
 
 @c SectionTypeUpStand: Uphill section, standing.
 
 @c SectionTypeUpSit: Uphill section, sitting.
 
 @c SectionTypeRaceStand: Race section, standing.
 
 @c SectionTypeRaceSit: Race section, sitting.
 
 @c SectionTypeSprint: Sprint section.
 
 @c SectionTypeSprintUp	: Sprint section, uphill.
 */
typedef NS_ENUM(NSInteger, SectionType) {
	SectionTypeNone				= -1,
	SectionTypeStraightStand	= 0,
	SectionTypeStraightSit		= 1,
	SectionTypeJump				= 2,
	SectionTypeUpStand			= 3,
	SectionTypeUpSit				= 4,
	SectionTypeRaceStand		= 5,
	SectionTypeRaceSit			= 6,
	SectionTypeSprint			= 7,
	SectionTypeSprintUp			= 8
};

///Duration of the section in seconds.
@property NSTimeInterval seconds;

///Number of RPMs to be used in the section.
@property NSInteger rpm;

///Number of jumps in the section.
@property NSInteger jumpCount;

///When appropiate, the intensity of the hill in the section.
@property NSInteger intensity;

///If jups should be on the right or left side in the section.
@property BOOL rightSide;

///The type of section.
@property SectionType type;

///Icon to identify the section.
@property (strong) UIImage *icon;

/**
 Updates the section's icon based on it's type.
 */
- (void)changeIcon;

/**
 Returns the appropiate image for a given type of section.
 @param type Type of section for which you want the image.
 @return Appropiate image based on the type recieved and intensity, if appropiate.
 */
- (UIImage *)getImage:(SectionType)type;

- (instancetype)initWithSectionType:(SectionType)type;

@end