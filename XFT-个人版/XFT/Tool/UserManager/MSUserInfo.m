//
//  MSUserInfo.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "MSUserInfo.h"

@implementation MSUserInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"userAccessInfo":[MSUserAccessInfo class],
             @"userinfo":[MSShowUserInfo class]
    };
}
-(NSString *)userAccessStr
{
    _userAccessInfo.domain = @"agent-app-ios";
    return [_userAccessInfo yy_modelToJSONString];
}
-(NSInteger)uType
{
    /* 登录角色身份类型 0游客 1业主经纪人 2 员工经纪人 3普通经济人 4客户*/
    if ([_userinfo.accRole isEqualToString:@"14"]) {
        _uType = 4;
    }else if ([_userinfo.accRole isEqualToString:@"15"]) {
        _uType = 0;
    }else{
        if ([_userinfo.isOwner isEqualToString:@"1"]) {
            _uType = 1;
        }else if ([_userinfo.isStaff isEqualToString:@"1"]) {
            _uType = 2;
        }else{
            _uType = 3;
        }
    }
    return _uType;
//    `acc_role` int(5) NOT NULL DEFAULT '18' COMMENT '账号角色  13:个人经纪人(个人/业主/员工) 14:注册客户 15:游客',
//    `is_staff` int(5) NOT NULL DEFAULT '0' COMMENT '是否员工 0:否 1:是',
//    `is_owner` int(5) NOT NULL DEFAULT '0' COMMENT '是否业主 0:否 1:是'
}

@end

@implementation MSShowUserInfo

@end

@implementation MSUserAccessInfo

@end

