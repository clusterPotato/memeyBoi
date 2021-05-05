//
//  ViewController.swift
//  Memey Boi
//
//  Created by Gavin Craft on 5/5/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var memeNameLabel: UILabel!
    @IBOutlet var imageHolder: UIImageView!
    var thisMeme: Meme?
    var thisImage: UIImage?
    var nextImage: UIImage?
    var nextMeme: Meme?
    var workingImage: UIImage?
    var workingMeme: Meme?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        updateViews()
        showToast(message: "Swipe left for a new meme, right to save")
    }
    
    //MARK: - swiper funcs
    @objc func swipedRight(){
        guard let meme = thisMeme else {return}
        guard let image = imageHolder.image else {return}
        InsideFileManager.shared.saveAsPng(image: image, name: meme.title)
        showToast(message: "Saved")
    }
    @objc func swipedLeft(){
        showToast(message: "Getting a new meme")
        if let _ = nextMeme{
            updateViews()
        }
    }
    
    //MARK: - update
    func updateViews(){
        DispatchQueue.main.async{
            guard let nextMeme = self.nextMeme,
                  let nextImage = self.nextImage else {return}
            self.thisMeme = nextMeme
            self.thisImage = nextImage
            guard let thisMeme = self.thisMeme,
                  let thisImage = self.thisImage else {return}
            self.memeNameLabel.text = thisMeme.title
            self.imageHolder.image = nil
            self.imageHolder.image = thisImage
            print(thisImage)
            let combo = self.grabAMeme()
            guard let meme = combo.meme,
                  let image = combo.image else {return}
            self.nextMeme = meme
            self.nextImage = image
            print("next one is ready")
        }
    }
    func grabAMeme() -> Combo{
        MemeController.getMeme { result in
            switch result{
            case .success(let meme):
                self.workingMeme = meme
                MemeController.fetchImage(url: meme.url) { result in
                    switch result{
                    case .success(let returned):
                        self.workingImage = returned
                    case .failure(let err):
                        self.presentErrorToUser(localizedError: err)
                    }
                }
            case .failure(let err):
                self.presentErrorToUser(localizedError: err)
                return
            }
        }
        guard let meeme = workingMeme,
              let image = workingImage else {return Combo(image: nil, meme: nil)}
        return Combo(image: image, meme: meeme)
    }
    func getMemes(){
        if let _ = nextMeme{
            //we have a meme there so do in this order
            let combo = grabAMeme()
            guard let image = combo.image,
                  let meme = combo.meme else {return}
            nextMeme = meme
            nextImage = image
            updateViews()
        }
    }
    func initialLoad(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        MemeController.getMeme { result in
            switch result{
            case .success(let successMeme):
                self.nextMeme = successMeme
                MemeController.fetchImage(url: successMeme.url) { result in
                    switch result{
                    case .success(let image):
                        self.nextImage = image
                    case .failure(let err):
                        self.presentErrorToUser(localizedError: err)
                        return
                    }
                }
            case .failure(let err):
                self.presentErrorToUser(localizedError: err)
                return
            }
        }
    }
}
struct Combo{
    let image: UIImage?
    let meme: Meme?
}
