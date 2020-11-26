/**
 MarvelApi.swift
 Class with information about Marvel API

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation
import CryptoSwift

enum MarvelApi {
    /// - String basePath url base para api da marvel
    static let basePath = "https://gateway.marvel.com/v1/public"
    /// - String pathCharacters endpoint for charachters request
    static let pathCharacters = "/characters"
    /// - Int limit limit of elements per page
    static let limit = 30
    /// - String privateKey api marvel
    private static let privateKey = ""
    /// - String publicKey api marvel
    private static let publicKey = ""

    /**
     Method that returns credentials to use marvel API
     */
    static func getCredentials() -> [String: String] {
        let timestamp = Date().timeIntervalSince1970.description
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        let authParams = ["ts": timestamp, "apikey": publicKey, "hash": hash]
        return authParams
    }
}
