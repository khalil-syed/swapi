//Created on 27/5/20

import SwiftUI

struct MoviesListView<T>: View where T: Movie {
    
    @ObservedObject var viewModel: MoviesViewModel<T>
    
    var list: some View {
        List {
            ForEach(self.viewModel.moviesList) { movie in
                MovieButton<T>(movie: movie,
                            navigateToDetails: self.$viewModel.navigateToDetails,
                            selectedMovie: self.$viewModel.selectedMovie)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    var lblStatus: some View {
        Text(viewModel.statusMessage ?? "")
            .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    var body: some View {
        Group {
            if !viewModel.moviesList.isEmpty { list }
            else { lblStatus }
        }
        .navigationBarTitle("Movies")
        .background(NavigationLink(destination:
            MovieDetailView<T>(movie: self.viewModel.selectedMovie),
                                   isActive: self.$viewModel.navigateToDetails,
                                   label: {EmptyView()}))
        .onAppear { self.viewModel.onAppear() }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView<ServiceObjMovie>(viewModel: MoviesViewModel())
    }
}
