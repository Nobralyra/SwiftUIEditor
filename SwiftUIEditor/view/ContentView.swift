//
//  ContentView.swift
//  SwiftUIEditor
//
//  Created by admin on 11/09/2020.
//  Copyright © 2020 Signe. All rights reserved.


import SwiftUI

struct ContentView: View
{
    // Er subsribed til Repo(), så den bliver informeret når Repo() ændre sig
    @ObservedObject var repo = Repo() // 2-way binding
    var body: some View
    {
        // Skifter hele viewet ud med et nyt
        NavigationView
        {
            VStack
            {
                // kunne tilføje en ny note på repo objektet
                // Da den er subscribed til Repo klassen
                // Aflevere et nyt view tilbage med to closures
                // Action og Text er 2 metoder
                List
                {
                    // note in er hver objekt i listen
                    ForEach(self.repo.notes)
                    {
                        note in
                        // Er DetailViews constrocter vi har fat i
                        //NavigationLink(destination: DetailView(text: note.title, currentImage: note.image, currentID: note.id, repo: self.repo, currentNote: note))
                        NavigationLink(destination: DetailView(repo: self.repo, currentNote: note))
                        {
                            //Text(note.title)
                            // kunne klikke på hvert objekt
                            // vis denne note i DetailView
                            note.image
                        }
                    }
                }
            }
            .navigationBarItems(trailing: Button ( action:
            {
                self.repo.addNote(note: (Note(title: "Note", imageName: "", id: UUID())))
                print("Button press")
            })
            {
                Image(systemName: "plus").imageScale(.large)
            })
            
            .navigationBarTitle(Text("Notes"))
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
