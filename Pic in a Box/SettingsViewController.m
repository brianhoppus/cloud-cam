//
//  SettingsViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "SettingsViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SettingsViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertController *syncFolderAlert;
@property (strong, nonatomic) NSString *uploadPath;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setAccountStatusForButton:self.dropboxLinkButton];
    [self loadUserDefaultSetting:@"networkSyncSetting" forButton:self.syncSettingButton];
    [self loadUserDefaultSetting:@"resolutionSetting" forButton:self.resolutionPickerButton];
}

- (void)setAccountStatusForButton:(UIButton *)button {
    if ([[DBSession sharedSession] isLinked]) {
        [button setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"Connect to Dropbox" forState:UIControlStateNormal];
    }
}

- (void)loadUserDefaultSetting:(NSString *)setting forButton:(UIButton *)button {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:setting]) {
        NSString *storedSetting = [userDefaults stringForKey:setting];
        [button setTitle:storedSetting forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveSettingForButton:self.syncSettingButton withKey:@"networkSyncSetting"];
    [self saveSettingForButton:self.resolutionPickerButton withKey:@"resolutionSetting"];
}

- (void)saveSettingForButton:(UIButton *)button withKey:(NSString *)key {
    NSString *buttonValue = button.titleLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:buttonValue forKey:key];
}

- (IBAction)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)connectToDropbox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        [self.dropboxLinkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [self.dropboxLinkButton setTitle:@"Connect to Dropbox" forState:UIControlStateNormal];
    }
}

- (IBAction)chooseSyncFolder:(id)sender {
    self.syncFolderAlert = [UIAlertController alertControllerWithTitle:@"Choose Sync Folder"
                                                               message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *textField = self.syncFolderAlert.textFields[0];
                                                   NSString *newSyncFolder = textField.text;
                                                   [[NSUserDefaults standardUserDefaults] setObject:newSyncFolder forKey:@"syncFolder"];
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:NULL];
    
    [self.syncFolderAlert addAction:cancel];
    [self.syncFolderAlert addAction:ok];
    
    [self.syncFolderAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"syncFolder"]) {
            NSString *syncFolder = [userDefaults stringForKey:@"syncFolder"];
            textField.placeholder = syncFolder;
        } else {
            textField.placeholder = @"/Apps/Pic in a Box/";
        }
    }];
    
    [self presentViewController:self.syncFolderAlert animated:YES completion:NULL];
}

- (IBAction)changeNetworkSyncSetting:(id)sender {
    if ([self.syncSettingButton.titleLabel.text isEqualToString:@"Sync Over WiFi Only"]) {
        [self.syncSettingButton setTitle:@"Sync Over WiFi and Cellular" forState:UIControlStateNormal];
    } else {
        [self.syncSettingButton setTitle:@"Sync Over WiFi Only" forState:UIControlStateNormal];
    }
}

- (IBAction)changePictureResolution:(id)sender {
    if ([self.resolutionPickerButton.titleLabel.text isEqualToString:@"Enable Hi-Resolution"]) {
        [self.resolutionPickerButton setTitle:@"Disable Hi-Resolution" forState:UIControlStateNormal];
    } else {
        [self.resolutionPickerButton setTitle:@"Enable Hi-Resolution" forState:UIControlStateNormal];
    }
}



@end
