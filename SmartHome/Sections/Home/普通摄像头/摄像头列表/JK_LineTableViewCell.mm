//
//  JK_LineTableViewCell.m
//  ZNJD2
//
//  Created by he on 14-7-18.
//
//

#import "JK_LineTableViewCell.h"
#import "SmartHome-Swift.h"
@interface JK_LineTableViewCell()
@property (nonatomic,strong)HTCameras *camera;
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
-(void)setModel:(HTCameras *)camera
{
    self.camera = camera;
    self.titleLabel.text  = camera.deviceName;
}
- (IBAction)addToHome:(id)sender {
    NSLog(@"ssss");
    NSDictionary *dict = @{@"roomCode":self.camera.roomId,
                            @"deviceAddress":self.camera.ID,
                            @"nickName":self.camera.deviceName,
                            @"ico":@"",
                            @"deviceType":@"100",
                            @"deviceCode":@"commonsxt"};
   
    [BaseHttpService sendRequestAccess:@"http://120.27.137.65/smarthome.IMCPlatform/xingUser/setDeviceInfo.action" parameters:dict success:^(id _Nonnull) {
        Equip *equip = [[Equip alloc]initWithEquipID:self.camera.ID];
        equip.name = self.camera.deviceName;
        equip.type = @"100";
        equip.hostDeviceCode = @"commonsxt";
        equip.roomCode = self.camera.roomId;
        [equip saveEquip];
        [[[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
    }];
}


@end
