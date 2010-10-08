//
//  slideshowAppDelegate.h
//  slideshow
//
//  Created by Sander van de Graaf on 29-09-10.
//  Copyright 2010 Sanoma Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class slideshowViewController;

@interface slideshowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    slideshowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet slideshowViewController *viewController;

@end

