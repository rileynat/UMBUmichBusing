//
//  UMBRootTabBarViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 9/13/13.
//  Copyright (c) 2013 Nathan Riley. All rights reserved.
//

#import "UMBRootTabBarViewController.h"
#import "UMBDeveloperCreditViewController.h"
#import "UMBRoutesRootViewController.h"
#import "UMBStopsTableViewController.h"

@interface UMBRootTabBarViewController ()

@end

@implementation UMBRootTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	 //Do any additional setup after loading the view.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.developerViewController = [[UMBDeveloperCreditViewController alloc] initWithNibName:@"UMBDeveloperCreditViewController_iPhone" bundle:nil];
    } else {
        self.developerViewController = [[UMBDeveloperCreditViewController alloc] initWithNibName:@"UMBDeveloperCreditViewController_iPad" bundle:nil];
    }
    [_developerViewController setTitle:@"Developer"];
    
    _routesRootViewController = [[UMBRoutesRootViewController alloc] initWithStyle:UITableViewStylePlain];
    [_routesRootViewController setTitle:@"Routes"];
    
    _stopsTableViewController = [[UMBStopsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [_stopsTableViewController setTitle:@"Stops"];
    
    
    [self setViewControllers:[NSArray arrayWithObjects:_routesRootViewController, _developerViewController, nil]];
    [self setSelectedViewController:_routesRootViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
