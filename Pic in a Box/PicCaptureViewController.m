//
//  PicCaptureViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/30/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "PicCaptureViewController.h"
#import "SettingsViewController.h"
#import "CameraViewController.h"

@interface PicCaptureViewController ()

@property (strong, nonatomic) UIImage *image;

@end

@implementation PicCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cameraButton.layer.cornerRadius = 4;
    self.cameraButton.layer.borderWidth = 1;
    self.cameraButton.layer.borderColor = (__bridge CGColorRef)(self.cameraButton.backgroundColor);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCamera:(id)sender {
    CameraViewController *cameraViewController = [[CameraViewController alloc] init];
    [self presentViewController:cameraViewController animated:YES completion:NULL];
}

- (IBAction)openSetttings:(id)sender {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:settingsViewController animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
