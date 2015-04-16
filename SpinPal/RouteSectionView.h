//
//  RouteSectionView.h
//  SpinPal
//
//  Created by manolo on 3/25/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSection.h"

@interface RouteSectionView : UIView

///Section to display on the view.
@property RouteSection *section;

///The view itself.
@property (strong, nonatomic) IBOutlet UIView *view;

///@c TextField to display the section's seconds in m:ss format.
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;

///@c TextField to display the section's RPMs.
@property (weak, nonatomic) IBOutlet UITextField *rpmTextField;

///@c TextField to display the section's jump count, if appropiate.
@property (weak, nonatomic) IBOutlet UITextField *jumpCountTextField;

///Button to display 'R' or 'L' based on the section's rightSide value.
@property (weak, nonatomic) IBOutlet UIButton *rightSideButton;

///Button to display the section's image.
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

/**
 Loads the data from the section into the view.
 */
- (void)loadData;

/**
 Switches the @c rightSide value on the section and updates the @c rightSideButton's title.
 */
- (IBAction)switchLeftRight:(UIButton *)sender;

/**
 Shows or hides the appropiate labels for the view's section.
 */
- (void)hideLabels;

@end