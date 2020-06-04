#import "VersionManager.h"

@implementation VersionManager

+ (uint32_t) readVersionWithPath:(NSString *) path
{
	NSString *filename = [path stringByAppendingPathComponent:@"_version"];
	NSError *error;
	NSString *content = [NSString stringWithContentsOfFile:filename encoding:NSASCIIStringEncoding error:&error];
	if (error)
		return 0;
	return [content intValue];
}

+ (uint32_t) parseVersion
{
	NSString *revstr = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	uint8_t revision = [revstr intValue];

	// compatibility with old versions, DON'T CHANGE
	uint32_t ret = revision | (2 << 24);

	NSLog(@"App revision %@ -> %u", revstr, ret);
	return ret;
}

+ (void) writeVersionWithPath:(NSString *) path ver: (uint32_t) ver
{
	NSString *filename = [path stringByAppendingPathComponent:@"_version"];
	NSString *content = [NSString stringWithFormat:@"%d", ver];
	[content writeToFile:filename atomically:NO encoding:NSASCIIStringEncoding error:nil];
}

@end
