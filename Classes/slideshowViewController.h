//
//  slideshowViewController.h
//  slideshow
//
//  Created by Sander van de Graaf on 29-09-10.
//  Copyright 2010 Sanoma Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slideshowViewController : UIViewController
<UIScrollViewDelegate>
{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	IBOutlet UIActivityIndicatorView* loadingIndicator;
	IBOutlet UIWebView* imageDescription;
	BOOL pageControlIsChangingPage;
}

@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic) Float32 pageWidth;
@property (nonatomic) Float32 pageHeight;
@property (nonatomic, retain) UIActivityIndicatorView* loadingIndicator;
@property (nonatomic, retain) UIWebView* imageDescription;

/* for pageControl */
- (IBAction)changePage:(id)sender;

/* internal */
- (void)setupPage;

@end

