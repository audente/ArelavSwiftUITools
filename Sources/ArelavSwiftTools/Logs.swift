import Swift


public struct Log {
    public func Debug(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Debug.rawValue, type: "DBG", msg: msg, detail: detail) 
    }
    public func Error(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Error.rawValue, type: "!!!", msg: msg, detail: detail) 
    }
    public func Warning(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Warning.rawValue, type: "  !", msg: msg, detail: detail) 
    }
    public func Step(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Step.rawValue, type: " § ", msg: msg, detail: detail) 
    }
    public func Info(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Info.rawValue, type: " - ", msg: msg, detail: detail) 
    }
    public func Verbose(msg: String, detail: String? = nil) { 
        log(level: LogLevel.Verbose.rawValue, type: "   ", msg: msg, detail: detail) 
    }
    
    
    public enum LogLevel: Int {
        case Debug = 0
        case Verbose = 10
        case Warning = 40
        case Info = 50
        case Error = 90
        case Step = 100
        case Nothing = 1000
    }
    
    public var logLevel: LogLevel
    public static let shared = Log()
    
    private init() {
        logLevel = .Nothing
        }
    private func log(level: Int, type: String, msg: String, detail: String?) {
        if level >= logLevel.rawValue {
            print("\(type) | \(msg) | \(detail ?? "-")")
        }
    }    
}
