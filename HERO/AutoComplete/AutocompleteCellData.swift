//
//  AutocompleteCellData.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/12/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit

public protocol AutocompletableOption {
    var text: String { get }
    var pairedUID: String { get }
}

open class AutocompleteCellData: AutocompletableOption {
    public var pairedUID: String
    fileprivate let _text: String
    open var text: String { get { return _text } }
    open let image: String?

    public init(text: String, image: String?, uid: String?) {
        self._text = text
        self.image = image
        self.pairedUID = uid!
    }
}
