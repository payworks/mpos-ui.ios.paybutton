/*
 * mpos-ui : http://www.payworks.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MPUSettingsController.h"
#import "MPUMposUi_Internal.h"
#import "MPUUIHelper.h"
#import "MPUApplicationData.h"

@interface MPUSettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *loggedInAsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loggedInAsDetail;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionDetail;

@end

@implementation MPUSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loggedInAsDetail.text = self.username;
    self.versionDetail.text = [MPUMposUi version];
    [self l10n];
}

- (void)l10n {
    self.versionLabel.text = [MPUUIHelper localizedString:@"MPUVersion"];
    self.loggedInAsLabel.text = [MPUUIHelper localizedString:@"MPULoggedInAs"];
    self.logoutLabel.text = [MPUUIHelper localizedString:@"MPULogout"];
    self.helpLabel.text = [MPUUIHelper localizedString:@"MPUHelp"];
}

- (void)logout {
    [self.mposUi clearMerchantCredentialsIncludingUsername:NO];
    [self.delegate logoutPressed];
}

#pragma mark - Tableview methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self logout];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:self.mposUi.applicationData.helpUrl];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    } else if(section == 1) {
        return [MPUUIHelper localizedString:@"MPUInfo"];
    } else {
        return @"";
    }
}

@end
