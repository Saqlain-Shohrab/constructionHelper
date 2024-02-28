#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "dummyImage" asset catalog image resource.
static NSString * const ACImageNameDummyImage AC_SWIFT_PRIVATE = @"dummyImage";

/// The "homeIcon" asset catalog image resource.
static NSString * const ACImageNameHomeIcon AC_SWIFT_PRIVATE = @"homeIcon";

/// The "projectsIcon" asset catalog image resource.
static NSString * const ACImageNameProjectsIcon AC_SWIFT_PRIVATE = @"projectsIcon";

#undef AC_SWIFT_PRIVATE