//
//  SwitchCell.m
//  Yelp
//
//  Created by Jagtej Sodhi on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *switchValueChanged;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (void) setOn:(BOOL) on {
    [self.toggleSwitch setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated: (BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

@end
