//
//  UIImageView+CDImageLoader.m
//  Pods
//
//  Created by Cicero on 12/07/15.
//
//

#import "UIImageView+CDImageLoader.h"

@implementation UIImageView (CDImageLoader)

#define ANIMATION_DURATION 0.3f
#define IMAGE_DEFAULT_KEY @"image_default_key"

- (void) setImageNoAvaliableName:(NSString *)imageName {
    NSUserDefaults * config = [NSUserDefaults standardUserDefaults];
    [config setObject:imageName forKey:IMAGE_DEFAULT_KEY];
    [config synchronize];
}

- (NSString *) getImageDefaultName {
    NSUserDefaults * config = [NSUserDefaults standardUserDefaults];
    return [config objectForKey:IMAGE_DEFAULT_KEY];
}

- (BOOL) isURLString:(NSString *)urlString {
    return (urlString != nil && (NSNull *)urlString != [NSNull null] && urlString.length > 0);
}

- (void) blinkAnimation:(BOOL)animated {
    if(animated) {
        [self setAlpha:0.0f];
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [self setAlpha:1.0f];
        } completion:nil];
    }
}

- (void) successAnimated:(BOOL) animated imageData:(NSData *)imageData {
    self.image = [UIImage imageWithData:imageData];
    [self blinkAnimation:animated];
}

- (void) error {
    self.image = [UIImage imageNamed:[self getImageDefaultName]];
}

- (void)loadFromURL:(NSString *)urlString sucess:(void (^)(UIImage *))success andError:(void (^)())error animated:(BOOL)animated {
    if([self isURLString:urlString]) {
        NSURL * url = [NSURL URLWithString:urlString];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(imageData != nil) {
                    [self successAnimated:animated imageData:imageData];
                    success(self.image);
                } else {
                    [self error];
                    error();
                }
            });
        });
    }

}

- (void)loadFromURL:(NSString *)urlString sucess:(void (^)(NSString *, UIImage *))success animated:(BOOL)animated {
    if([self isURLString:urlString]) {
        NSURL * url = [NSURL URLWithString:urlString];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(imageData != nil) {
                    [self successAnimated:animated imageData:imageData];
                    success(urlString, self.image);
                } else {
                    [self error];
                }
            });
        });
    }
}

- (void)loadFromURL:(NSString *)urlString animated:(BOOL)animated{
    NSURL * url = [NSURL URLWithString:urlString];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(imageData != nil) {
                [self successAnimated:animated imageData:imageData];
            } else {
                [self error];
            }
        });
    });
}


@end
