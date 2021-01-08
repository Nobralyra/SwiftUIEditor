//
//  Repo.swift
//  SwiftUIEditor
//
//  Created by admin on 11/09/2020.
//  Copyright © 2020 Signe. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import SDWebImage
import FirebaseUI
import SDWebImageSwiftUI

class Repo: ObservableObject
{
    // Tom samling af Note objekter, som er @Published så alle der subscribed til repo, får at vide at der er sket en forandring
    // Man laver et objekt derfor paranteser
    @Published var notes = [Note]()
    
    // Hvilken collection vi ønsker at få ind i SwiftUI
    private var collection = Firestore.firestore().collection("notes") // giver reference til collection
    
    // Giver rod-adgang til Storage
    private var storage = Storage.storage()
    
    
    var url = ""
    
    init()
    {
        
        getNotes()
    }
    
    
    // Skal ikke have en returntype da der kan tage lidt tid for at hente filen, og så ville systemet vente imens, og det ønsker vi ikke
    func getFile(note: Note)
    {
        let storageRef = storage.reference()
        // reference bruger vi altid
        let fileReference = storageRef.child(note.imageName)
        

        // God ide at sætte maxsize da det kan være upraktisk, hvis den er for høj - for stor til hvad mobillen kan klare. Det er megabite
        fileReference.getData(maxSize: 900000)
        {
            // closure - callback funktion, den venter, anonym funktion, som er tilstede, og man spare at skulle lave en ny funktion
            // Det indkapsulere den kode mellem turborgparantersne
            (data, error ) in
            if let error = error
            {
                print("file download not OK \(error.localizedDescription)")
            }
            else
            {
                // UIImage er fra UIKit, for at lave fra det gamle til det nye
                if let data = data
                {
                    if let image = UIImage(data: data)
                    {
                        // Konventere til Image og gemmer i noteobjektet og opdatere listen
                        
                        note.image = Image(uiImage: image)
                        if note.image == nil
                        {
                            print("File not in Image")
                        }
                        print("file download OK")
                    }
                }
            }
        }
    }
    
//    // Andet forsøg med at hente billeder fra Storage
//    func getImageFromStorage(note: Note)
//    {
//        
//        let storageRef = storage.reference()
//        // reference bruger vi altid
//        let fileReference = storageRef.child("Test")
//        fileReference.downloadURL
//        {
//            (url, error) in
//            if let error = error
//            {
//                print("file download not OK \(error.localizedDescription)")
//            }
//            
//            self.url = "\(url!)"
//            
//        }
//        
//    }
    
    // Minder meget om getFile
    func uploadFile(image: UIImage)
    {
        let imageData = image.jpegData(compressionQuality: 1.0)
        let imageReference = storage.reference().child("temp")
        
        // Create the file metadata
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageReference.putData(imageData!, metadata: metaData)
        {
            // closure - callback funktion, den venter, anonym funktion, som er tilstede, og man spare at skulle lave en ny funktion
            // Det indkapsulere den kode mellem turborgparantersne
            (metadata, error ) in
            if let error = error
            {
                print("file upload not OK \(error.localizedDescription)")

            }
            else
            {
                print("file upload OK")
            }
        }
    }
    
    // Minder meget om getFile
    func uploadFileTest(image: UIImage)
    {
        
        let randomID = UUID.init().uuidString
        let uploadReference = storage.reference(withPath: "pictures/\(randomID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        // Create the file metadata
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadReference.putData(imageData, metadata: uploadMetadata)
        {
            (downloadMetadata, error) in
            if let error = error
            {
                print("File upload not OK \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
        }
    }

    
    // Tilføjer noten brugeren har lavet
    func addNote(note: Note)
    {
        // Kontakte collection, og bede om at få lavet et nyt dokument, og at Firestore skal lave ID'et.
        // Man kan også lave sit eget id med: note.id.uuidString
        // setData tager et map [key: value]
        collection.document(note.id.uuidString).setData(["title": note.title, "imageName": note.imageName])
        {
            // Get af callback
            error in
            if error == nil
            {
                print("Data gemt i cloud")
            }
            else
            {
                print("Cloud error: \(error.debugDescription)")
            }
        }
    }
    
    // Hente en række af documenter, hvis man ved hvor de ligger henne
    func getNotes()
    {
        // Lytter til en hel collection
        collection.addSnapshotListener
        { [self]
            (snapshot, error) in
            if error == nil
            {
                if let snapShot = snapshot
                {
                    self.notes.removeAll() // Tømmer listen først
                    for document in snapShot.documents
                    {
                        if let title = document.data() ["title"] as? String
                        {
                            
                            print("Eg")
                            if let imageNameFromFirestore = document.data() ["imageName"] as? String
                            {
                                print("3g3g")
                                if let id = UUID(uuidString: document.documentID)
                                {
                                    self.getFile(note: Note(title: title, imageName: imageNameFromFirestore, id: id))
                                    self.notes.append(Note(title: title, imageName: imageNameFromFirestore, id: id))
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                print("Error \(error.debugDescription)")
            }
        }
    }
    
    func updateNote(note: Note)
    {
        collection.document(note.id.uuidString).updateData(["title": note.title])
        {
            // Get af callback
            error in
            if error == nil
            {
                print("Data updated in cloud")
            }
            else
            {
                print("Cloud error: \(error.debugDescription)")
            }
        }
    }
    
    
    func deleteNote(id: String)
    {
        collection.document(id).delete()
        {
            error in
            if error == nil
            {
                print("document \(id) slettet fra cloud")
            }
            else
            {
                print("Cloud error: \(error.debugDescription)")
            }
        }
    }
    
    
    // Finder et dokument
//    func getDocument()
//    {
            // lytter til et enkelt dokument
//        collection.document("verdenudenfor").addSnapshotListener
//        {
//            // Swift genere koden til en closure - lige som lamda fra Java.
//            // Det er en metode der er anonym, da den intet navn har - in place
//            (snapshot, error) in
//            // Det vil ikke være en fejl, at der ikke er et dokument der matcher, men i stedet hvis der er noget galt med forbindelsen
//            if error == nil
//            {
//                // data metoden giver os data
//                // let kan aldrig være nil, og if let vil aldrig være true, hvis højreside er nil
//                // optionals af snapshot og data(), som bliver fyldt med data, hvis der er, eller returnere nil hvis ikke
//                if let data = snapshot?.data()
//                {
//                    // Get name on the document
//                    if let name = snapshot?.documentID
//                    {
//                        //snapshot?.data()?.keys // Hvis man skal søge efter nøgler
//
//                        // angive hvilke felter vi skal have fat i
//                        if let rating = data["rating"] as? String
//                        {
//
//                            self.notes.append(Note(title: "\(name) Rating: \(rating)"))
//                            print("rating: \(rating)")
//                        }
//
//                        if let releaseYear = data["releaseYear"] as? String
//                        {
//                            self.notes.append(Note(title: "\(name) Release year: \(releaseYear)"))
//                            print("release year: \(releaseYear)")
//                        }
//                    }
//                }
//            }
//            else
//            {
//                print("Error \(error.debugDescription)")
//            }
//        }
//    }

    
}


