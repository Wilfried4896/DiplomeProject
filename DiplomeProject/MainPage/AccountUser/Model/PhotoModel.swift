
import UIKit

struct Picture {
    private init() { }
    
    static var imageData: [UIImage] {
        var image = [UIImage]()
        let dataImage = ["images.jpeg","images-2.jpeg", "images-3.jpeg", "images-4.jpeg", "images-5.jpeg",
                         "images-6.jpeg", "images-7.jpeg"]
        
        dataImage.forEach { name in
            image.append(UIImage(named: name)!)
        }
        return image
    }
    
    static func iamgesGalery() -> [UIImage] {
        var galery = [UIImage]()
        
        let data = ["images.jpeg","images-2.jpeg", "images-3.jpeg", "images-4.jpeg", "images-5.jpeg",
                    "images-6.jpeg", "images-7.jpeg", "images-8.jpeg", "images-9.jpeg", "images-10.jpeg",
                    "images-11.jpeg", "images-12.jpeg", "images-13.jpeg", "images-14.jpeg", "images-15.jpeg",
                    "images-16.jpeg", "images-17.jpeg", "images-18.jpeg", "images-19.jpeg", "images-20.jpeg",
                    "images-21.jpeg",
        ]
        
        for name in data {
            galery.append(UIImage(named: name)!)
        }
        
        return galery
    }
}
