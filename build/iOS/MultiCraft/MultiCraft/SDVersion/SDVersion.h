//
//	SDiOSVersion.h
//	SDVersion [https://github.com/sebyddd/SDVersion]
//
//	The MIT License (MIT)
//	Copyright (c) 2014-2017 Sebastian Dobrincu
//	Copyright (c) 2019-2020 MultiCraft Development Team
//

#import <sys/utsname.h>
#define SDVersion SDiOSVersion

typedef NS_ENUM(NSInteger, DeviceVersion){
	Simulator             = 1,
	// iPhone
	iPhone4S              = 101,
	iPhone5               = 102,
	iPhone5C              = 103,
	iPhone5S              = 104,
	iPhone6               = 105,
	iPhone6Plus           = 106,
	iPhone6S              = 107,
	iPhone6SPlus          = 108,
	iPhoneSE              = 109,
	iPhone7               = 110,
	iPhone7Plus           = 111,
	iPhone8               = 112,
	iPhone8Plus           = 113,
	iPhoneX               = 114,
	iPhoneXS              = 115,
	iPhoneXR              = 116,
	iPhoneXSMax           = 117,
	iPhone11              = 118,
	iPhone11Pro           = 119,
	iPhone11ProMax        = 120,
	iPhoneSE2Gen          = 121,

	// iPad
	iPad2                 = 201,
	iPadMini              = 202,
	iPad3                 = 203,
	iPad4                 = 204,
	iPadAir               = 205,
	iPadMini2             = 206,
	iPadAir2              = 207,
	iPadMini3             = 208,
	iPadMini4             = 209,
	iPadPro12Dot9Inch     = 210,
	iPadPro9Dot7Inch      = 211,
	iPad5                 = 212,
	iPadPro12Dot9Inch2Gen = 213,
	iPadPro10Dot5Inch     = 214,
	iPad6                 = 215,
	iPadPro11Inch         = 216,
	iPadPro12Dot9Inch3Gen = 217,
	iPadMini5             = 218,
	iPadAir3              = 219,
	iPad7                 = 220,
	iPadPro11Inch2Gen     = 216,
	iPadPro12Dot9Inch4Gen = 217,

	// iPod Touch
	iPodTouch5Gen         = 301,
	iPodTouch6Gen         = 302,
	iPodTouch7Gen         = 303
};

@interface SDiOSVersion : NSObject
+ (DeviceVersion)deviceVersion;
@end

@implementation SDiOSVersion

+ (NSDictionary*)deviceNamesByCode
{
	static NSDictionary *deviceNamesByCode = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		deviceNamesByCode = @{
			// Simulator
			@"i386"       : @(Simulator),
			@"x86_64"     : @(Simulator),

			// iPhone
			@"iPhone4,1"  : @(iPhone4S),
			@"iPhone4,2"  : @(iPhone4S),
			@"iPhone4,3"  : @(iPhone4S),
			@"iPhone5,1"  : @(iPhone5),
			@"iPhone5,2"  : @(iPhone5),
			@"iPhone5,3"  : @(iPhone5C),
			@"iPhone5,4"  : @(iPhone5C),
			@"iPhone6,1"  : @(iPhone5S),
			@"iPhone6,2"  : @(iPhone5S),
			@"iPhone7,2"  : @(iPhone6),
			@"iPhone7,1"  : @(iPhone6Plus),
			@"iPhone8,1"  : @(iPhone6S),
			@"iPhone8,2"  : @(iPhone6SPlus),
			@"iPhone8,4"  : @(iPhoneSE),
			@"iPhone12,8" : @(iPhoneSE2Gen),
			@"iPhone9,1"  : @(iPhone7),
			@"iPhone9,3"  : @(iPhone7),
			@"iPhone9,2"  : @(iPhone7Plus),
			@"iPhone9,4"  : @(iPhone7Plus),
			@"iPhone10,1" : @(iPhone8),
			@"iPhone10,4" : @(iPhone8),
			@"iPhone10,2" : @(iPhone8Plus),
			@"iPhone10,5" : @(iPhone8Plus),
			@"iPhone10,3" : @(iPhoneX),
			@"iPhone10,6" : @(iPhoneX),
			@"iPhone11,8" : @(iPhoneXR),
			@"iPhone11,2" : @(iPhoneXS),
			@"iPhone11,4" : @(iPhoneXSMax),
			@"iPhone11,6" : @(iPhoneXSMax),
			@"iPhone12,1" : @(iPhone11),
			@"iPhone12,3" : @(iPhone11Pro),
			@"iPhone12,5" : @(iPhone11ProMax),

			// iPad
			@"iPad2,1"  : @(iPad2),
			@"iPad2,2"  : @(iPad2),
			@"iPad2,3"  : @(iPad2),
			@"iPad2,4"  : @(iPad2),
			@"iPad3,1"  : @(iPad3),
			@"iPad3,2"  : @(iPad3),
			@"iPad3,3"  : @(iPad3),
			@"iPad3,4"  : @(iPad4),
			@"iPad3,5"  : @(iPad4),
			@"iPad3,6"  : @(iPad4),
			@"iPad6,11" : @(iPad5),
			@"iPad6,12" : @(iPad5),
			@"iPad7,5"  : @(iPad6),
			@"iPad7,6"  : @(iPad6),
			@"iPad7,11" : @(iPad7),
			@"iPad7,12" : @(iPad7),

			@"iPad4,1"  : @(iPadAir),
			@"iPad4,2"  : @(iPadAir),
			@"iPad4,3"  : @(iPadAir),
			@"iPad5,3"  : @(iPadAir2),
			@"iPad5,4"  : @(iPadAir2),
			@"iPad11,3" : @(iPadAir3),
			@"iPad11,4" : @(iPadAir3),

			@"iPad2,5"  : @(iPadMini),
			@"iPad2,6"  : @(iPadMini),
			@"iPad2,7"  : @(iPadMini),
			@"iPad4,4"  : @(iPadMini2),
			@"iPad4,5"  : @(iPadMini2),
			@"iPad4,6"  : @(iPadMini2),
			@"iPad4,7"  : @(iPadMini3),
			@"iPad4,8"  : @(iPadMini3),
			@"iPad4,9"  : @(iPadMini3),
			@"iPad5,1"  : @(iPadMini4),
			@"iPad5,2"  : @(iPadMini4),
			@"iPad11,1" : @(iPadMini5),
			@"iPad11,2" : @(iPadMini5),

			@"iPad6,3"  : @(iPadPro9Dot7Inch),
			@"iPad6,4"  : @(iPadPro9Dot7Inch),
			@"iPad7,3"  : @(iPadPro10Dot5Inch),
			@"iPad7,4"  : @(iPadPro10Dot5Inch),
			@"iPad8,1"  : @(iPadPro11Inch),
			@"iPad8,2"  : @(iPadPro11Inch),
			@"iPad8,3"  : @(iPadPro11Inch),
			@"iPad8,4"  : @(iPadPro11Inch),
			@"iPad8,9"  : @(iPadPro11Inch2Gen),
			@"iPad8,10" : @(iPadPro11Inch2Gen),
			@"iPad6,7"  : @(iPadPro12Dot9Inch),
			@"iPad6,8"  : @(iPadPro12Dot9Inch),
			@"iPad7,1"  : @(iPadPro12Dot9Inch2Gen),
			@"iPad7,2"  : @(iPadPro12Dot9Inch2Gen),
			@"iPad8,5"  : @(iPadPro12Dot9Inch3Gen),
			@"iPad8,6"  : @(iPadPro12Dot9Inch3Gen),
			@"iPad8,7"  : @(iPadPro12Dot9Inch3Gen),
			@"iPad8,8"  : @(iPadPro12Dot9Inch3Gen),
			@"iPad8,11" : @(iPadPro12Dot9Inch4Gen),
			@"iPad8,12" : @(iPadPro12Dot9Inch4Gen),

			// iPod
			@"iPod5,1" : @(iPodTouch5Gen),
			@"iPod7,1" : @(iPodTouch6Gen),
			@"iPod9,1" : @(iPodTouch7Gen)};
	});
	return deviceNamesByCode;
}

