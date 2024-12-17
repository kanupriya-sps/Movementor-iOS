//
//  AddActionSheetView.swift
//  Movementor-fitness
//
//  Created by user on 17/12/24.
//

import SwiftUI

struct AddActionSheetView: View {
    @Binding var isPresented: Bool  // Binding to show/hide ActionSheet
    var onOptionSelected: (String) -> Void  // Callback to communicate back

       var body: some View {
           VStack {
               // This empty view triggers the ActionSheet
           }
           .actionSheet(isPresented: $isPresented) {
               ActionSheet(
                   title: Text("Choose an Action"),
                   message: Text("Select one of the options below"),
                   buttons: [
                       .default(Text("Set Goals")) {
                           onOptionSelected("setGoals")
                           print("Option 1 Selected")
                       },
                       .default(Text("Add Activity")) {
                           onOptionSelected("addActivity")
                           print("Option 2 Selected")
                       },
                       .cancel()
                   ]
               )
           }
       }
}

//#Preview {
//    @State  var isPresented: Bool = true
//    AddActionSheetView(isPresented: $isPresented, onOptionSelected: <#(String) -> Void#>)
//}
