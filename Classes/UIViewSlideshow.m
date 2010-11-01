//
//  UIViewSlideshow.m
//  slideshow
//
//  Created by Sander van de Graaf on 02-11-10.
//  Copyright 2010 Sanoma Digital. All rights reserved.
//

#import "UIViewSlideshow.h"


@implementation UIViewSlideshow


- (id)initWithFrame:(CGRect)frame 
{
	return [super initWithFrame:frame];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
	NSLog(@"UIViewSlideshow touchesEnd");
	// If not dragging, send event to next responder
	if (!self.dragging)
	{
		NSLog(@"foobar");
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	}
	else
	{
		[super touchesEnded: touches withEvent: event];
	}
}

@end