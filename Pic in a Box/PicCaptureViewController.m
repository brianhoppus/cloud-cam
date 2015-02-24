//
//  PicCaptureViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/30/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "PicCaptureViewController.h"
#import "SettingsViewController.h"

@interface PicCaptureViewController ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) DBRestClient *restClient;
@property (strong, nonatomic) NSDate *dateOfPicture;

@end

@implementation PicCaptureViewController

# pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    self.cameraButton.layer.cornerRadius = 4;
    self.cameraButton.layer.borderWidth = 1;
    self.cameraButton.layer.borderColor = (__bridge CGColorRef)(self.cameraButton.backgroundColor);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBActions

- (IBAction)openCamera:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (IBAction)openSetttings:(id)sender {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:settingsViewController animated:YES completion:NULL];
}

# pragma mark - UIIMagePickerController

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = info[UIImagePickerControllerOriginalImage];
    self.dateOfPicture = [NSDate date];
    [self uploadPicture:self.image];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Dropbox API's

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    [self displayUploadError];
}

#pragma mark - Private

- (void)uploadPicture:(UIImage *)image {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [[NSData alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"resolutionSetting"]) {
        if ([[userDefaults stringForKey:@"resolutionSetting"] isEqualToString:@"Enable Hi-Resolution"]) {
            data = UIImageJPEGRepresentation(image, 0.66);
        } else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy HH.mm.ss"];
    NSString *fileName = [dateFormat stringFromDate:self.dateOfPicture];
    NSString *fileNameWithExtension = [fileName stringByAppendingString:@".jpg"];
    NSString *file = [NSTemporaryDirectory() stringByAppendingString:fileNameWithExtension];
    
    [data writeToFile:file atomically:YES];
    
    // Upload to Dropbox
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"syncFolder"]) {
        NSString *destinationDir = [userDefaults stringForKey:@"syncFolder"];
        
        [self.restClient uploadFile:fileNameWithExtension
                             toPath:destinationDir
                      withParentRev:nil
                           fromPath:file];
    } else {
        NSString *destinationDir = @"/CloudCam";
        [self.restClient uploadFile:fileNameWithExtension
                             toPath:destinationDir
                      withParentRev:nil
                           fromPath:file];
    }
}

- (void)displayUploadError {
    UIAlertController *uploadErrorAlert = [UIAlertController alertControllerWithTitle:@"Uh-oh!"
                                                                              message:@"Something went wrong trying to upload the last picture."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
        [self uploadPicture:self.image];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:NULL];
    [uploadErrorAlert addAction:cancel];
    [uploadErrorAlert addAction:retry];
    [self presentViewController:uploadErrorAlert animated:YES completion:NULL];
}

@end
