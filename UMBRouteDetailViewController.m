//
//  UMBRouteDetailViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 10/11/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBRouteDetailViewController.h"
#import "UMBXMLDataModel.h"


@interface UMBRouteDetailViewController () {
    NSArray* _stops;
    NSMutableDictionary* _toaDict;
}

@end

@implementation UMBRouteDetailViewController

- (id)initWithRoute:(NSDictionary*)route {
    self = [super initWithStyle:UITableViewStylePlain];
    if ( self ) {
        UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl setTintColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [refreshControl addTarget:self action:@selector(refreshDataModel:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:kRefreshedDataModelNotificationName object:nil];
        
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        //_stops = [[UMBXMLDataModel defaultXMLDataModel] getStopsForRouteWithName:routeName];
        
        
        _stops = route[@"stop"];
        _toaDict = [NSMutableDictionary new];
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return [_stops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *title = _stops[indexPath.row][@"name2"];
    
    //NSString* subtitle = @"12 minutes and 40 seconds";
    //NSString* subtitle = _stops[indexPath.row][@"toa1"];
    NSString* toaCountStr = _stops[indexPath.row][@"toacount"];
    NSInteger toaCount = [toaCountStr integerValue];
    NSInteger min = NSIntegerMax;
    for ( int i = 0; i < toaCount; i++ ) {
        NSString* accessString = [NSString stringWithFormat:@"toa%d", i + 1];
        NSString* toaStr = _stops[indexPath.row][accessString];
        NSInteger toaInt = (NSInteger)[toaStr doubleValue];
        if ( min > toaInt ) {
            min = toaInt;
        }
        [_toaDict setObject:[NSNumber numberWithInteger:toaInt] forKey:accessString];
    }
    
    NSString* subtitle = [NSString stringWithString:[self timeFormattedStringFrom:min]];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    // Configure the cell...
    return cell;
}

- (NSString*)timeFormattedStringFrom:(NSInteger)integer_in {
    NSInteger minutes = integer_in / 60;
    NSInteger seconds = integer_in % 60;
    
    return [NSString stringWithFormat:@"%d min", minutes];
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
