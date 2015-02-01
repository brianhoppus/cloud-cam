//
//  PicCaptureViewController.h
//  Pic in a Box
//
//  Created by Brian Saunders on 1/30/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCaptureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)openCamera:(id)sender;
- (IBAction)openSetttings:(id)sender;

@end
