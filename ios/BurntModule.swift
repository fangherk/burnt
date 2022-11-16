import ExpoModulesCore
import SPIndicator
import SPAlert
 
enum AlertPreset: String, Enumerable {
  case done
  case error
  case heart
  case spinner

  func toSPAlertIconPreset() -> SPAlertIconPreset {
    switch self {
    case .done:
      return .done
    case .error:
      return .error
    case .heart:
      return .heart
    case .spinner:
      return .spinner
    }
  }
}

struct AlertOptions: Record {
  @Field
  var title: String = ""
  
  @Field
  var message: String?

  @Field
  var preset: AlertPreset = AlertPreset.done

  @Field
  var duration: TimeInterval?
}


struct ToastOptions: Record {
  @Field
  var title: String = ""
  
  @Field
  var message: String?

  @Field
  var preset: ToastPreset = ToastPreset.done

  @Field
  var duration: TimeInterval?
}

enum ToastPreset {
  case done
  case error

  func toSPIndicatorPreset() -> SPIndicatorPreset {
    switch self {
    case .done:
      return .done
    case .error:
      return .error
    }
  }
}

public class BurntModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('Burnt')` in JavaScript.
    Name("Burnt")

    AsyncFunction("toastAsync") { (options: ToastOptions) -> Void in
      SPIndicator.present(title: options.title, message: options.message, preset: options.preset.toSPIndicatorPreset())
    }.runOnQueue(.main) 

    AsyncFunction("alertAsync")  { (options: AlertOptions) -> Void in
      let view = SPAlertView(
        title: options.title, message: options.message, preset: options.preset.toSPAlertIconPreset())

      if let duration = options.duration {
        view.duration = duration
      }

      view.present()
    }.runOnQueue(.main) 

    AsyncFunction("dismissAllAlertsAsync") {
      return SPAlert.dismiss()
    }
  }
}