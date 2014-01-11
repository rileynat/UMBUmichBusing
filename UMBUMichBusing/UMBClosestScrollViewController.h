//
//  UMBClosestScrollViewController.h
//  UMBUMichBusing
//
//  Created by Nathan Riley on 1/4/14.
//  Copyright (c) 2014 Nathan Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMBClosestScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) UIPageControl* pageControl;

@end
