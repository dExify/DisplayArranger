//
//  CGSPrivateAPI.swift
//  DisplayArranger
//
//  Created by Ole Christian Sollid on 04/12/2025.
//

import Foundation
import CoreGraphics

@_silgen_name("CGSMainConnectionID")
func CGSMainConnectionID() -> UInt32

@_silgen_name("CGSBeginDisplayConfiguration")
func CGSBeginDisplayConfiguration(_ configRef: UnsafeMutablePointer<UInt32?>) -> Int32

@_silgen_name("CGSConfigureDisplayOrigin")
func CGSConfigureDisplayOrigin(_ config: UInt32,
                               _ display: UInt32,
                               _ x: Int32,
                               _ y: Int32) -> Int32

@_silgen_name("CGSCompleteDisplayConfiguration")
func CGSCompleteDisplayConfiguration(_ config: UInt32,
                                     _ option: Int32) -> Int32
