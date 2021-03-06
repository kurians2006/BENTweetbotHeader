//
//  BENMainController.m
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import "BENMainController.h"

#import "BENMainView.h"
#import "BENProfileView.h"

@interface BENMainController ()

@property BENMainView *mainView;

@end

@implementation BENMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.translucent = NO;
	UIColor *offWhite = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
	self.navigationController.navigationBar.barTintColor = offWhite;
	self.title = @"Ben Packard";

	self.view.backgroundColor = [UIColor darkGrayColor];
	
	self.mainView = [[BENMainView alloc] init];
	self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.mainView];
	NSDictionary *views = @{@"main":self.mainView};
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[main]|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main]|" options:0 metrics:nil views:views]];
	
	self.mainView.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y > 0) return; //other wise things will shrink/darken etc as the user scrolls UP
	
	//move the center of the image
	self.mainView.headerCenterYConstraint.constant = scrollView.contentOffset.y / 2.0;

	//scale up the image, but only after the overlap is revealed
	BOOL shouldExpand = self.mainView.profileView.frame.size.height + -scrollView.contentOffset.y > self.mainView.headerImage.image.size.height;
	CGFloat overlap = self.mainView.headerImage.image.size.height - self.mainView.profileView.frame.size.height;
	CGFloat additionalHeight = shouldExpand ? -scrollView.contentOffset.y - overlap : 0;
	self.mainView.headerHeightConstraint.constant = self.mainView.headerImage.image.size.height + additionalHeight;

	
	//fade the header content
	CGFloat fadingRange = 70;
	self.mainView.profileView.alpha = 1.0 - -scrollView.contentOffset.y/fadingRange;
	
	//hide the blurred image
	self.mainView.blurredImage.alpha = 1.0 - -scrollView.contentOffset.y/fadingRange;
}

- (void)dealloc
{
	self.mainView.scrollView.delegate = nil;
}

@end
