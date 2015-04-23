//
//  ChooseSectionTypeTableViewController.m
//  SpinPal
//
//  Created by manolo on 4/9/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "ChooseSectionTypeTableViewController.h"

@interface ChooseSectionTypeTableViewController ()

@property NSArray *titles;

@end

@implementation ChooseSectionTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_titles = [[NSArray alloc] initWithObjects:@"Straight Stand", @"Straight Sit", @"Jump", @"Jump", @"Jump", @"Jump", @"Uphill Stand", @"Uphill Stand", @"Uphill Stand", @"Uphill Stand", @"Uphill Sit", @"Uphill Sit", @"Uphill Sit", @"Uphill Sit", @"Race Stand", @"Race Sit", @"Sprint", @"Sprint Uphill", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)getSectionType:(NSInteger)index {
	NSInteger type;
	if (index < 2) {
		type = index;
	} else if (index < 6) {
		type = 2;
	} else if (index < 10) {
		type = 3;
	} else if (index < 14) {
		type = 4;
	} else {
		type = index-9;
	}
	return type;
}

- (NSInteger)getIntensity:(NSInteger)index {
	NSInteger intensity = 0;
	if (index >= 2 && index <= 5) {
		intensity = index-1;
	} else if (index >= 6 && index <= 9) {
		intensity = index-5;
	} else if (index >= 10 && index <= 13) {
		intensity = index-9;
	}
	return intensity;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	[cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18]];
	cell.textLabel.text = _titles[indexPath.row];
	RouteSection *r = [[RouteSection alloc] initWithSectionType:[self getSectionType:indexPath.row]];
	r.intensity = [self getIntensity:indexPath.row];
	cell.imageView.image = [r getImage:r.type];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_section = [[RouteSection alloc] initWithSectionType:[self getSectionType:indexPath.row]];
	_section.intensity = [self getIntensity:indexPath.row];
	[_section changeIcon];
	[self performSegueWithIdentifier:@"unwindChooseSectionType" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[[segue destinationViewController] setChangeSectionType:_section];
}

@end