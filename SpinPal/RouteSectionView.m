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
	_secondsTextField.text = [NSString stringWithFormat:@"%i:%.2i", mins, secs];
	_rpmTextField.text = [NSString stringWithFormat:@"%li", (long)_section.rpm];
	_jumpCountTextField.text = [NSString stringWithFormat:@"%li", (long)_section.jumpCount];
	[_rightSideButton setTitle:(_section.rightSide)?@"R":@"L" forState:UIControlStateNormal];
	[_iconButton setBackgroundImage:_section.icon forState:UIControlStateNormal];
	[self hideLabels];
}

- (IBAction)switchLeftRight:(UIButton *)sender {
	_section.rightSide = !_section.rightSide;
	[_rightSideButton setTitle:(_section.rightSide)?@"R":@"L" forState:UIControlStateNormal];
}

- (void)hideLabels {
	_secondsTextField.hidden = _section.type==RouteTypeNone;
	_rpmTextField.hidden = _section.type==RouteTypeNone;
	
	_jumpCountTextField.hidden = _section.type!=RouteTypeJump;
	_rightSideButton.hidden = _section.type!=RouteTypeJump;
}

//Ignore undeclared selector warnings
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (void)initialize {
//	Load .xib
	[[NSBundle mainBundle] loadNibNamed:@"RouteSectionView" owner:self options:nil];
	self.bounds = self.view.bounds;
	
	[self.iconButton addTarget:[self superview] action:@selector(openNewSectionView:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.view];
}
#pragma clang diagnostic pop
//End ignore

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initialize];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self initialize];
	}
	return self;
}

@end