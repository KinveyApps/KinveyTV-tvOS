//
//  MainCollectionViewController.swift
//  KinveyTV
//
//  Created by Victor Hugo on 2017-07-11.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey
import AVKit

class MainCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    var videos = [Video]()
    
    func loadData() {
        store.find() { (result: Result<[Video], Swift.Error>) in
            switch result {
            case .success(let videos):
                self.videos = videos
                self.collectionView?.reloadData()
            case .failure(let error):
                print("\(error)")
                self.loadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var store = DataStore<Video>.collection()
    
    static let playSegue = "play"
    static let backSegue = "back"
    
    private lazy var fileStore: FileStore<File> = FileStore<File>()

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case MainCollectionViewController.playSegue:
            guard let playerViewController = segue.destination as? AVPlayerViewController else {
                return
            }
            guard let collectionView = collectionView else {
                return
            }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
                return
            }
            let video = videos[indexPath.item]
            guard let videoFileId = video.videoFileId else {
                return
            }
            let file = File {
                $0.fileId = videoFileId
            }
            fileStore.refresh(file) { (result: Result<File, Swift.Error>) in
                switch result {
                case .success(let file):
                    guard let url = file.downloadURL else {
                        return
                    }
                    let player = AVPlayer(url: url)
                    var observer: Any? = nil
                    observer = NotificationCenter.default.addObserver(
                        forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                        object: nil,
                        queue: OperationQueue.main,
                        using: { (notification) in
                            NotificationCenter.default.removeObserver(
                                observer!,
                                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                object: nil
                            )
                            observer = nil
                            playerViewController.player = nil
                            playerViewController.performSegue(
                                withIdentifier: MainCollectionViewController.backSegue,
                                sender: notification
                            )
                        }
                    )
                    playerViewController.player = player
                    player.play()
                case .failure(let error):
                    print("\(error)")
                }
            }
        default:
            return
        }
    }
    
    @IBAction
    func unwindToMain(segue: UIStoryboardSegue) {
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
    
        cell.video = videos[indexPath.item]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: MainCollectionViewController.playSegue, sender: collectionView)
    }

}
