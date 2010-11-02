//
//  slideshowViewController.m
//  slideshow
//
//  Created by Sander van de Graaf on 29-09-10.
//  Copyright 2010 Sanoma Digital. All rights reserved.
//

#import "slideshowViewController.h"
#import "UIViewSlideshow.h"

@implementation slideshowViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize pageWidth;
@synthesize pageHeight;
@synthesize loadingIndicator;
@synthesize imageDescription;
@synthesize images;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
//	imageDescription.text = @"Image: 0";
	self.pageWidth = scrollView.frame.size.width;
	self.pageHeight = scrollView.frame.size.height;
	self.images = [NSArray arrayWithObjects:@"http://media.nu.nl/m/m1fzob6al98j.jpg", @"http://media.nu.nl/m/m1fzqegaqfre_700.jpg", @"http://media.nu.nl/m/m1fzqf6adfr5_700.jpg", @"http://img148.imageshack.us/img148/9136/foobar6xn.jpg",nil];
	
	// set uiwebview transparent
	UIColor * transparentBlack = [[UIColor alloc] initWithRed:0/0.
														green:0/0.
														 blue:0/0.
														alpha:0.3
								  ];
	[self.imageDescription setBackgroundColor:transparentBlack];

	
    [super viewDidLoad];
	
//	[self setupPage];
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
	[imageDescription release];
//	[labelBox release];
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
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	
	// create X amount of imageviews, and add them to the scrollview
	NSUInteger nimages = 0;
	
	for (; ;nimages++) {
		if (nimages == 4) {
			break;
		}
		
		NSLog(@"Loading image...");
		
		// create the image
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.images objectAtIndex:nimages]]]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		[imageView setBackgroundColor:[UIColor blackColor]];

		// scale the image automatically within the frame
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		// calculate whether the image should be centered (if image smaller than the available width)
		imageView.frame = CGRectMake((self.pageWidth * nimages), 23, self.pageWidth,self.pageHeight);
		
		// add it to the view
		[scrollView addSubview:imageView];
		[imageView release];
	}

	// set number of images
	self.pageControl.numberOfPages = nimages;
	
	// set the amount of scrollable content
	[scrollView setContentSize:CGSizeMake(nimages * self.pageWidth, self.pageHeight)];
	NSLog(@"Contentsize: %f", nimages*self.pageWidth);
	
	// auto resizing of objects for rotating
	scrollView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	NSLog(@"stop animating");
	[loadingIndicator stopAnimating];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
	// We switch page at 50% across
    CGFloat windowWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - windowWidth / 2) / windowWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
	NSLog(@"finished scrolling");
	NSString* foobar = @"<p style='color:white;'>foobar!</p>";
	[self.imageDescription loadHTMLString:foobar baseURL:[NSURL URLWithString:@""]];
    pageControlIsChangingPage = NO;
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
	if(imageDescription.hidden == YES)
	{
		imageDescription.hidden = NO;
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	}
	else {
		imageDescription.hidden = YES;
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	}
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	NSLog(@"pageChanged");

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