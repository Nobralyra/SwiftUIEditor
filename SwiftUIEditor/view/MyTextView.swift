//
//  MyTextView.swift
//  SwiftUIEditor
//
//  Created by admin on 11/09/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import SwiftUI
import UIKit

struct MyTextView: UIViewRepresentable
{
    // Brug for @Binding, da struct er immutible, og når man har et child og parent objekt, og de skal vide at en anden er opdateret, for selv at opdatere, skal der bruges @Binding
    @Binding var text:String
    
    // Lave eget textview objekt fra UIKit
    func makeUIView(context: Context) -> UITextView
    {
        let textView = UITextView()
        // kan vælge textviewet
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context)
    {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator($text)
    }
    
    // Fomidler kontakten mellem variablen text og textfView
    // Delegate pattern er en klasse der har en metode, som den ikke ved hvornår den skal eksekveres - den mangler noget funktionalitet.
    // Her vil det være textView objektet der får den til at eksekvere metoden.
    // Kan f.eks blive brugt når man downloader et billede, men hvad skal apple gøre når man kommer tilbage
    class Coordinator:NSObject, UITextViewDelegate
    {
        var text:Binding<String>
        
        // externalparametername = underscoren man ved måske ikke hvilke parameter
        init(_ text:Binding<String>)
        {
            self.text = text
        }
        func textViewDidChange(_ textView: UITextView)
        {
            self.text.wrappedValue = textView.text
        }
    }
}
