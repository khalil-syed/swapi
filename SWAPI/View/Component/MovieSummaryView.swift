//Created on 27/5/20

import SwiftUI

struct MovieSummaryView<T>: View where T: Movie {
    
    let movie: T?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "film")
                    Text(movie?.director ?? "")
                    Image(systemName: "briefcase")
                    Text(movie?.producer ?? "")
                }.font(.footnote)
                Text(movie?.openingCrawl ?? "")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            .padding(.horizontal)
            .padding(.vertical, 0)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(0)
    }
}

struct MovieSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSummaryView(movie: ServiceObjMovie.mock())
    }
}
