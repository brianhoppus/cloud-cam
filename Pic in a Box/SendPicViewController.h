//
//  SendPicViewController.h
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPicViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

- (IBAction)uploadPicture:(id)sender;
- (IBAction)cancelUpload:(id)sender;
- (instancetype)initWithImage:(UIImage *)image;

@end
