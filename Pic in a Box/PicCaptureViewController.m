//
//  PicCaptureViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/30/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "PicCaptureViewController.h"
#import "SettingsViewController.h"
#import "SendPicViewController.h"

@interface PicCaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation PicCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)openCamera:(id)sender {
    // Create and display image picker
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //create and display upload view
    SendPicViewController *sendPicControlller = [[SendPicViewController alloc] init];
    sendPicControlller.modalTransitionStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sendPicControlller animated:YES completion:NULL];
}

- (IBAction)openSetttings:(id)sender {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:settingsViewController animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
