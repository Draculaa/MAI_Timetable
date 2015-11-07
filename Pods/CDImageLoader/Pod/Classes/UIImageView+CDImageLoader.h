//
//  UIImageView+CDImageLoader.h
//  Pods
//
//  Created by Cicero on 12/07/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (CDImageLoader)

- (void) setImageNoAvaliableName:(NSString *)imageName;

- (void) loadFromURL:(NSString*)urlString sucess:(void (^)(NSString * url, UIImage * image))success animated:(BOOL)animated;
- (void) loadFromURL:(NSString*)urlString sucess:(void (^)(UIImage * image))success andError:(void (^)())error animated:(BOOL)animated;
- (void) loadFromURL:(NSString *)urlString animated:(BOOL)animated;

@end
