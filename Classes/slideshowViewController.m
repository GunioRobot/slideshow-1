//
//  slideshowViewController.m
//  slideshow
//
//  Created by Sander van de Graaf on 29-09-10.
//  Copyright 2010 Sanoma Digital. All rights reserved.
//

#import "slideshowViewController.h"

@implementation slideshowViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize labelBox;
@synthesize pageWidth;
@synthesize pageHeight;
@synthesize imagesLoaded;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	labelBox.text = @"Image: 0";
	self.pageWidth = scrollView.frame.size.width;
	self.pageHeight = scrollView.frame.size.height;
	self.imagesLoaded = false;
//	[self setupPage];
    [super viewDidLoad];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSLog(@"rotated");
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		self.pageWidth = 1024;
		self.pageHeight = 704;
		NSLog(@"Landscape: %fX%f", self.pageWidth, self.pageHeight);
	}
	else {
		self.pageWidth = 768;
		self.pageHeight = 960;
		NSLog(@"Portrait: %fX%f", self.pageWidth, self.pageHeight);
	}

	[self setupPage];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[scrollView release];
	[pageControl release];
	[labelBox release];
}


- (void)dealloc {
    [super dealloc];
}

- (void)setupPage
{
	scrollView.delegate = self;

	// cleanup any old stuff
	for (UIView *subview in scrollView.subviews) {
		[subview removeFromSuperview];
	}
	
	NSLog(@"width: %f", self.pageWidth);
	
	// set the scrollview, only allow horizontal scrolling
	[self.scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	//scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.alwaysBounceHorizontal = YES;
	scrollView.alwaysBounceVertical = NO;
	scrollView.directionalLockEnabled = YES;
	
	// create X amount of imageviews, and add them to the scrollview
	NSUInteger nimages = 0;
	
	for (; ;nimages++) {
		if (nimages == 10) {
			break;
		}
		
		NSLog(@"Loading image...");
		
		// create the image
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://media.nu.nl/m/m1fzob6al98j.jpg"]]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		[imageView setBackgroundColor:[UIColor blackColor]];

		// scale the image automatically within the frame
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		// create the frame in which the image should fit, depending on the orientation
		imageView.frame = CGRectMake((self.pageWidth * nimages), 0, self.pageWidth,self.pageHeight);
		
		// add it to the view
		[scrollView addSubview:imageView];
		[imageView release];
	}

	// set number of images
	self.pageControl.numberOfPages = nimages;
	
	// set the amount of scrollable content
	[scrollView setContentSize:CGSizeMake(nimages * self.pageWidth, self.pageHeight - 200)];
	NSLog(@"Contentsize: %f", nimages*self.pageWidth);
	
	// auto resizing of objects for rotating
	scrollView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.imagesLoaded = true;
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	labelBox.text = [NSString stringWithFormat: @"Image: %d", page];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	NSLog(@"pageChanged");
	labelBox.text = @"foobar";

	/*
	 *	Change the scroll view
	 */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;

    [scrollView scrollRectToVisible:frame animated:YES];
	
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
}

@end