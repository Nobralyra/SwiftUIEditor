//
//  DetailView.swift
//  SwiftUIEditor
//
//  Created by admin on 11/09/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

// Den siden man kan skrive i, som får hjælp af MyTextView
struct DetailView: View
{
    // variablens værdi bliver pushet op til GUI, så GUI ændre sig
    //@State var text: String
    
        
    // Hvad er det aktuelle ide man bruger lige nu
    // Hvis bare UUID, så er det en type og den værdi kommer senere
    //var currentID: UUID
    
    // @State kan ændre alle GUI's - hvis den ikke er givet en værdi her, skal den have en constructor
    @State var isPresented: Bool = false
    
    // Container for det billede der har været ændret i childklassen
    @State var inputImage: UIImage?
    
    // Skal være af typen Image som swift kan vise
    @State var imageToDisplay: Image?
    
    @State var url = ""
    
    // Få fat i klassen Repo, for at kunne vise den rigtige note
    var repo: Repo
    
    @State var currentNote: Note
   
    var body: some View
    {
        VStack
        {
            MyTextView(text: $currentNote.title)
            
//            if url != ""
//            {
//                AnimatedImage(url: URL(string: url)!).frame(height: 400).cornerRadius(25).padding()
//            }
//            else
//            {
//                Loader()
//            }
//            if let img = currentNote.image
//            {
//                //Text("Her er en bil")
//                //currentImage
//                img.resizable()
//            }
            
            
            // Mangler at lave at man kan vise images
           
            
//            self.repo.getFile(note: Note(title: "title", id: UUID()))
//            self.imageToDisplay = note.image
            self.imageToDisplay?
                .resizable()
                .frame(width: 250, height: 250, alignment: .center)
            
            Button( action:
            {
                isPresented = true
                
            }, label:
            {
                Text("Hent billede")
            })
        }
//        .onAppear {
//            self.repo.getImageFromStorage(note: currentNote)
//        }
        .navigationBarItems(trailing: HStack
        {
            Button( action:
            {
                // 1. find det rigtige Note i Repo
                // 2. overskriv dens title variabel
                
                
                self.repo.updateNote(note: currentNote)
                
                if let uploadImage = self.inputImage
                {
                    self.repo.uploadFileTest(image: uploadImage)
                }
                else
                {
                    print("Couldn't upload image - no image present")
                }
            })
            {
                Image(systemName: "checkmark").imageScale(.large)
            }
            Button( action:
            {
                self.repo.deleteNote(id: currentNote.id.uuidString)
            })
            {
                Image(systemName: "trash.fill").imageScale(.large)
            }
        })
        // sheet kan enten vise eller skjule et view. $ dollertegn indikere at man løbende lytter til variablen for ændring. onDismiss skal metoden ikke have paranteser, da den bare får at vide at her er en metode, som du kan bruge når du har lyst
        // Man kan have så mange sheets som man ønsker
        .sheet(isPresented: $isPresented, onDismiss: handleImage, content:
        {
            MyImagePicker(image: $inputImage, isPresented: $isPresented)
        })
    }
    
    func handleImage()
    {
        if let imageFromMyImagePicker = inputImage
        {
            // opretter et Image ud fra UIImage, og gemmer det i variablen imageToDisplay
            self.imageToDisplay = Image(uiImage: imageFromMyImagePicker)
            print("Fandt billede")
        }
        else
        {
            print("Fandt intet billede i biblioteket")
        }
    }
}

//struct DetailView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        DetailView(text: "b", currentID: UUID(), repo: Repo(), currentNote: Note(title: "b", id: UUID()))
//    }
//}
//import SwiftUI
//
//// Den siden man kan skrive i, som får hjælp af MyTextView
//struct DetailView: View {
//    // variabel som er en String, som man kan bruge et andet sted
//    //var titel: String
//
//    // variablens værdi bliver pushet op til GUI, så GUI ændre sig
//    @State var title: String
//
//    @State var text: String
//
//    // Hvad er det aktuelle ide man bruger lige nu
//    // Hvis bare UUID, så er det en type og den værdi kommer senere
//    var currentId: UUID
//
//    // Få fat i klassen Repo, for at kunne vise den rigtige note
//    var repo: Repo
//
//    var body: some View {
//        VStack {
//            MyTitleView(title: $title)
//            Spacer()
//            MyTextView(text: $text)
//
//            // 1. Find den rigtige Note i Repo
//            // 2. Overskriv dens title variable
//        }
//        .onDisappear() {
//            print("onDisappear")
//            self.repo.findNote(id: self.currentId).text = self.text
//        }
//    }
//}
//
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(title: "title", text: "text", currentId: UUID(), repo: Repo())
//    }
//}
