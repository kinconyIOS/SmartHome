//
//  JK_LineTableViewCell.m
//  ZNJD2
//
//  Created by he on 14-7-18.
//
//

#import "JK_LineTableViewCell.h"

@interface JK_LineTableViewCell()
@property (nonatomic,strong)Equip *equip;
@end
@implementation JK_LineTableViewCell

- (void)awakeFromNib
{
    // Initialization code
   // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(Equip *)equip
{
    self.equip = equip;
    self.titleLabel.text  = equip.name;
}
- (IBAction)addToHome:(id)sender {
    NSLog(@"ssss");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  //  _userName =[alert textFieldAtIndex:0];
    _passWord =[alert textFieldAtIndex:0];
    _passWord.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    [alert show];
   
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      __weak typeof(self) weakSelf = self;
    switch (buttonIndex) {
        case 1:
        {
            NSDictionary *dict = @{@"roomCode":self.equip.roomCode,
                                   @"deviceAddress":self.equip.equipID,
                                   @"nickName":self.equip.name,
                                   @"ico":@"list_camera",
                                   @"deviceType":@"100",
                                   @"validationCode":self.passWord.text,
                                   @"deviceCode":@"commonsxt"};
          
            [BaseHttpService sendRequestAccess:@"http://120.27.137.65/smarthome.IMCPlatform/xingUser/setDeviceInfo.action" parameters:dict success:^(id _Nonnull) {
                
              
               
                weakSelf.equip.hostDeviceCode = @"commonsxt";
                weakSelf.equip.num = weakSelf.passWord.text;
                
             
                [weakSelf.equip saveEquip];
                [[[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
            }];
        }
            break;
            
        default:
            
            break;
    }
    
}


@end
