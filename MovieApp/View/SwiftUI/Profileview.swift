//
//  Profileview.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 07/11/25.
//

import SwiftUI

struct ProfileView: View {
    let username: String
    
    let onLogout: () -> Void
    @State private var showLogoutConfirm = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .shadow(radius: 4)
                    Text(username)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textSelection(.enabled)
                }
                Button(role: .destructive) { showLogoutConfirm = true } label: {
                    Label("Logout", systemImage: "arrow.backward.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showLogoutConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm", role: .destructive) { onLogout() }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(username: "demo_user") { }
    }
}
#endif
