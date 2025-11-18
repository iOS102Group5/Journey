import SwiftUI
import PhotosUI

struct ProfileView: View {
    // Initial values and callbacks
    let onSave: (String, String, String, UIImage?) -> Void
    let onCancel: () -> Void

    private let initialName: String
    private let initialEmail: String
    private let initialBio: String
    private let initialImage: UIImage?

    // Editable state
    @State private var name: String
    @State private var email: String
    @State private var bio: String

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil

    @Environment(\.dismiss) private var dismiss

    init(initialName: String = "",
         initialEmail: String = "",
         initialBio: String = "",
         initialImage: UIImage? = nil,
         onSave: @escaping (String, String, String, UIImage?) -> Void,
         onCancel: @escaping () -> Void) {
        self._name = State(initialValue: initialName)
        self._email = State(initialValue: initialEmail)
        self._bio = State(initialValue: initialBio)
        self._image = State(initialValue: initialImage)
        self.initialName = initialName
        self.initialEmail = initialEmail
        self.initialBio = initialBio
        self.initialImage = initialImage
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Photo") {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            ZStack {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.secondary)
                                }
                            }
                            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                Text("Choose Photo")
                            }
                        }
                        Spacer()
                    }
                }

                Section("Basic Info") {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocorrectionDisabled()

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                }

                Section("Bio") {
                    TextEditor(text: $bio)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(name, email, bio, image)
                        dismiss()
                    }
                    .disabled(!isEmailValid && !email.isEmpty ? true : false)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            self.image = uiImage
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    private var isEmailValid: Bool {
        // Simple email validation; allows empty (user may not want to set email yet)
        if email.isEmpty { return true }
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: regex, options: [.regularExpression, .caseInsensitive]) != nil
    }
}

#Preview {
    ProfileView(
        initialName: "Lucas",
        initialEmail: "lucas@example.com",
        initialBio: "Traveler. Coffee enthusiast. Journal keeper.",
        initialImage: nil,
        onSave: { name, email, bio, image in
            print("Saved:", name, email, bio, image as Any)
        },
        onCancel: {
            print("Cancelled")
        }
    )
}
