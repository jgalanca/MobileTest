/**
  MediaCellItem.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class MediaCellItem: GenericCellItem {
    var media: CharacterMedia

    init(key: String, enabled: Bool? = true, media: CharacterMedia) {
        self.media = media
        super.init(key: key, enabled: enabled)
    }
}

class MediaCell: GenericCell {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var descriptionLabel: UILabel?
    @IBOutlet private var mediaImageView: UIImageView?
    private static let cellIdentifier: String = "MediaCellId"
    private static let cellHeight: CGFloat = 100.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //Métodos auxiliares
    override class func getIdentifier() -> String {
        MediaCell.cellIdentifier
    }
    override class func getHeight() -> CGFloat {
        MediaCell.cellHeight
    }

    override func setObject(object: AnyObject) {
        if let item = object as? MediaCellItem {
            self.item = item
            self.titleLabel?.text = item.media.title ?? item.key
            self.descriptionLabel?.text = item.media.mediaDescription ?? ""
            var thumbnail = item.media.thumbnail
            if thumbnail == nil,
               let mediaImages = item.media.images {
                for mediaImage in mediaImages where mediaImage.url != nil {
                    thumbnail = mediaImage
                }
            }

            if let mediaThumbnail = thumbnail {
                self.mediaImageView?.download(image: mediaThumbnail.url)
            }
        }
    }
}
