

import Foundation

//MARK: - Locale
extension Locale {
    static let en_US_POSIX: Locale = Locale(identifier: "en_US_POSIX")
}

//MARK: - TimeZone
extension TimeZone {
    static let centralTexas: TimeZone = TimeZone(identifier: "UTC-06:00")!
    static fileprivate(set) var app: TimeZone = .current;
}

//MARK: - Calendar
extension Calendar {
    static let app: Calendar = Calendar(identifier: .gregorian, timeZone: .app)
    
    init(identifier: Calendar.Identifier, timeZone: TimeZone) {
        self.init(identifier: identifier);
        self.timeZone = timeZone;
    }
}


//MARK: - Date
extension Date {
    
    static var now: Date {
        return Date();
    }
    
    static func join(date: Date, time: Date) -> Date?{
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: date);
        let timeComponents = Calendar.app.dateComponents([.hour, .minute, .second], from: time);
        dateComponents.hour = timeComponents.hour;
        dateComponents.minute = timeComponents.minute;
        dateComponents.second = timeComponents.second;
        return Calendar.app.date(from: dateComponents);
    }
    
    enum TimeInDay {
        case start;
        case end;
    }
    
    func day(for timeInDay: TimeInDay) -> Date {
        switch timeInDay {
        case .start:
            return startDay();
            
        case .end:
            return endDay();
        }
    }
    
    func startDay() -> Date {
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: self);
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = 0;
        return Calendar.app.date(from: dateComponents)!;
    }
    
    func endDay() -> Date {
        var dateComponents = Calendar.app.dateComponents([.year, .month, .day], from: self);
        dateComponents.day = dateComponents.day! + 1;
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = -1;
        return Calendar.app.date(from: dateComponents)!;
    }
    
    func startOfMonth() -> Date {
        let dateComponents = Calendar.app.dateComponents([.year,.month],
                                                         from: Calendar.app.startOfDay(for: self))
        return (Calendar.app.date(from: dateComponents)?.startDay())!
    }
    
    func endOfMonth() -> Date {
        return (Calendar.app.date(byAdding: DateComponents(month: 1, day: -1),
                                  to: self.startOfMonth())?.endDay())!
    }
    
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.app.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.app.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.app.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.app.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.app.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.app.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.app.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func offsetLong(from date: Date) -> String {
        if years(from: date)   > 0 { return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago" }
        if months(from: date)  > 0 { return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago" }
        if weeks(from: date)   > 0 { return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"   }
        if days(from: date)    > 0 { return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago" }
        if hours(from: date)   > 0 { return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"   }
        if minutes(from: date) > 0 { return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago" }
        if seconds(from: date) > 0 { return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago" }
        return ""
    }
    
    func offsetFrom(date : Date) -> DateComponents {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = Calendar.app.dateComponents(dayHourMinuteSecond, from: date, to: self);
        return difference
    }
    
    func toDateString(dateFormater:String = "yyyy-MM-dd",timeZone:TimeZone = TimeZone(identifier: "UTC")!) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormater
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    func toTimeString(timeFormatter:String = "HH:mm",timeZone:TimeZone = TimeZone(identifier: "UTC")!) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormatter
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}

//MARK: - Date for server
extension Date {
    
    private static let serverDateFormatter = DateFormatter(format: "MM/dd/yyyy")
    private static let serverTimeFormatter = DateFormatter(format: "hh:mm a")
    
    static func server(date dateString: String?, time timeString: String?) -> Date? {
        var date: Date? = nil;
        if let dateString = dateString {
            date = serverDateFormatter.date(from: dateString)
        }
        
        var time: Date? = nil;
        if let timeString = timeString {
            time = serverTimeFormatter.date(from: timeString)
        }
        
        if date != nil || time != nil {
            return join(date: date ?? Date(), time: time ?? Date());
        }
        
        return nil;
    }
    
    static func server(date dateString: String?, defaultTime: Date) -> Date? {
        guard let dateString = dateString,
            let date = serverDateFormatter.date(from: dateString) else {
            return nil;
        }
        
        return join(date: date, time: defaultTime);
    }
    
    static func server(time timeString: String?, defaultDate: Date) -> Date? {
        guard let timeString = timeString,
            let time = serverTimeFormatter.date(from: timeString) else {
                return nil;
        }
        
        return join(date: defaultDate, time: time);
    }
    
    static func server(date dateString: String?, for timeInDay: TimeInDay) -> Date? {
        guard let dateString = dateString,
            let date = serverDateFormatter.date(from: dateString) else {
                return nil;
        }
        
        return date.day(for: timeInDay);
    }
    
    func toServerDateTime() -> (date: String, time: String) {
        return (date: Date.serverDateFormatter.string(from: self),
                time: Date.serverTimeFormatter.string(from: self));
    }

}