+ (DeviceVersion)deviceVersion
{
	struct utsname systemInfo;
	uname(&systemInfo);
	NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	DeviceVersion version = (DeviceVersion)[self.deviceNamesByCode[code] integerValue];
	return version;
}
@end

#define SDVersion4Inch		(([SDVersion deviceVersion] == iPhone5) || ([SDVersion deviceVersion] == iPhone5C) || ([SDVersion deviceVersion] == iPhone5S) || ([SDVersion deviceVersion] == iPhoneSE) || \
							([SDVersion deviceVersion] == iPodTouch5Gen) || ([SDVersion deviceVersion] == iPodTouch6Gen) || ([SDVersion deviceVersion] == iPodTouch7Gen))

#define SDVersion4and7Inch	(([SDVersion deviceVersion] == iPhone6) || ([SDVersion deviceVersion] == iPhone6S) || ([SDVersion deviceVersion] == iPhone7) || ([SDVersion deviceVersion] == iPhone8) || ([SDVersion deviceVersion] == iPhoneSE2Gen))

#define SDVersion5and5Inch	(([SDVersion deviceVersion] == iPhone6Plus) || ([SDVersion deviceVersion] == iPhone6SPlus) || ([SDVersion deviceVersion] == iPhone7Plus) || ([SDVersion deviceVersion] == iPhone8Plus))

#define SDVersion5and8Inch	(([SDVersion deviceVersion] == iPhoneX) || ([SDVersion deviceVersion] == iPhoneXS) || ([SDVersion deviceVersion] == iPhone11Pro))

#define SDVersion6and1Inch	(([SDVersion deviceVersion] == iPhoneXR) || ([SDVersion deviceVersion] == iPhone11))

#define SDVersion6and5Inch	(([SDVersion deviceVersion] == iPhoneXSMax) || ([SDVersion deviceVersion] == iPhone11ProMax))

#define SDVersion7and9Inch	(([SDVersion deviceVersion] == iPadMini) || ([SDVersion deviceVersion] == iPadMini2) | ([SDVersion deviceVersion] == iPadMini3) | ([SDVersion deviceVersion] == iPadMini4) | ([SDVersion deviceVersion] == iPadMini5))

#define SDVersion11Inch		(([SDVersion deviceVersion] == iPadPro11Inch) || ([SDVersion deviceVersion] == iPadPro11Inch2Gen))

#define SDVersion12and9Inch	(([SDVersion deviceVersion] == iPadPro12Dot9Inch) || ([SDVersion deviceVersion] == iPadPro12Dot9Inch2Gen) || ([SDVersion deviceVersion] == iPadPro12Dot9Inch3Gen) || ([SDVersion deviceVersion] == iPadPro12Dot9Inch4Gen))

#define SDVersionHomeBar	(SDVersion5and8Inch || SDVersion6and1Inch || SDVersion6and5Inch || \
							SDVersion11Inch || SDVersion12and9Inch)
