//Created on 27/5/20

import SwiftUI

struct MainView: View {
    
    var body: some View {
        NavigationView {
            MoviesListView<CDMovie>(viewModel: MoviesViewModel())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
