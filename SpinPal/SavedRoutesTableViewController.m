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

BOOL hasSaved = false;
BOOL selected = false;

- (void)viewDidLoad {
	[super viewDidLoad];
	_routes = [[NSMutableArray alloc] initWithObjects:nil];
	_routes = [self getRoutes];

	 self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
	
	if (oldIndex.row == indexPath.row && selected) {
		selected = false;
		[self.tableView deselectRowAtIndexPath:oldIndex animated:NO];
		[self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
		return nil;
	} else {
		selected = true;
		[self.tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
		[self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
		[self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	return indexPath;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self isEditing] && !hasSaved && _route.count > 1)?_routes.count+1:_routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    if ([self isEditing] && indexPath.row == _routes.count) {
        cell.textLabel.text = @"+";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
		UIGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addRoute:)];
		UIGestureRecognizer *longTapAdd = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addRoute:)];
		[cell addGestureRecognizer:tapAdd];
		[cell addGestureRecognizer:longTapAdd];
	} else {
		cell.textLabel.text = [[_routes objectAtIndex:indexPath.row] objectAtIndex:0];
		cell.textLabel.textAlignment = NSTextAlignmentLeft;
		while (cell.gestureRecognizers.count != 0) {
			UIGestureRecognizer *recognizer = [cell.gestureRecognizers objectAtIndex:0];
			[cell removeGestureRecognizer:recognizer];
		}
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
//		Delete the row from the data source
		[_routes removeObjectAtIndex:indexPath.row];
		[self saveRoutes];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)addRoute:(UIGestureRecognizer*)gestureRecognizer {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Route name"
													message:nil
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Save", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[_route insertObject:[alertView textFieldAtIndex:0].text atIndex:0];
		NSArray *route = [[NSArray alloc] initWithArray:_route];
		[_routes addObject:route];
		hasSaved = true;
		[self saveRoutes];
		[self.tableView reloadData];
	} else {
		hasSaved = false;
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	while (self.tableView.indexPathForSelectedRow != nil) {
		[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow].accessoryType = UITableViewCellAccessoryNone;
		[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:false];
	}
	[super setEditing:editing animated:animated];
	[self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEditing] && indexPath.row == _routes.count) {
		return false;
	} else {
		return true;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.tableView.editing && indexPath.row == _routes.count) {
		return UITableViewCellEditingStyleNone;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
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
	if (hasSaved) {
		[_route removeObjectAtIndex:0];
	}
	if (selected != nil) {
		if (selected) {
			NSMutableArray *newRoute = [[NSMutableArray alloc] initWithArray:_routes[selected.row]];
			[newRoute removeObjectAtIndex:0];
			_route = newRoute;
			[(ViewController*)segue.destinationViewController setShouldReload:true];
		}
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
