//
//  SettingsViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "SettingsViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[DBSession sharedSession] isLinked]) {
        [self.dropboxLinkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    } else {
        [self.dropboxLinkButton setTitle:@"Link to Dropbox" forState:UIControlStateNormal];
    }
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

- (IBAction)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)connectToDropbox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        [self.dropboxLinkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [self.dropboxLinkButton setTitle:@"Link to Dropbox" forState:UIControlStateNormal];
    }
}
@end
