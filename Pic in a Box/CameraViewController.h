//
//  CameraViewController.h
//  Pic in a Box
//
//  Created by Brian Saunders on 2/7/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *captureButton;

- (IBAction)cancelPhotograph:(id)sender;
- (IBAction)captureImage:(id)sender;

@end
