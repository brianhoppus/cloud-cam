//
//  CameraViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 2/7/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DropboxSDK/DropboxSDK.h"

@interface CameraViewController () <DBRestClientDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *cameraDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) BOOL imageCaptured;
@property (strong, nonatomic) DBRestClient *restClient;
@property (strong, nonatomic) NSDate *dateOfPicture;

@end

@implementation CameraViewController

#pragma mark  Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;

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
    [self.previewLayer setFrame:CGRectMake(0, 93, 375, 482)];
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *resolutionSetting = [userDefaults stringForKey:@"resolutionSetting"];
    if ([resolutionSetting isEqualToString:@"Disable Hi-Resolution"]) {
        self.stillImageOutput.highResolutionStillImageOutputEnabled = YES;
    } else {
        self.stillImageOutput.highResolutionStillImageOutputEnabled = NO;
    }

    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBActions

- (IBAction)cancelPhotograph:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)captureImage:(id)sender {
    // This works the oposite of what you'd think.
    // The button starts out labeled as "Capture", you take a picture, and then the button is relabled "Upload".
    // Hitting the button again will upload the image, and dismiss the view controller.
    if (![self.captureButton.titleLabel.text  isEqual: @"Capture"]) {
        [self uploadPicture:self.image];
    } else {
        [self.captureButton setTitle:@"Upload" forState:UIControlStateNormal];
        [self.captureButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        
        AVCaptureConnection *videoConnection = nil;
       
        for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) {
                break;
            }
        }
        
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                           completionHandler:
         ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
             if (imageDataSampleBuffer != NULL) {
                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                              self.image = [UIImage imageWithData:imageData];
                              self.imageView.image = self.image;
             }
         }];

        self.dateOfPicture = [NSDate date];
    }
}

#pragma mark - Private

- (void)uploadPicture:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy HH.mm.ss"];
    NSString *fileName = [dateFormat stringFromDate:self.dateOfPicture];
    NSString *fileNameWithExtension = [fileName stringByAppendingString:@".jpg"];
    NSString *file = [NSTemporaryDirectory() stringByAppendingString:fileNameWithExtension];
    
    [data writeToFile:file atomically:YES];
    
    // Upload to Dropbox
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"syncFolder"]) {
        NSString *destinationDir = [userDefaults stringForKey:@"syncFolder"];
        
        [self.restClient uploadFile:fileNameWithExtension
                             toPath:destinationDir
                      withParentRev:nil
                           fromPath:file];
    } else {
        NSString *destinationDir = @"/Apps/Pic in a Box";
        [self.restClient uploadFile:fileNameWithExtension
                             toPath:destinationDir
                      withParentRev:nil
                           fromPath:file];
    }
}

- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
