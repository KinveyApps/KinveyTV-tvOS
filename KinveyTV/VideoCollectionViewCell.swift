//
//  VideoCollectionViewCell.swift
//  KinveyTV
//
//  Created by Victor Hugo on 2017-07-11.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "VideoCell"
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    private lazy var fileStore: FileStore<File> = FileStore<File>()
    
    var video: Video? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        video = nil
        thumbnailImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure() {
        guard let video = video else {
            return
        }
        
        guard let titleLabel = titleLabel else {
            return
        }
        
        titleLabel.text = video.title
        
        let thumbnailFile = File {
            $0.fileId = video.thumbnailFileId
        }
        if let thumbnailFile = fileStore.cachedFile(thumbnailFile),
            let pathURL = thumbnailFile.pathURL
        {
            let image = UIImage(contentsOfFile: pathURL.path)
            thumbnailImageView.image = image
        } else {
            fileStore.download(thumbnailFile) { (result: Result<(File, URL), Swift.Error>) in
                switch result {
                case .success(_, let localURL):
                    guard let thumbnailImageView = self.thumbnailImageView else {
                        return
                    }
                    
                    let image = UIImage(contentsOfFile: localURL.path)
                    thumbnailImageView.image = image
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
    
}
