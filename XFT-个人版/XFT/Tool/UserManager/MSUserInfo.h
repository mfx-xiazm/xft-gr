//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSShowUserInfo,MSUserAccessInfo;
@interface MSUserInfo : NSObject
@property (nonatomic,strong) MSUserAccessInfo *userAccessInfo;
@property (nonatomic,strong) MSShowUserInfo *userinfo;
/* 登录角色身份类型 0游客 1 业主经纪人 2 员工经纪人 3普通经济人 4客户*/
@property(nonatomic,assign) NSInteger uType;
@property (nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *userAccessStr;

@end

@interface MSShowUserInfo : NSObject
@property (nonatomic, strong) NSString * accNo;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pwd;
@property (nonatomic, strong) NSString * regPhone;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * headpic;
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, strong) NSString * accRole;
@property (nonatomic, strong) NSString * isStaff;
@property (nonatomic, strong) NSString * isOwner;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * cardType;
@property (nonatomic, strong) NSString * cardNo;
@property (nonatomic, strong) NSString * bankOpen;
@property (nonatomic, strong) NSString * bankAccNo;
@property (nonatomic, strong) NSString * bankPhone;
@property (nonatomic, strong) NSString * unionid;
@property (nonatomic, strong) NSString * openid;
@property (nonatomic, strong) NSString * addCity;
@property (nonatomic, strong) NSString * regSource;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * editTime;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * isDel;
@property (nonatomic, strong) NSString * invitationCode;

@end

@interface MSUserAccessInfo : NSObject
@property (nonatomic, strong) NSString * accessTime;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * bizParam;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * extParam;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * loginId;
@property (nonatomic, strong) NSString * receiveTime;
@property (nonatomic, strong) NSString * traceId;
@property (nonatomic, strong) NSString * userDevice;
@property (nonatomic, strong) NSString * userLbs;
@end
