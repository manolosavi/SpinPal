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
	
	NSLog(@"%ld", (long)_section.type);
	_titles = [[NSArray alloc] initWithObjects:@"Straight Stand", @"Straight Sit", @"Jump", @"Uphill Stand", @"Uphill Sit", @"Race Stand", @"Race Sit", @"Sprint", @"Sprint Uphill", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//	Configure the cell...
	cell.textLabel.text = _titles[indexPath.row];
	cell.imageView.image = [[RouteSection alloc] getImage:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_section = [[RouteSection alloc] initWithRouteType:indexPath.row];
	[self performSegueWithIdentifier:@"unwindChooseSectionType" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[[segue destinationViewController] setChangeSectionType:_section];
}

@end