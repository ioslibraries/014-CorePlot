//
//  ILAppDelegate.h
//  PlotApp
//
//  Created by jeremy Templier on 22/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILCustomViewController;

@interface ILAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ILCustomViewController *viewController;
@end
