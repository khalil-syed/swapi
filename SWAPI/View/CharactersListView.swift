//Created on 27/5/20

import SwiftUI

struct CharactersListView: View {
    
    @ObservedObject var viewModel: CharactersViewModel
    
    var list: some View {
        List {
            ForEach(self.viewModel.charactersList, id: \.url) { people in
                Text(people.name ?? "")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
    
    var lblStatus: some View {
        Text(viewModel.statusMessage ?? "")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    var body: some View {
        Group {
            if !viewModel.charactersList.isEmpty { list }
            else { lblStatus }
        }
        .onAppear { self.viewModel.onAppear() }
    }
}

struct CharactersListView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListView(viewModel: CharactersViewModel(characterList: [ServiceObjPeople.mock(id: 0)]))
    }
}
