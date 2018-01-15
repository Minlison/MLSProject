//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NICollectionViewActions.h"

#import "NICollectionViewCellFactory.h"
#import "NimbusCore.h"
#import "NIActions+Subclassing.h"
#import <objc/runtime.h>

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "Nimbus requires ARC support."
#endif
@interface NICollectionViewActions()
@property (nonatomic, strong) NSMutableSet* forwardDelegates;
@end
@implementation NICollectionViewActions
- (id)initWithTarget:(id)target {
        if ((self = [super initWithTarget:target])) {
                _forwardDelegates = NICreateNonRetainingMutableSet();
        }
        return self;
}


#pragma mark - Forward Invocations


- (BOOL)shouldForwardSelector:(SEL)selector {
        struct objc_method_description description;
        description = protocol_getMethodDescription(@protocol(NICollectionViewDelegate), selector, NO, YES);
        return (description.name != NULL && description.types != NULL);
}

- (BOOL)respondsToSelector:(SEL)selector {
        if ([super respondsToSelector:selector]) {
                return YES;
                
        } else if ([self shouldForwardSelector:selector]) {
                for (id delegate in self.forwardDelegates) {
                        if ([delegate respondsToSelector:selector]) {
                                return YES;
                        }
                }
        }
        return NO;
}
- (id)forwardingTargetForSelector:(SEL)aSelector
{
        for (id delegate in self.forwardDelegates) {
                if ([delegate respondsToSelector:aSelector]) {
                        return delegate;
                }
        }
        return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
        NSMethodSignature *signature = [super methodSignatureForSelector:selector];
        if (signature == nil) {
                for (id delegate in self.forwardDelegates) {
                        if ([delegate respondsToSelector:selector]) {
                                signature = [delegate methodSignatureForSelector:selector];
                        }
                }
        }
        return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
        BOOL didForward = NO;
        
        if ([self shouldForwardSelector:invocation.selector]) {
                for (id delegate in self.forwardDelegates) {
                        if ([delegate respondsToSelector:invocation.selector]) {
                                [invocation invokeWithTarget:delegate];
                                didForward = YES;
                                break;
                        }
                }
        }
        
        if (!didForward) {
                [super forwardInvocation:invocation];
        }
}

- (id<NICollectionViewDelegate>)forwardingTo:(id<NICollectionViewDelegate>)forwardDelegate {
        [self.forwardDelegates addObject:forwardDelegate];
        return self;
}

- (void)removeForwarding:(id<NICollectionViewDelegate>)forwardDelegate {
        [self.forwardDelegates removeObject:forwardDelegate];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
        
        // Forward the invocation along.
        for (id<NICollectionViewDelegate> delegate in self.forwardDelegates) {
                if ([delegate respondsToSelector:_cmd]) {
                        return [delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
                }
        }
        
        BOOL shouldHighlight = NO;
        
        NIDASSERT([collectionView.dataSource conformsToProtocol:@protocol(NIActionsDataSource)]);
        if ([collectionView.dataSource conformsToProtocol:@protocol(NIActionsDataSource)]) {
                id object = [(id<NIActionsDataSource>)collectionView.dataSource objectAtIndexPath:indexPath];
                
                if ([self isObjectActionable:object]) {
                        NIObjectActions* action = [self actionForObjectOrClassOfObject:object];
                        
                        // If the cell is tappable, reflect that in the selection style.
                        if (nil != action.tapAction || nil != action.tapSelector
                            || nil != action.detailAction || nil != action.detailSelector
                            || nil != action.navigateAction || nil != action.navigateSelector) {
                                shouldHighlight = YES;
                        }
                }
        }
        
        return shouldHighlight;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//        for (id<NICollectionViewDelegate> delegate in self.forwardDelegates) {
//                if ([delegate respondsToSelector:_cmd]) {
//                       return [delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
//                }
//        }
//        return CGSizeMake(collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right, 10);
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        NIDASSERT([collectionView.dataSource conformsToProtocol:@protocol(NIActionsDataSource)]);
        // Forward the invocation along.
        for (id<NICollectionViewDelegate> delegate in self.forwardDelegates) {
                if ([delegate respondsToSelector:_cmd]) {
                        [delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
                }
        }
        
        if ([collectionView.dataSource conformsToProtocol:@protocol(NIActionsDataSource)]) {
                id object = [(id<NIActionsDataSource>)collectionView.dataSource objectAtIndexPath:indexPath];
                
                if ([self isObjectActionable:object]) {
                        NIObjectActions* action = [self actionForObjectOrClassOfObject:object];
                        
                        BOOL shouldDeselect = NO;
                        if (action.tapAction) {
                                // Tap actions can deselect the cell if they return YES.
                                shouldDeselect = action.tapAction(object, self.target, indexPath);
                        }
                        if (action.tapSelector && [self.target respondsToSelector:action.tapSelector]) {
                                NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:action.tapSelector];
                                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                                invocation.selector = action.tapSelector;
                                if (methodSignature.numberOfArguments >= 3) {
                                        [invocation setArgument:&object atIndex:2];
                                }
                                if (methodSignature.numberOfArguments >= 4) {
                                        [invocation setArgument:&indexPath atIndex:3];
                                }
                                [invocation invokeWithTarget:self.target];
                                
                                NSUInteger length = invocation.methodSignature.methodReturnLength;
                                if (length > 0) {
                                        char *buffer = (void *)malloc(length);
                                        memset(buffer, 0, sizeof(char) * length);
                                        [invocation getReturnValue:buffer];
                                        for (NSUInteger index = 0; index < length; ++index) {
                                                if (buffer[index]) {
                                                        shouldDeselect = YES;
                                                        break;
                                                }
                                        }
                                        free(buffer);
                                }
                        }
                        
                        if (action.detailAction) {
                                // Tap actions can deselect the cell if they return YES.
                                action.detailAction(object, self.target, indexPath);
                        }
                        if (action.detailSelector && [self.target respondsToSelector:action.detailSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                [self.target performSelector:action.detailSelector withObject:object withObject:indexPath];
#pragma clang diagnostic pop
                        }
                        
                        if (action.navigateAction) {
                                // Tap actions can deselect the cell if they return YES.
                                action.navigateAction(object, self.target, indexPath);
                        }
                        if (action.navigateSelector && [self.target respondsToSelector:action.navigateSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                [self.target performSelector:action.navigateSelector withObject:object withObject:indexPath];
#pragma clang diagnostic pop
                        }
                        
                        if (shouldDeselect) {
                                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                        }
                }
        }
}

@end
