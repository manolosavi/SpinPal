//
//  RouteSectionView.m
//  SpinPal
//
//  Created by manolo on 3/25/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "RouteSectionView.h"

@implementation RouteSectionView

- (void)loadData {
	int mins = _section.seconds/60;
	int secs = (int)_section.seconds%60;
	_secondsLabel.text = [NSString stringWithFormat:@"%i:%i", mins, secs];
	_rpmLabel.text = [NSString stringWithFormat:@"%li", _section.rpm];
	_jumpCountLabel.text = [NSString stringWithFormat:@"%li", _section.jumpCount];
	_rightSideLabel.text = (_section.rightSide)?@"R":@"L";
	[_iconImageView setImage:_section.icon];
	[self hideLabels];
}

- (void)hideLabels {
	_secondsLabel.hidden = _section.type==RouteTypeNone;
	_rpmLabel.hidden = _section.type==RouteTypeNone;
	
	_jumpCountLabel.hidden = _section.type!=RouteTypeJump;
	_rightSideLabel.hidden = _section.type!=RouteTypeJump;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
//		Load .xib
		[[NSBundle mainBundle] loadNibNamed:@"RouteSectionView" owner:self options:nil];
		self.bounds = self.view.bounds;
		[self addSubview:self.view];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
//		Load .xib
		[[NSBundle mainBundle] loadNibNamed:@"RouteSectionView" owner:self options:nil];
		[self addSubview:self.view];
	}
	return self;
}

@end