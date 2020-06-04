#import <Foundation/Foundation.h>

@interface VersionManager : NSObject

+ (uint32_t) readVersionWithPath:(NSString *) path;
+ (uint32_t) parseVersion;
+ (void) writeVersionWithPath:(NSString *) path ver: (uint32_t) ver;

@end
