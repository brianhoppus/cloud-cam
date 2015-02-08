//
//  CameraViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 2/7/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *cameraDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSError *error;
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    
    self.cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.cameraDevice error:&error];
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.width, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelPhotograph:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)captureImage:(id)sender {
    // This works the oposite of what you'd think.
    // The button starts out labeled as "Capture", you take a picture, and then the button is relabled "Upload".
    // Hitting the button again will upload the image, and dismiss the view controller.
    if (![self.captureButton.titleLabel.text  isEqual: @"Capture"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.captureButton setTitle:@"Upload" forState:UIControlStateNormal];
        [self.captureButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    }
}
@end
