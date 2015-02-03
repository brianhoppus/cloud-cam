//
//  SendPicViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "SendPicViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SendPicViewController () <UITextFieldDelegate, DBRestClientDelegate>

@property (strong, nonatomic) DBRestClient *restClient;

@end

@implementation SendPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    self.nameField.delegate = self;
    
    [self setButtonStyle:self.uploadButton];
    [self setButtonStyle:self.cancelButton];
    
    self.uploadButton.layer.cornerRadius = 4;
    self.uploadButton.layer.borderWidth = 1;
    self.uploadButton.layer.borderColor = (__bridge CGColorRef)(self.uploadButton.backgroundColor);
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = (__bridge CGColorRef)(self.cancelButton.backgroundColor);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageView.image = self.image;
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }

    return self;
}

- (IBAction)uploadPicture:(id)sender {
    NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
    NSString *fileNameWithExtention = @"";
    
    if ([self.nameField.text isEqualToString:@""]) {
        fileNameWithExtention = [self.nameField.text stringByAppendingString:@"NoName.png"];
    } else {
        fileNameWithExtention = [self.nameField.text stringByAppendingString:@".png"];
    }

    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:fileNameWithExtention];
    [data writeToFile:file atomically:YES];
    
    // Upload to Dropbox
    NSString *destinationDir = @"/";
    [self.restClient uploadFile:fileNameWithExtention
                         toPath:destinationDir
                  withParentRev:nil
                       fromPath:file];
}

- (IBAction)cancelUpload:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelInput:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameField resignFirstResponder];
    return YES;
}

- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setButtonStyle:(UIButton *)button
{
    button.layer.cornerRadius = 2;
    button.layer.borderWidth = 1;
    button.layer.borderColor = (__bridge CGColorRef)(button.backgroundColor);
}

@end
