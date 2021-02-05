import FirebaseStorage



class ImageUploader {
    static let shared = ImageUploader()
    
    
    func uploadImage(path: String, image: UIImage, compleation: @escaping(String?, Error?)->Void){
        let img = image.resized(to: CGSize(width: 600, height: 600))
        guard let imageData = img.jpegData(compressionQuality: 0.7) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/\(path)/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                compleation(nil, error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                compleation(imageUrl, nil)
            }
        }
        
    }
    
    
    
}
