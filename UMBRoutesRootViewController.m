//
//  UMBRoutesRootViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/13/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBRoutesRootViewController.h"
#import "UMBXMLDataModel.h"
#import "UIColor+VFAdditions.h"
#import "UMBRouteDetailViewController.h"
#import "UMBDeveloperCreditViewController.h"

@interface UMBRoutesRootViewController () {
    NSArray* _routesArray;
}

@end

@implementation UMBRoutesRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl setTintColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [refreshControl addTarget:self action:@selector(refreshDataModel:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:kRefreshedDataModelNotificationName object:nil];
        
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _routesArray = [[UMBXMLDataModel defaultXMLDataModel] getActiveRoutes];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}

- (void)refreshDataModel:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAskForRefreshNotificationName object:nil];
}

- (void)reloadTableViewData:(id)sender {
    [self.refreshControl endRefreshing];
    _routesArray = [[UMBXMLDataModel defaultXMLDataModel] getActiveRoutes];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_routesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( !cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *title = [_routesArray[indexPath.row] valueForKey:@"name"];
    NSString *color = [_routesArray[indexPath.row] valueForKey:@"busroutecolor"];
    UIColor *textColor = [UIColor colorWithHexString:color];
    
    cell.textLabel.text = title;
    [cell.textLabel setTextColor:textColor];
    
    // Configure the cell...
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UMBRouteDetailViewController* detailViewController = [[UMBRouteDetailViewController alloc] initWithRouteWithName:_routesArray[indexPath.row]];
    
    //UMBDeveloperCreditViewController* viewController = [[UMBDeveloperCreditViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



@end
