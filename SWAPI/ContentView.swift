//Created on 27/5/20

import SwiftUI

struct MoviesListView<T>: View where T: Movie {
    
    @ObservedObject var viewModel: MoviesViewModel<T>
    
    var body: some View {
        List {
            ForEach(self.viewModel.moviesList) { movie in
                Text(movie.name ?? "")
                    .frame(minHeight: 0, maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView<MovieObj>(viewModel: MoviesViewModel())
    }
}
