

import Foundation

class APIConstants {
    enum APIUrl: String {
        case checkSetupCode = "/api/v1/checkSetupCode"
        case checkReservation = "/api/v1/reservations/%@/status"
        case call = "/api/v1/calls"
        case checkOut = "/api/v1/checkouts"
        case endCall = "/api/v1/calls/end_call"
        case devices = "/api/v1/devices"
        case unlock = "/api/v1/devices/unlock"
        case rejectCall = "/api/v1/calls/%@/reject"
        case ignoreCall = "/api/v1/calls/%@/ignore"
        case checkAbilitySupport = "/api/v1/reservations/%@/ability_support"
        case resendDoorCode = "/api/v1/reservations/%@/trigger_send_door_code"
    }
}
