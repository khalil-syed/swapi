//Created on 27/5/20

import SwiftUI

struct CharacterCellView<T>: View where T: People {
    
    let people: T
    
    var body: some View {
        HStack {
            Text(people.name ?? "")
            Text("Loading")
        }
    }
}

struct CharacterCellView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCellView(people: ServiceObjPeople.mock(id: 0))
    }
}
