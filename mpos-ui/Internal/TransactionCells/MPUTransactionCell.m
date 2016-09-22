//
//  MPUTransactionCellTableViewCell.m
//  mpos-ui
//
//  Created by Leonid Popescu on 01/09/16.
//  Copyright © 2016 payworks. All rights reserved.
//

#import "MPUTransactionCell.h"

@implementation MPUTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hideSeparatorView:(BOOL)hide {
    
    self.separatorView.hidden = hide;
}

@end
