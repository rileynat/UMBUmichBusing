//
//  UMBClosestScrollViewController.m
//  UMBUMichBusing
//
//  Created by Nathan Riley on 1/4/14.
//  Copyright (c) 2014 Nathan Riley. All rights reserved.
//

#import "UMBClosestScrollViewController.h"
#import "UMBXMLDataModel.h"
#import "UMBStopDetailRootViewController.h"

@interface UMBClosestScrollViewController () {
    int _currentPageNumber;
    int _totalPageNumber;
    NSArray* _stopNameArray;
    BOOL pageControlBeingUsed;
    NSMutableArray* _viewControllers;
}

@end

@implementation UMBClosestScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _stopNameArray = [[UMBXMLDataModel defaultXMLDataModel] getStopsNameArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    NSUInteger numberPages = [_stopNameArray count];
    
    NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    
    _viewControllers = controllers;
    
    pageControlBeingUsed = YES;
    _stopNameArray = [[UMBXMLDataModel defaultXMLDataModel] getStopsNameArray];
    [self.view setFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:[UIColor clearColor]];
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    [_scrollView setDelegate:self];
    
    //_pageControl = [[UIPageControl alloc] initWithFrame:self.scrollView.frame];
    //[_pageControl setNumberOfPages:numberPages];
    //[_pageControl setCurrentPage:0];
    //[_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //[_pageControl setPageIndicatorTintColor:[UIColor clearColor]];
    //[_pageControl setCurrentPageIndicatorTintColor:[UIColor clearColor]];
//    for (int i = 0; i < _routeNameArray.count; i++) {
//        CGRect frame;
//        frame.origin.x = self.scrollView.frame.size.width * i;
//        frame.origin.y = 10;
//        frame.size = self.scrollView.frame.size;
//        frame.size.height = self.scrollView.frame.size.height - 20;
//        
//        UMBStopDetailRootViewController *subviewController = [[UMBStopDetailRootViewController alloc] initWithStopName:_routeNameArray[i]];
//        [subviewController.view setFrame:frame];
//        [subviewController.view setBackgroundColor:[UIColor blueColor]];
//        [self.scrollView addSubview:subviewController.view];
//    }
    
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _routeNameArray.count, self.scrollView.frame.size.height);
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    [self.view addSubview:_scrollView];
    [self.view sendSubviewToBack:_scrollView];
    //[self.view addSubview:_pageControl];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= _stopNameArray.count)
        return;
    
    // replace the placeholder if necessary
    UMBStopDetailRootViewController *controller = [_viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[UMBStopDetailRootViewController alloc] initWithStopName:_stopNameArray[page]];
        [_viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //self.pageControl.currentPage = page;
    [self gotoPage:YES];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    [self.view sendSubviewToBack:_scrollView];

    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
