//
//  Loader.swift
//  SwiftUIEditor
//
//  Created by admin on 02/10/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import SwiftUI


struct Loader: UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView
    {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>)
    {
        
    }
}
