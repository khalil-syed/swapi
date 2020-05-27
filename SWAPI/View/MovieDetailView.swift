//Created on 27/5/20

import SwiftUI

struct MovieDetailView<T>: View where T: Movie {
    
    let movie: T?
    
    var body: some View {
        TabView {
            MovieSummaryView(movie: movie)
                .tabItem {
                    Image(systemName: "film.fill")
                    Text("Movie")
            }
            
            CharactersListView(viewModel:
                CharactersViewModel(characterList: movie?.characterList() ?? []))
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Characters")
            }
        }.navigationBarTitle(movie?.title ?? "")
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: ServiceObjMovie.mock())
    }
}
