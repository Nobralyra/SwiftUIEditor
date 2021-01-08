//
//  MyImagePicker.swift
//  SwiftUIEditor
//
//  Created by admin on 25/09/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import SwiftUI

// SwiftUI har endnu ikke lavet en feature til at lave Image, men man låner fra UIKit
// UIViewControllerRepresentable protokollen har nogle metoder man skal implementere
struct MyImagePicker : UIViewControllerRepresentable
{
    // Hvordan har man mulighed for at ændre en variabel fra en anden Struct, selvom variablen er markeret med @State, men det gælder kun for den Struct
    // Binding kører på tværs af Structs, og Binding og State kan snakke sammen. De har et parent-child forhold, hvor State er Parent, og Binding er child
    // Her sikre vi at childklassen sørger for at lave image om, så Parent få et frisk billede
    @Binding var image: UIImage?
    @Binding var isPresented:Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyImagePicker>) -> UIImagePickerController
    {
        // Indbygget funktionalitet i iOS som henter billede fra camera eller bibliotek
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        // fortæller at bruge coordinater til picker
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController:UIImagePickerController, context:  UIViewControllerRepresentableContext<MyImagePicker>)
    {
        
    }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(self) // giver et coordinator objekt, for at kunne fortælle om parent
    }
    
    // man skal definere hvad UINavigationControllerDelegate, UIImagePickerControllerDelegate skal gøre
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate
    {
        let parent: MyImagePicker
        init(_ parent: MyImagePicker)
        {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            // Hvis der er et billede i info er et map med data, så skal uiImage have den værdi
            if let uiImage = info[.editedImage] as? UIImage
            {
                // skal have værdien af hvad uiImage
                parent.image = uiImage
            }
            // Når man sætter den til false, får man opdateret @State i ContentView, så den slukker for visningen
            parent.isPresented = false
        }
    }
}

