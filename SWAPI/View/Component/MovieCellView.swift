//Created on 27/5/20

import SwiftUI

struct MovieCellView<T>: View where T: Movie {
    
    let movie: T
    
    var body: some View {
        HStack {
            Text(movie.title ?? "")
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 8, height: 14)
                .foregroundColor(.blue)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct MovieButton<T>: View where T: Movie {
    
    let movie: T
    @Binding var navigateToDetails: Bool
    @Binding var selectedMovie: T?
    
    var body: some View {
        Button(action: action) {
            MovieCellView(movie: movie)
        }
    }
    
    func action() {
        selectedMovie = movie
        navigateToDetails = true
    }
}

struct MovieCellView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCellView(movie: ServiceObjMovie.mock())
    }
}
