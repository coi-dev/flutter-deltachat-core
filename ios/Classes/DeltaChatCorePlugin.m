#import "DeltaChatCorePlugin.h"
#import <delta_chat_core/delta_chat_core-Swift.h>

@implementation DeltaChatCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeltaChatCorePlugin registerWithRegistrar:registrar];
}
@end
