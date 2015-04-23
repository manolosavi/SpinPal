//
//  SavedRoutesTableViewController.m
//  SpinPal
//
//  Created by Luis Gerardo on 4/23/15.
//  Copyright (c) 2015 manolosavi. All rights reserved.
//

#import "SavedRoutesTableViewController.h"

@interface SavedRoutesTableViewController ()

@end

@implementation SavedRoutesTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_routes = [[NSMutableArray alloc] initWithObjects:nil];
	_routes = [self getRoutes];

	NSLog(@"%@", _route);
	

	 self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _routes.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
//	cell.textLabel.text = [[_routes objectAtIndex:indexPath.row] objectAtIndex:0];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[_routes removeObjectAtIndex:indexPath.row];
		[self saveRoutes];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[_route insertObject:@"hi" atIndex:0];
		[_routes addObject:_route];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSMutableArray *temp = [_routes objectAtIndex:fromIndexPath.row];
	[_routes removeObjectAtIndex:fromIndexPath.row];
	[_routes insertObject:temp atIndex:toIndexPath.row];
	[self saveRoutes];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
	if (selected != nil) {
		NSMutableArray *newRoute = [[NSMutableArray alloc] initWithArray:_routes[selected.row]];
		[newRoute removeObjectAtIndex:0];
		_route = newRoute;
	}
}

#pragma mark - Saving / Loading

- (NSString *)routesFilename {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"routes.plist"];
}

- (NSMutableArray *)getRoutes {
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self routesFilename]];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	NSArray *recordedPresets = [unarchiver decodeObjectForKey:@"routes"];
	
	return [[NSMutableArray alloc] initWithArray:recordedPresets copyItems:NO];
}

- (BOOL)saveRoutes {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_routes forKey:@"routes"];
	[archiver finishEncoding];
	return [data writeToFile:[self routesFilename] atomically:true];
}

@end
