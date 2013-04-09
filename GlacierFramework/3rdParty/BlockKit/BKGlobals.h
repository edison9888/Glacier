//
//  BKGlobals.h
//  BlocksKit
//


#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
#define BK_HAS_UIKIT 0
#define BK_HAS_APPKIT 1
#elif (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#define BK_HAS_UIKIT 1
#define BK_HAS_APPKIT 0
#else
#define BK_HAS_UIKIT 0
#define BK_HAS_APPKIT 0
#endif

#ifndef DEPRECATED_ATTRIBUTE_M
#if __has_attribute(deprecated)
#define DEPRECATED_ATTRIBUTE_M(...) __attribute__((deprecated(__VA_ARGS__)))
#else
#define DEPRECATED_ATTRIBUTE_M(...) DEPRECATED_ATTRIBUTE
#endif
#endif

typedef void (^BKBlock)(void); // compatible with dispatch_block_t
typedef void (^BKSenderBlock)(id sender);
typedef void (^BKSenderKeyPathBlock)(id obj, NSString *keyPath);
typedef void (^BKKeyValueBlock)(id key, id obj);
typedef void (^BKIndexBlock)(NSUInteger index);
typedef void (^BKTimerBlock)(NSTimeInterval time);
typedef void (^BKResponseBlock)(NSURLResponse *response);

typedef void (^BKObservationBlock)(id obj, NSDictionary *change);
typedef void (^BKMultipleObservationBlock)(id obj, NSString *keyPath, NSDictionary *change);

typedef BOOL (^BKValidationBlock)(id obj);
typedef BOOL (^BKKeyValueValidationBlock)(id key, id obj);
typedef BOOL (^BKIndexValidationBlock)(NSUInteger index);

typedef id (^BKReturnBlock)(void);
typedef id (^BKTransformBlock)(id obj);
typedef id (^BKKeyValueTransformBlock)(id key, id obj);
typedef id (^BKAccumulationBlock)(id sum, id obj);

typedef NSUInteger (^BKIndexTransformBlock)(NSUInteger index);