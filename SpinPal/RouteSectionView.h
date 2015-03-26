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

@property RouteSection *section;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rpmLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)loadData;

@end