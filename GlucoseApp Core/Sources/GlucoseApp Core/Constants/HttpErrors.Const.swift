//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 29/1/22.
//

import Foundation

public enum HttpErrors: Error {
    case LoginError
    case GetSettingsError
    case GetUserRoleError
    case GetLastSensorGlucoseError
    case GetDataError
    case CredentialsError
    case ConsentError
    case CookieStorageMissingError
    case CookieNotFoundError
    case WrongUrlFormatError
    case HttpRequestFailError
    case HttpRequestNotOkError
    case JsonSerializationError
    
}
